//
//  BlockOp.swift
//  Pods
//
//  Created by Göksel Köksal on 18/04/16.
//
//

import Foundation

public class BlockOp: Op {
    
    private let block: Block
    
    override public var asynchronous: Bool {
        return false
    }
    
    public init(block: Block) {
        self.block = block
    }
    
    public override func execute(finishingBlock: Block) {
        
        block()
        finishingBlock()
    }
    
}
