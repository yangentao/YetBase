//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

extension Int {

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

extension Int32 {
	var intValue: Int {
		return Int(self)
	}
	var uintValue: UInt {
		return UInt(self)
	}
}

extension UInt {
	var intValue: Int {
		return Int(self)
	}
}

extension UInt64 {
	var intValue: Int {
		return Int(self)
	}
}

extension Int64 {
	var intValue: Int {
		return Int(self)
	}
}