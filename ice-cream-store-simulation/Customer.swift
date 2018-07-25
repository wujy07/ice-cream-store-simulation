//
//  Customer.swift
//  ice-cream-store-simulation
//
//  Created by 吴俊演 on 24/07/2018.
//  Copyright © 2018 吴俊演. All rights reserved.
//

import Foundation

public class Customer {

    let numConesNeeded: UInt32

    init() {
        //generate a random integer between 1 and 4
        numConesNeeded = 1 + arc4random_uniform(3)
    }

    func runAsync() {
        Thread(target: self, selector: #selector(run), object: nil).start()
    }

    @objc
    private func run() {
        let finishConeSemaphore = DispatchSemaphore.init(value: 0)
        print("Customer ask clerk to make cones.")
        for _ in 1...self.numConesNeeded {
            let clerk = Clerk(finishConeSemaphore: finishConeSemaphore)
            clerk.workAsync()
        }
        print("Customer is waiting clerk to finish.")
        for _ in 1...self.numConesNeeded {
            finishConeSemaphore.wait()
        }
        print("A customer's cones are finished, he get the cones and walk to cashier")
        Global.cashier.getQueueNumberSemaphore.wait()
        let queueNumber = Global.cashier.number
        print("Customer get the queue number: \(queueNumber)")
        Global.cashier.number += 1
        Global.cashier.getQueueNumberSemaphore.signal()
        Global.cashier.checkoutRequestSemaphore.signal()
        print("customer is waiting cashier's notification when finished...")
        Global.cashier.customerSemaphores[queueNumber].wait()
    }
}
