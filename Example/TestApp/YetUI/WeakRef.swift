//
// Created by entaoyang on 2019-03-02.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit



//init只能是类的实例,
class WeakRef<T: AnyObject>: Equatable {

	weak var value: T?

	init(_ value: T) {
		self.value = value
	}

	var isNull: Bool {
		return value == nil
	}
	var notNull: Bool {
		return value != nil
	}

	static func ==(lhs: WeakRef, rhs: WeakRef) -> Bool {
		if lhs === rhs {
			return true
		}
		if lhs.value === rhs.value {
			return true
		}
		return false
	}

}