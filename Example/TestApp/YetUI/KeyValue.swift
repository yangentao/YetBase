//
// Created by entaoyang@163.com on 2017/10/21.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

class KeyValue: CustomStringConvertible {
	var key: String = ""
	var value: Any

	init(_ k: String, _ v: Any) {
		self.key = k
		self.value = v
	}

	var strValue: String {
		return "\(value)"
	}

	var description: String {
		return key + " = \(value)"
	}
}

infix operator =>: ComparisonPrecedence

func =>(k: String, v: Any) -> KeyValue {
	return KeyValue(k, v)
}


