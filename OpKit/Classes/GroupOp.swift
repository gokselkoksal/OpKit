//
//  GroupOp.swift
//  Pods
//
//  Created by Göksel Köksal on 18/04/16.
//
//

import Foundation

public class GroupOp: Op {
    
    private let internalQueue = OpQueue()
    private let ops: [Op]
    private let executeConcurrently: Bool
    
    override public var asynchronous: Bool {
        return true
    }
    
    public init(_ ops: [Op], concurrent: Bool = true) {
        
        self.ops = ops
        self.executeConcurrently = concurrent
        super.init()
    }
    
    override public func execute(finishingBlock: Block) {
        
        internalQueue.execute(ops, concurrent: executeConcurrently) { [unowned self] in
            
            for op in self.ops {
                if let opError = op.error {
                    self.error = opError
                    break
                }
            }
            
            finishingBlock()
        }
    }
}
