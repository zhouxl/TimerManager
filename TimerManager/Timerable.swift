//
//  Timerable.swift
//  TimerTaskDemo
//
//  Created by 小六 on 2018/11/21.
//  Copyright © 2018 小六. All rights reserved.
//

import Foundation

public protocol Timerable: AnyObject {
    // interval task is called. default is 1 second.
    // @return second.
    func timerInterval() -> UInt
    // called after `timerInterval()`
    func onResponse(repeatCount: UInt, isComplete: Bool)
    // called count,default UInt.max
    func repeatCount() -> UInt
    // validity of task, repeatCount > 0 && interval > 0
    func isValid() -> Bool
}

extension Timerable {
    func timerInterval() -> UInt {
        return 1
    }

    func onResponse(repeatCount: UInt, isComplete: Bool) {

    }

    func repeatCount() -> UInt {
        return UInt.max
    }

    func isValid() -> Bool {
        let valid = self.repeatCount() > 0 && self.timerInterval() > 0
        return valid
    }
}
