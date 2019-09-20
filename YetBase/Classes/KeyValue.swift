//
// Created by entaoyang@163.com on 2017/10/21.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class KeyValue: CustomStringConvertible {
	public var key: String = ""
	public var value: Any

	public init(_ k: String, _ v: Any) {
		self.key = k
		self.value = v
	}

	public var strValue: String {
		return "\(value)"
	}

	public var description: String {
		return key + " = \(value)"
	}
}

infix operator =>: ComparisonPrecedence

public func =>(k: String, v: Any) -> KeyValue {
	return KeyValue(k, v)
}


