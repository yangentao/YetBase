//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

typealias Long = Int64

func /(lhs: CGFloat, rhs: Int) -> CGFloat {
	return lhs / CGFloat(rhs)
}

func *(lhs: CGFloat, rhs: Int) -> CGFloat {
	return lhs * CGFloat(rhs)
}

extension NSNumber {
	var isInteger: Bool {
		return !self.stringValue.contains(".")
	}
}

extension Int8 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
	}
	var s: String {
		return "\(self)"
	}
}

extension Int16 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
	}
	var s: String {
		return "\(self)"
	}
}

extension Int32 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
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

extension Int {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
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

extension Int64 {
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

extension UInt8 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
	}
	var s: String {
		return "\(self)"
	}
}

extension UInt16 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
	}
	var s: String {
		return "\(self)"
	}
}

extension UInt32 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
	}
	var s: String {
		return "\(self)"
	}
}

extension UInt {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
	}
	var s: String {
		return "\(self)"
	}
	var intValue: Int {
		return Int(self)
	}
}

extension UInt64 {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var intValue: Int {
		return Int(self)
	}
}

extension Float {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var s: String {
		return "\(self)"
	}
}

extension Double {
	var num: NSNumber {
		return NSNumber(value: self)
	}
	var f: CGFloat {
		return CGFloat(self)
	}
	var s: String {
		return "\(self)"
	}

	func keepDot(_ n: Int) -> String {
		return String(format: "%.\(n)f", arguments: [self])
	}
}

extension CGFloat {

	var num: NSNumber {
		return NSNumber(value: Double(self))
	}
	var s: String {
		return "\(self)"
	}

}
