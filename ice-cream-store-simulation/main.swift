//
//  main.swift
//  ice-cream-store-simulation
//
//  Created by 吴俊演 on 22/07/2018.
//  Copyright © 2018 吴俊演. All rights reserved.
//

import Foundation

public struct Global {
    static let totalCustomers = 10
    static var inspectionRequestSemaphone = DispatchSemaphore.init(value: 0)
    static var passed: Bool = false
    static var doorLockSemaphore = DispatchSemaphore.init(value: 0)
    static var isInspectionFinishedSemaphore = DispatchSemaphore.init(value: 0)
    static var cashier = Cashier(totalCustomers: totalCustomers)
}

var totalCones: UInt32 = 0

for _ in 1...Global.totalCustomers {
    let customer = Customer()
    totalCones += customer.numConesNeeded
    customer.run()
}

print("The manager must hold \(totalCones) cones.")

let manager = Manager(totalCones: totalCones)
manager.work()
Global.cashier.work()

RunLoop.main.run()







