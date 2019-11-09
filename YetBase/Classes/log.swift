//
// Created by entaoyang@163.com on 2019-07-28.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

public let Log = LogImpl()

public struct LogLevel: Hashable, Equatable, RawRepresentable {
	public var rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public init(_ value: String) {
		self.rawValue = value
	}
}

public extension LogLevel {
	static let success = LogLevel("SUCCESS")
	static let error = LogLevel("ERROR")
	static let warning = LogLevel("WARNING")
	static let info = LogLevel("INFO")
	static let debug = LogLevel("DEBUG")
	static let verbose = LogLevel("VERBOSE")
}

public struct LogItem: Hashable, Equatable, ToString {
	public var level: LogLevel
	public var tag: String = ""
	public var message: String
	public var time: TimeInterval = Date().timeIntervalSince1970

	public var toString: String {
		Date(timeIntervalSince1970: time).format(fmt: .yyyy_MM_dd__HH_mm_ss_SSS) + " " + level.rawValue + ": " + tag + " " + message
	}
}

public struct LogListenerHolder: Equatable {

	public weak var listener: LogListener?

	public static func ==(lhs: LogListenerHolder, rhs: LogListenerHolder) -> Bool {
		lhs.listener === rhs.listener
	}
}

public class LogImpl {
	private let lock: NSRecursiveLock = NSRecursiveLock()
	private var listeners: [LogListenerHolder] = []
	public var printer: LogPrinter = LogConsolePrinter()

	public private(set ) var historyItems: [LogItem] = []
	public var keepSize: Int = 1000 {
		didSet {
			if self.keepSize < 0 {
				self.keepSize = 0
			}
			if self.historyItems.count > keepSize {
				self.historyItems.removeFirst(self.historyItems.count - keepSize)
			}
		}
	}

	public func filterItems(_ block: (LogItem) -> Bool) -> [LogItem] {
		self.lock.lock()
		defer {
			self.lock.unlock()
		}
		return self.historyItems.filter(block)
	}

	public func addListener(listener: LogListener) {
		let a = LogListenerHolder(listener: listener)
		self.listeners.addOnAbsence(a)
	}

	public func flush() {
		self.printer.logFlush()
	}

	public func log(item: LogItem) {
		lock.lock()
		if self.keepSize > 0 {
			if self.historyItems.count > self.keepSize + 10 {
				let n = self.historyItems.count - self.keepSize
				self.historyItems.removeFirst(n)
			}
			self.historyItems.append(item)
		}
		if printer.acceptLog(item: item) {
			if item.level == .debug {
				#if DEBUG
					printer.logWrite(item: item)
				#endif
			} else {
				printer.logWrite(item: item)
			}
		}
		lock.unlock()
		Task.fore {
			var needClean = false
			for l in self.listeners {
				if let L = l.listener {
					L.onLog(item: item)
				} else {
					needClean = true
				}
			}
			if needClean {
				self.listeners.removeAll {
					$0.listener == nil
				}
			}
		}

	}

	public func itemsToString(_ items: [Any?]) -> String {
		var buf = ""
		for a in items {
			if let b = a {
				print(b, terminator: " ", to: &buf)
			} else {
				print("nil", terminator: " ", to: &buf)
			}
		}
		return buf
	}
}

public extension LogImpl {

	func log(level: LogLevel, items: [Any?]) {
		self.log(item: LogItem(level: level, message: itemsToString(items)))
	}

	func info(_ items: Any?...) {
		self.log(level: .info, items: items)
	}

	func debug(_ items: Any?...) {
		self.log(level: .debug, items: items)
	}

	func warn(_ items: Any?...) {
		self.log(level: .warning, items: items)
	}

	func error(_ items: Any?...) {
		self.log(level: .error, items: items)
	}

	func success(_ items: Any?...) {
		self.log(level: .success, items: items)
	}

	func verbose(_ items: Any?...) {
		self.log(level: .verbose, items: items)
	}
}

public extension LogImpl {

	func log(level: LogLevel, tag: String, items: [Any?]) {
		self.log(item: LogItem(level: level, tag: tag, message: itemsToString(items)))
	}

	func info(tag: String, _ items: Any?...) {
		self.log(level: .info, tag: tag, items: items)
	}

	func debug(tag: String, _ items: Any?...) {
		self.log(level: .debug, tag: tag, items: items)
	}

	func warn(tag: String, _ items: Any?...) {
		self.log(level: .warning, tag: tag, items: items)
	}

	func error(tag: String, _ items: Any?...) {
		self.log(level: .error, tag: tag, items: items)
	}

	func success(tag: String, _ items: Any?...) {
		self.log(level: .success, tag: tag, items: items)
	}

	func verbose(tag: String, _ items: Any?...) {
		self.log(level: .verbose, tag: tag, items: items)
	}
}

public func log(_ ss: Any?...) {
	Log.info(ss)
}

public func logd(_ ss: Any?...) {
	Log.debug(ss)
}

public func loge(_ ss: Any?...) {
	Log.error(ss)
}

public func log(tag: String, _ ss: Any?...) {
	Log.info(tag: tag, ss)
}

public func logd(tag: String, _ ss: Any?...) {
	Log.debug(tag: tag, ss)
}

public func loge(tag: String, _ ss: Any?...) {
	Log.error(tag: tag, ss)
}

public protocol LogPrinter {
	func acceptLog(item: LogItem) -> Bool
	func logWrite(item: LogItem)
	func logFlush()
}

public protocol LogListener: class {
	func acceptLog(item: LogItem) -> Bool
	func onLog(item: LogItem)
}

public class LogConsolePrinter: LogPrinter {
	public func logWrite(item: LogItem) {
		print(item.toString)
	}

	public func logFlush() {

	}

	public func acceptLog(item: LogItem) -> Bool {
		true
	}
}

public class LogTreePrinter: LogPrinter {
	public var printers: [LogPrinter] = []

	public init(printers: [LogPrinter]) {
		self.printers = printers
	}

	public func logWrite(item: LogItem) {
		for p in printers {
			if p.acceptLog(item: item) {
				p.logWrite(item: item)
			}
		}
	}

	public func logFlush() {
		for p in printers {
			p.logFlush()
		}
	}

	public func acceptLog(item: LogItem) -> Bool {
		true
	}
}