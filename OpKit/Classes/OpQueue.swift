//
//  OpQueue.swift
//  Pods
//
//  Created by Göksel Köksal on 18/04/16.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public class OpQueue {
    
    // MARK: Properties
    
    private let queue = NSOperationQueue()
    
    // MARK: Constructors
    
    public init() { }
    
    // MARK: Public methods
    
    public func execute(op: Op, completion: Block?) {
        
        var resultingOp: NSOperation = op
        
        if let completion = completion {
            
            let completionOp = NSBlockOperation(block: completion)
            completionOp.addDependency(resultingOp)
            resultingOp = completionOp
        }
        
        addOp(resultingOp)
    }
    
    public func execute(ops: [Op], concurrent: Bool = false, completion: Block?) {
        
        if concurrent {
            executeConcurrently(ops, completion: completion)
        }
        else {
            executeInOrder(ops, completion: completion)
        }
    }
    
}

// MARK: - Helpers

private extension OpQueue {
    
    func addOp(op: NSOperation) {
        
        for dependencyOp in op.dependencies {
            addOp(dependencyOp)
        }
        
        let notAddedYet = (queue.operations.contains(op) == false)
        let notConsumed = (op.cancelled == false && op.executing == false && op.finished == false)
        
        if notAddedYet && notConsumed {
            queue.addOperation(op)
        }
    }
    
    func executeInOrder(ops: [Op], completion: Block?) {
        
        guard ops.count > 0 else {
            completion?()
            return
        }
        
        for (index, op) in ops.enumerate() {
            
            let nextIndex = index + 1
            if nextIndex < ops.count {
                let nextOp = ops[nextIndex]
                nextOp.addDependency(op)
            }
        }
        
        let lastOp = ops.last! // Non-nil for sure because of guard statement.
        
        if let completion = completion {
            
            let completionOp = NSBlockOperation(block: completion)
            completionOp.addDependency(lastOp)
            addOp(completionOp)
        }
        else {
            addOp(lastOp)
        }
    }
    
    func executeConcurrently(ops: [Op], completion: Block?) {
        
        guard ops.count > 0 else {
            completion?()
            return
        }
        
        var operations = [NSOperation]()
        
        if let completion = completion {
            
            let completionOp = NSBlockOperation(block: completion)
            for op in ops {
                completionOp.addDependency(op)
            }
            operations.append(completionOp)
        }
        
        for op in operations {
            addOp(op)
        }
    }
    
}
