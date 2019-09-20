//
// Created by entaoyang on 2019-01-08.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

typealias BlockVoid = () -> Void

var debugModel = true

typealias EdgeInset = UIEdgeInsets

func TabPage(_ cs: [UIViewController]) -> MyTabBarPage {
	let c = MyTabBarPage()
	c.definesPresentationContext = true
	c.setViewControllers(cs, animated: false)
	if cs.count > 0 {
		c.selectedIndex = 0
	}
	return c
}

@dynamicMemberLookup
class _R {
	subscript(dynamicMember member: String) -> String {
		return member
	}
}

let R = _R()

