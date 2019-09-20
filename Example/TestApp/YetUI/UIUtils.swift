//
// Created by entaoyang@163.com on 2019/9/20.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation
import UIKit


extension URL {
	func open() {
		if #available(iOS 10, *) {
			UIApplication.shared.open(self, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(self)
		}
	}
}
