//
//  ViewController.swift
//  OpKit
//
//  Created by Goksel Koksal on 04/18/2016.
//  Copyright (c) 2016 Goksel Koksal. All rights reserved.
//

import UIKit
import OpKit

class ViewController: UIViewController {
    
    let queue = OpQueue()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        testDependencies()
        testGroupOp()
//        testMultipleOps()
    }
    
    // MARK: Test methods
    
    func testDependencies() {
        
        let op1 = BlockOp { print("op1 did finish.") }
        let op11 = BlockOp { print("op11 did finish.") }
        let op111 = BlockOp { print("op111 did finish.") }
        let op2 = BlockOp { print("op2 did finish.") }
        let op21 = BlockOp { print("op21 did finish.") }
        let op22 = BlockOp { print("op22 did finish.") }
        
        op1.addDependency(op11)
        op11.addDependency(op111)
        
        op2.addDependency(op21)
        op2.addDependency(op22)
        op2.completionBlock = {
            print("op2 did complete.")
        }
        
        print("starting...")
        queue.execute([op1, op2]) {
            print("finished!")
        }
    }
    
    func testMultipleOps() {
        
        let welcomeOp1 = WelcomeOp(username: "GK")
        let welcomeOp2 = WelcomeOp(username: "SS")
        
        queue.execute([welcomeOp2, welcomeOp1], concurrent: false) {
            
            print("All users are welcome!")
        }
    }
    
    func testGroupOp() {
        
        let welcomeOp1 = WelcomeOp(username: "GK")
        let welcomeOp2 = WelcomeOp(username: "SS")
        
        let groupOp = GroupOp([welcomeOp1, welcomeOp2])
        
        queue.execute(groupOp) {
            if let error = groupOp.error {
                print("error: \(error)")
            }
            print("All users are welcome!")
        }
    }

}
