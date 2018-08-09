//
//  ConcurrentOperation.swift
//  DogsBreakfast
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import Foundation

/// A ConcurrentOperation handles the KVC values, making the isExecuting and isFinished properties readily available
/// Provides implementation of completeOperation(), which ensures our ops are tidied up properly.
/// Ensure any subclass calls completeOperation() in its main() at any exit path!

class ConcurrentOperation: Operation {
    private var backingExecuting : Bool
    override var isExecuting : Bool {
        get { return backingExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            backingExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var backingFinished : Bool
    override var isFinished : Bool {
        get { return backingFinished }
        set {
            willChangeValue(forKey: "isFinished")
            backingFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override init() {
        backingExecuting = false
        backingFinished = false
        
        super.init()
    }
    
    func completeOperation() {
        isExecuting = false
        isFinished = true
    }
}
