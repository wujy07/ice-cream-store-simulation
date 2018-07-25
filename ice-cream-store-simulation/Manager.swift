//
//  Manager.swift
//  ice-cream-store-simulation
//
//  Created by 吴俊演 on 24/07/2018.
//  Copyright © 2018 吴俊演. All rights reserved.
//

import Foundation

public class Manager {

    let totalCones: UInt32

    var approvedCones: UInt32 = 0
    var inspectedCones: UInt32 = 0

    init(totalCones: UInt32) {
        self.totalCones = totalCones
        Global.doorLockSemaphore.signal()
    }

    func makeInspection() {
        print("Manager is inspecting the clerk's cone...")
        sleep(1)
        print("Manager finish inspecting.")
    }
    
    @objc
    private func work() {
        while self.approvedCones < self.totalCones {
            print("Manager is waiting for clerk's inpection request...")
            Global.inspectionRequestSemaphone.wait()
            self.makeInspection()
            self.inspectedCones += 1;
            Global.passed = true//arc4random_uniform(1) == 1
            if Global.passed {
                self.approvedCones += 1
            }
            Global.isInspectionFinishedSemaphore.signal()
        }
    }

    func workAsync() {
        Thread(target: self, selector: #selector(work), object: nil).start()
    }
}
