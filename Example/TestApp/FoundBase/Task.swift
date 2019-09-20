//
// Created by entaoyang@163.com on 2017/10/10.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation

fileprivate var onceSet: Set<String> = Set<String>()

class ScheduleItem {
	var name: String
	fileprivate var block: BlockVoid?
	fileprivate var time: Double = Date().timeIntervalSince1970

	init(name: String, block: @escaping BlockVoid) {
		self.name = name
		self.block = block
	}

	var canceled: Bool {
		return self.block == nil
	}

	func cancel() {
		block = nil
	}
}

class Task {

	private static var tasks = [ScheduleItem]()

	static func mergeFore(_ name: String, _ block: @escaping BlockVoid) {
		self.mergeFore(name, 0.3, block)
	}

	static func mergeFore(_ name: String, _ second: Double, _ block: @escaping BlockVoid) {

		let item = ScheduleItem(name: name, block: block)
		self.tasks.append(item)
		DispatchQueue.main.asyncAfter(deadline: second.afterSeconds) {
			if let b = item.block {
				for t in self.tasks {
					if t.name == name {
						t.cancel()
					}
				}
				self.tasks.removeAllIf {
					$0.block == nil
				}
				b()
			}
		}
	}

	static func fore(_ block: @escaping BlockVoid) {
		DispatchQueue.main.async(execute: block)
	}

	static func foreDelay(_ seconds: Double, _ block: @escaping BlockVoid) {
		let a = DispatchTime.now() + seconds
		DispatchQueue.main.asyncAfter(deadline: a, execute: block)
	}

	static func back(_ block: @escaping BlockVoid) {
		DispatchQueue.global().async(execute: block)
	}

	static func backDelay(seconds: Double, _ block: @escaping BlockVoid) {
		let a = DispatchTime.now() + seconds
		DispatchQueue.global().asyncAfter(deadline: a, execute: block)
	}

	static func foreSchedule(_ second: Double, _ block: @escaping BlockVoid) -> ScheduleItem {
		let item = ScheduleItem(name: "", block: block)
		DispatchQueue.main.asyncAfter(deadline: second.afterSeconds) {
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

	func sync(_ block: @escaping BlockVoid) {
		self.queue.sync(execute: block)
	}

	func backDelay(seconds: Double, _ block: @escaping BlockVoid) {
		let a = DispatchTime.now() + seconds
		self.queue.asyncAfter(deadline: a, execute: block)
	}

	func back(_ block: @escaping BlockVoid) {
		self.queue.async(execute: block)
	}
}
