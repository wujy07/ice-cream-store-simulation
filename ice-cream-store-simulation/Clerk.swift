//
//  Clerk.swift
//  ice-cream-store-simulation
//
//  Created by 吴俊演 on 23/07/2018.
//  Copyright © 2018 吴俊演. All rights reserved.
//

import Foundation

public class Clerk {
    let finishConeSemaphore: DispatchSemaphore
    init(finishConeSemaphore: DispatchSemaphore) {
        self.finishConeSemaphore = finishConeSemaphore
    }
    
    func makeCone() {
        print("Clerk is making the cone...")
        sleep(1)
        print("Clerk finish making cone.")
    }

    @objc
    private func work() {
        var passed = false
        while !passed {
            self.makeCone()
            print("Clerk go to manager's door and wait until the door open.")
            Global.doorLockSemaphore.wait()
            print("Manager's door is opened, clerk send inspection request to manager.")
            Global.inspectionRequestSemaphone.signal()
            Global.isInspectionFinishedSemaphore.wait()
            passed = Global.passed
            print("Clerk get manger's inspection result and leave manager's office.")
            Global.doorLockSemaphore.signal()
        }
        self.finishConeSemaphore.signal()
    }

    func workAsync() {
        Thread(target: self, selector: #selector(work), object: nil).start()
    }
}
