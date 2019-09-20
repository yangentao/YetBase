//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

public extension NSNumber {
	var isInteger: Bool {
		return !self.stringValue.contains(".")
	}
}

public extension Int8 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
}

public extension Int16 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
}

public extension Int32 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
	var intValue: Int {
		return Int(self)
	}
	var uintValue: UInt {
		return UInt(self)
	}
}

public extension Int {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
	var cint: Int32 {
		return Int32(self)
	}
	var int32Value: Int32 {
		return Int32(self)
	}
	var uint32Value: UInt32 {
		return UInt32(self)
	}
}

public extension Int64 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var intValue: Int {
		return Int(self)
	}
	var date: Date {
		return Date(timeIntervalSince1970: Double(self / 1000))
	}
}

public extension UInt8 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
}

public extension UInt16 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
}

public extension UInt32 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
}

public extension UInt {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
	var intValue: Int {
		return Int(self)
	}
}

public extension UInt64 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var intValue: Int {
		return Int(self)
	}
}

public extension Float {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
}

public extension Double {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}

	func keepDot(_ n: Int) -> String {
		return String(format: "%.\(n)f", arguments: [self])
	}

	var afterSeconds: DispatchTime {
		return DispatchTime.now() + self
	}
}

