//
// Created by entaoyang on 2018-12-30.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

//注意 使用 [weak self]
typealias ActionBlock = (AnyObject) -> Void

class TargetSelector {
	var action: ActionBlock
	var selector: Selector

	init(_ block: @escaping ActionBlock) {
		self.action = block
		selector = #selector(onCallback(sender:))
	}

	@objc
	func onCallback(sender: AnyObject) {
		UIWindow.main.endEditing(true)
		action(sender)
	}
}

extension NSObject {

	var targetSelector: TargetSelector? {
		get {
			return self.getAttr("__target_selector__") as? TargetSelector
		}
		set {
			self.setAttr("__target_selector__", newValue)
		}
	}

}