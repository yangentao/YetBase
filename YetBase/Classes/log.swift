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
	var level: LogLevel
	var message: String
	var time: TimeInterval = Date().timeIntervalSince1970

	public var toString: String {
		Date(timeIntervalSince1970: time).format(fmt: .yyyy_MM_dd__HH_mm_ss_SSS) + " " + level.rawValue + " " + message
	}
}

public protocol LogPrinter {
	func logWrite(item: LogItem)
	func logFlush()
}

public protocol LogListener: class {
	func onLog(item: LogItem)
}

fileprivate struct LogListenerHolder: Equatable {
	var levels: [LogLevel]
	weak var listener: LogListener?

	static func ==(lhs: LogListenerHolder, rhs: LogListenerHolder) -> Bool {
		lhs.levels == rhs.levels && lhs.listener === rhs.listener
	}
}

public class LogImpl {
	private let lock: NSRecursiveLock = NSRecursiveLock()
	public var printer: LogPrinter = LogConsolePrinter()
	private var listeners: [LogListenerHolder] = []

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

	public var levelFilter: (LogLevel) -> Bool = { _ in
		true
	}

	public func filterItems(levels: [LogLevel]) -> [LogItem] {
		self.filterItems {
			levels.contains($0.level)
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
		self.addListener(levels: [], listener: listener)
	}

	public func addListener(levels: [LogLevel], listener: LogListener) {
		let a = LogListenerHolder(levels: levels, listener: listener)
		if !self.listeners.contains(a) {
			self.listeners.append(a)
		}
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

		if levelFilter(item.level) {
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
			for l in self.listeners {
				if l.levels.isEmpty {
					l.listener?.onLog(item: item)
				} else if l.levels.contains(item.level) {
					l.listener?.onLog(item: item)
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

public func log(_ ss: Any?...) {
	Log.info(ss)
}

public func logd(_ ss: Any?...) {
	Log.debug(ss)
}

public func loge(_ ss: Any?...) {
	Log.error(ss)
}

public func println(_ items: Any?...) {
	for a in items {
		if let b = a {
			print(b, terminator: " ")
		} else {
			print("nil", terminator: " ")
		}
	}
	print("")
}

public class LogConsolePrinter: LogPrinter {
	public func logWrite(item: LogItem) {
		print(item.toString)
	}

	public func logFlush() {

	}
}

public class LogTreePrinter: LogPrinter {
	var printers: [LogPrinter] = []

	init(printers: [LogPrinter]) {
		self.printers = printers
	}

	public func logWrite(item: LogItem) {
		for p in printers {
			p.logWrite(item: item)
		}
	}

	public func logFlush() {
		for p in printers {
			p.logFlush()
		}
	}
}