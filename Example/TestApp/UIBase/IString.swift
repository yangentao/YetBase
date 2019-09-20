//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

protocol IString {
	var toString: String { get }
}

extension String: IString {
	var toString: String {
		return self
	}
}

extension Int: IString {
	var toString: String {
		return "\(self)"
	}
}

extension Float: IString {
	var toString: String {
		return "\(self)"
	}
}

extension Double: IString {
	var toString: String {
		return "\(self)"
	}
}

extension CGFloat: IString {
	var toString: String {
		return "\(self)"
	}
}

extension Int64: IString {
	var toString: String {
		return "\(self)"
	}
}
