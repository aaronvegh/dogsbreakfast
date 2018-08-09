//
//  UIImageView+Async.swift
//  DogsBreakfast
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// Quick 'n' dirty async image fetch operation
    /// Could use some caching, bark time!
    public func imageFromServerURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.image = image
                }
            }
        }).resume()
    }}
