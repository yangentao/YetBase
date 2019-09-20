//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

class TapGesture: UITapGestureRecognizer {
	var target: AnyObject
	var action: Selector

	init(target: AnyObject, action: Selector) {
		self.target = target
		self.action = action
		super.init(target: target, action: action)
	}
}