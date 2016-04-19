//
//  Definitions.swift
//  Pods
//
//  Created by Göksel Köksal on 18/04/16.
//
//

import Foundation

public typealias Block = (() -> Void)

public func + (left: Block?, right: Block?) -> Block? {
    
    if let left = left {
        return {
            left()
            right?()
        }
    }
    else if let right = right {
        return {
            left?()
            right()
        }
    }
    else {
        return nil
    }
}

public func += (inout left: Block?, right: Block?) {
    left = left + right
}
