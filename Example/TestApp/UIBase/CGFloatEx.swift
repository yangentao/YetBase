//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import UIKit

func /(lhs: CGFloat, rhs: Int) -> CGFloat {
	return lhs / CGFloat(rhs)
}

func *(lhs: CGFloat, rhs: Int) -> CGFloat {
	return lhs * CGFloat(rhs)
}

extension Int8 {

	var f: CGFloat {
		return CGFloat(self)
	}

}

extension Int16 {

	var f: CGFloat {
		return CGFloat(self)
	}

}

extension Int32 {

	var f: CGFloat {
		return CGFloat(self)
	}

}

extension Int {

	var f: CGFloat {
		return CGFloat(self)
	}

}

extension UInt8 {

	var f: CGFloat {
		return CGFloat(self)
	}

}

extension UInt16 {

	var f: CGFloat {
		return CGFloat(self)
	}

}

extension UInt32 {

	var f: CGFloat {
		return CGFloat(self)
	}

}

extension UInt {

	var f: CGFloat {
		return CGFloat(self)
	}

}

extension Float {
	var f: CGFloat {
		return CGFloat(self)
	}

}

extension Double {

	var f: CGFloat {
		return CGFloat(self)
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
