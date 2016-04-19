//
//  WelcomeOperation.swift
//  OpKit
//
//  Created by Göksel Köksal on 18/04/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import OpKit

class WelcomeOp: Op {
    
    private let loginOp: LoginOp
    private(set) var greeting = ""
    
    override var asynchronous: Bool {
        return false
    }
    
    init(username: String) {
        self.loginOp = LoginOp(username: username, password: "123")
        super.init()
        addDependency(loginOp)
    }
    
    override func execute(finishingBlock: Block) {
        
        greeting = "Welcome \(loginOp.user)!"
        print(greeting)
        finishingBlock()
    }
    
    override func willFinish() {
        print("\(self) will finish with error: \(error)")
    }
    
}
