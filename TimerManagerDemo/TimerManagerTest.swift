//
//  TimerManagerTest.swift
//  TimerTaskDemo
//
//  Created by 小六 on 2018/11/21.
//  Copyright © 2018 小六. All rights reserved.
//

import UIKit

class TimerManagerTest {
    let father = Father()
    var sun: Sun? {
        didSet {
            print(father)
        }
    }

    func test() {
        sun = Sun()
        var result = false
        result = TimerManager.manager.add(sun!)
        result = TimerManager.manager.add(father)
        print(result)
        result = TimerManager.manager.add(father)
        print(result)
    }
}

class Father: Timerable {

    func timerInterval() -> UInt {
        return 3
    }

    func onResponse(repeatCount: UInt, isComplete: Bool) {
        print("father \(repeatCount) \(CACurrentMediaTime())")
    }

}

class Sun: Timerable {

    func onResponse(repeatCount: UInt, isComplete: Bool) {
        print("sun \(repeatCount)")
    }

    func repeatCount() -> UInt {
        return 10
    }
}
