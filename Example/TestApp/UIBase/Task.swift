//
// Created by entaoyang@163.com on 2017/10/10.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit
import Dispatch

typealias TaskBlock = () -> Void

fileprivate var onceSet: Set<String> = Set<String>()

private func disTime(_ sec: Double) -> DispatchTime {
	return DispatchTime.now() + sec
}

class ScheduleItem {
	fileprivate var block: TaskBlock? = nil

	func cancel() {
		block = nil
	}
}

class Task {
	static func back(_ block: @escaping TaskBlock) {
		DispatchQueue.global(qos: .background).async(execute: block)
	}

	static func fore(_ block: @escaping TaskBlock) {
		DispatchQueue.main.async(execute: block)
	}

	static func foreDelay(_ second: Double, _ block: @escaping TaskBlock) {
		DispatchQueue.main.asyncAfter(deadline: disTime(second), execute: block)
	}

	static func backDelay(_ second: Double, _ block: @escaping TaskBlock) {
		DispatchQueue.global(qos: .background).asyncAfter(deadline: disTime(second), execute: block)
	}

	static func foreSchedule(_ second: Double, _ block: @escaping TaskBlock) -> ScheduleItem {
		let item = ScheduleItem()
		item.block = block
		DispatchQueue.main.asyncAfter(deadline: disTime(second)) {
			item.block?()
			item.block = nil
		}
		return item
	}

	static func runOnce(_ key: String, _ block: () -> Void) {
		if !onceSet.contains(key) {
			onceSet.insert(key)
			block()
		}
	}
}

class Sync {
	private let obj: Any
	private var state: Int = 0

	init(_ obj: Any) {
		self.obj = obj
		state = 0
	}

	@discardableResult
	func enter() -> Sync {
		objc_sync_enter(self.obj)
		state = 1
		return self
	}

	func exit() {
		objc_sync_exit(self.obj)
		state = 2
	}

	deinit {
		if self.state == 1 {
			self.exit()
		}
	}
}

func sync(_ obj: Any, _ block: () -> Void) {
	objc_sync_enter(obj)
	defer {
		objc_sync_exit(obj)
	}
	block()
}

func syncRet<T>(_ obj: Any, _ block: () -> T) -> T {
	objc_sync_enter(obj)
	defer {
		objc_sync_exit(obj)
	}
	return block()
}

class TaskQueue {
	let queue: DispatchQueue

	init(_ label: String) {
		self.queue = DispatchQueue(label: label, qos: .default)
	}

	func fore(_ block: @escaping BlockVoid) {
		DispatchQueue.main.async(execute: block)
	}

	func foreDelay(seconds: Double, _ block: @escaping BlockVoid) {
		let a = DispatchTime.now() + seconds
		DispatchQueue.main.asyncAfter(deadline: a, execute: block)
	}

//	func sync(_ block: @escaping BlockVoid) {
//		self.queue.sync(execute: block)
//	}

	func backDelay(seconds: Double, _ block: @escaping BlockVoid) {
		let a = DispatchTime.now() + seconds
		self.queue.asyncAfter(deadline: a, execute: block)
	}

	func back(_ block: @escaping BlockVoid) {
		self.queue.async(execute: block)
	}
}
