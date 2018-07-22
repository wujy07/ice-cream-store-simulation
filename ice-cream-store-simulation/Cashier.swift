//
//  Cashier.swift
//  ice-cream-store-simulation
//
//  Created by 吴俊演 on 24/07/2018.
//  Copyright © 2018 吴俊演. All rights reserved.
//

import Foundation

public class Cashier {
    
    let checkoutRequestSemaphore = DispatchSemaphore.init(value: 0)
    let getQueueNumberSemaphore = DispatchSemaphore.init(value: 1)
    
    var number: Int = 0
    var customerSemaphores = [DispatchSemaphore]()
    
    init(totalCustomers: Int) {
        for _ in 1...totalCustomers {
            let customerSemaphore = DispatchSemaphore.init(value: 0)
            customerSemaphores.append(customerSemaphore)
        }
    }
    
    func checkout(index: Int) {
        print("Cashier is checking out the NO.\(index) customer...")
        sleep(1)
        print("Cashier finished checking out.")
    }
    
    func work() {
        for (index, _) in customerSemaphores.enumerated() {
            checkoutRequestSemaphore.wait()
            checkout(index: index)
            customerSemaphores[index].signal()
        }
        print("All the customer are checked out.")
    }
}
