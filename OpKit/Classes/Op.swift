//
//  Op.swift
//  Koin
//
//  Created by Göksel Köksal on 14/04/16.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public class Op: NSOperation {
    
    // MARK: Types
    
    public enum State {
        
        case Ready
        case Executing
        case Finished
    }
    
    private struct KeyPath {
        static let state = "state"
    }
    
    // MARK: KVO
    
    class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
        return [KeyPath.state]
    }
    
    class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
        return [KeyPath.state]
    }
    
    class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
        return [KeyPath.state]
    }
    
    // MARK: -
    
    // MARK: Properties
    
    public var error: ErrorType?
    
    public var state = State.Ready {
        willSet {
            willChangeValueForKey(KeyPath.state)
        }
        didSet {
            didChangeValueForKey(KeyPath.state)
        }
    }
    
    override public var ready: Bool {
        
        guard cancelled == false else {
            return true
        }
        
        return (super.ready && state == .Ready)
    }
    
    override public var executing: Bool {
        return state == .Executing
    }
    
    override public var finished: Bool {
        return state == .Finished
    }
    
    // MARK: Constructors
    
    override public init() {
        super.init()
        willChangeValueForKey(KeyPath.state)
        didChangeValueForKey(KeyPath.state)
    }
    
    // MARK: Methods
    
    override public final func start() {
        
        dependenciesDidFinishExecuting()
        
        guard cancelled == false else {
            finish()
            return
        }
        
        willStart()
        state = .Executing
        
        if asynchronous {
            NSThread.detachNewThreadSelector(#selector(main), toTarget: self, withObject: nil)
        }
        else {
            main()
        }
    }
    
    override public final func main() {
        
        guard (error == nil && cancelled == false) else {
            finish()
            return
        }
        
        execute { [unowned self] in
            self.finish()
        }
    }
    
    override public final func cancel() {
        willCancel()
        super.cancel()
    }
    
    final func finish() {
        willFinish()
        state = .Finished
    }
    
    private func dependenciesDidFinishExecuting() {
        
        guard error == nil else {
            return
        }
        
        for dependency in dependencies {
            
            guard let dependency = dependency as? Op else {
                continue
            }
            
            if let dependencyError = dependency.error {
                error = dependencyError
                break
            }
        }
    }
    
    // MARK: Override
    
    public func execute(finishingBlock: Block) {
        
        print("\(self.dynamicType) must override `main(finishingBlock:_)`.")
        finishingBlock()
    }
    
    public func willStart() {
        // For use by subclassers.
    }
    
    public func willFinish() {
        // For use by subclassers.
    }
    
    public func willCancel() {
        // For use by subclassers.
    }
    
}

extension Op {
    
    func addCompletionBlock(block: Block) {
        completionBlock += block
    }
    
}
