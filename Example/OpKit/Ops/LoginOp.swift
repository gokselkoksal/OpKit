//
//  LoginOp.swift
//  OpKit
//
//  Created by Göksel Köksal on 18/04/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import OpKit

class LoginOp: Op {
    
    private var username: String
    private var task: NSURLSessionTask? = nil
    
    var user: String = ""
    
    override var asynchronous: Bool {
        return false
    }
    
    init(username: String, password: String) {
        self.username = username
        super.init()
    }
    
    override func execute(finishingBlock: (() -> Void)) {
        
        if username == "GK" {
            self.error = NSError(domain: "GK", code: 1000, userInfo: nil)
            finishingBlock()
            return
        }
        
        let url = NSURL(string: "https://httpbin.org/get")!
        self.task = NSURLSession.sharedSession().dataTaskWithURL(url) { [unowned self] (data, response, error) in
            self.error = error
            self.user = self.mockedUser()
            finishingBlock()
        }
        self.task?.resume()
    }
    
    override func willCancel() {
        self.task?.cancel()
    }
    
}

private extension LoginOp {
    
    func mockedUser() -> String {
        if username == "GK" {
            return "Goksel Koksal"
        }
        else if username == "SS" {
            return "Sila Sener"
        }
        else {
            return ""
        }
    }
    
}
