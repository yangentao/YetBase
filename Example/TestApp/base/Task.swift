//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

typealias TaskBlock = () -> Void

public extension Double {
	var afterSeconds: DispatchTime {
		return DispatchTime.now() + self
	}
}

class ScheduleItem {
	var name: String
	fileprivate var block: TaskBlock?
	fileprivate var time: Double = Date().timeIntervalSince1970

	init(name: String, block: @escaping TaskBlock) {
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

	static func mergeFore(_ name: String, _ block: @escaping TaskBlock) {
		self.mergeFore(name, 0.3, block)
	}

	static func mergeFore(_ name: String, _ second: Double, _ block: @escaping TaskBlock) {

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
//		OperationQueue.main.addOperation(block)
	}

	static func foreDelay(seconds: Double, _ block: @escaping BlockVoid) {
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