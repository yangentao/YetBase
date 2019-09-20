//
// Created by entaoyang@163.com on 2019-07-31.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

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
		return lhs === rhs || lhs.value === rhs.value
	}

}