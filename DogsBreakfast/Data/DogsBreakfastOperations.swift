//
//  DogsBreakfastOperations.swift
//  DogsBreakfast
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import Foundation

/// An OperationQueue subclass that cancels ops in progress when a new one is added.
class DogsBreakfastOperationQueue: OperationQueue {
    override func addOperation(_ op: Operation) {
        if operations.count > 0 {
            operations.forEach({ $0.cancel() })
        }
        super.addOperation(op)
    }
}

class DogsBreakfastOperation: ConcurrentOperation {
    
    /// Possible responses for network operations
    enum OperationResponse {
        case success([Recipe])
        case failure
    }
    
    /// The callback for data from this operation
    var completedData: ((OperationResponse) -> Void)?
    
    private var task: URLSessionDataTask?
    private var queryString: String?
    
    init(query: String) {
        self.queryString = query
        super.init()
    }
    
    override func main() {
        if isCancelled {
            completeOperation()
            return
        }
        
        /// Ensure we have a query string and that it's properly encoded (spaces are an issue, for example)
        guard
            let queryString = queryString,
            let encodedQuery = queryString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { self.completeOperation(); return }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 2
        let session = URLSession(configuration: config)
        let request = URLRequest(url: URL(string: "http://www.recipepuppy.com/api/?q=\(encodedQuery)")!)
        
        /// Build the network operation
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if self.isCancelled {
                self.completeOperation()
                return
            }
            
            /// Bail on error, so we can trigger a re-attempt
            if error != nil {
                self.completedData?(.failure)
                self.completeOperation()
                return
            }
            
            /// process the response
            do {
                guard let data = data else { self.completeOperation(); return }
                let recipeResult = try JSONDecoder().decode(RecipeResult.self, from: data)
                if let recipes = recipeResult.results {
                    self.completedData?(.success(recipes))
                }
                self.completeOperation()
            } catch (let error) {
                print("Error decoding server data: \(error.localizedDescription)")
                self.completedData?(.failure)
                self.completeOperation()
            }
        })
        
        task?.resume()
    }
}
