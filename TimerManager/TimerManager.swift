//
//  TimerCenter.swift
//  TimerTaskDemo
//
//  Created by 小六 on 2018/11/20.
//  Copyright © 2018 小六. All rights reserved.
//

import Foundation

final public class TimerManager {
    /// total count after Timer begin.
    var count: UInt = 0
    var isRunning: Bool = false
    var duration: Float {
        return Float(count) / 2.0;
    }

    static let manager = TimerManager()
    fileprivate var items = [TimerItem]()
    fileprivate let queue = DispatchQueue(label: "com.timertask.manager")
    fileprivate let timer: DispatchSourceTimer

    private init() {

        timer = DispatchSource.makeTimerSource(flags: [.strict], queue: DispatchQueue.global())
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: .milliseconds(500), leeway: .milliseconds(10))
        timer.setEventHandler { [weak self] in

            self?.timerAction()
        }
    }

    private func beginTimerIfNeed() {
        if !isRunning {
            count = 0;
            isRunning = true
            timer.resume()
        }
    }

    private func stopTimerIfNeed() {
        if isRunning {
            timer.suspend()
            count = 0
            isRunning = false
        }
    }
    /// Add task to manager, don't forget to call `remove` when task release.
    func add(_ task: Timerable) -> Bool {

        beginTimerIfNeed()
        guard task.isValid() else {
            print("TimerCenter: add failed, task is invalid.")
            return false
        }
        var result = false
        let item: TimerItem = TimerItem.init(target: task)
        let semaphore = DispatchSemaphore(value: 0)
        queue.async(group: nil, qos: .userInitiated, flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            if !strongSelf.items.contains(item) {
                strongSelf.items.append(item)
                result = true
            }
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
    /// Remove task.
    /// called when the object is released or reach the specified repeatCount.
    func remove(_ task: Timerable) -> Bool {
        var result = false
        let item = TimerItem.init(target: task)
        let semaphore = DispatchSemaphore(value: 0)
        queue.async(group: nil, qos: .userInitiated, flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            if let index = strongSelf.items.firstIndex(of: item) {
                strongSelf.items.remove(at: index)
                strongSelf.stopTimerIfNeed()
                result = true
            }
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }

    private func timerAction() {
        count += 1;
        var indexSet = IndexSet()
        queue.async { [weak self] in
            guard let strongSelf = self else { return }
            for (index, value) in strongSelf.items.enumerated() {
                value.step += 1;
                let actionCount = value.target.timerInterval() * 2;
                guard value.step % actionCount == 0 else {
                    continue
                }
                value.repeatCount += 1
                let isComplete = (value.repeatCount == value.target.repeatCount())
                DispatchQueue.main.async {
                    value.target.onResponse(repeatCount: value.repeatCount, isComplete: isComplete)
                }
                if value.repeatCount >= value.target.repeatCount() {
                    indexSet.insert(index)
                }
            }
        }
        queue.async(group: nil, qos: .userInitiated, flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            for index in indexSet.reversed() {
                strongSelf.items.remove(at: index)
            }
        }
    }
}

fileprivate class TimerItem: Equatable {
    var target: Timerable
    var step: UInt = 0
    var repeatCount: UInt = 0

    init(target: Timerable) {
        self.target = target
    }

    static func ==(lhs: TimerItem, rhs: TimerItem) -> Bool {
        return lhs.target === rhs.target
    }
}
