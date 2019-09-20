//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

	static var Primary: UILabel {
		let a = UILabel(frame: Rect.zero)
		a.stylePrimary()
		return a
	}
	static var Minor: UILabel {
		let a = UILabel(frame: Rect.zero)
		a.styleMinor()
		return a
	}


	var heightThatFit: CGFloat {
		let sz = self.sizeThatFits(Size.zero)
		return sz.height
	}
	var widthThatFit: CGFloat {
		let sz = self.sizeThatFits(Size.zero)
		return sz.width
	}

	@discardableResult
	func alignRight() -> UILabel {
		self.textAlignment = .right
		return self
	}

	@discardableResult
	func alignCenter() -> UILabel {
		self.textAlignment = .center
		return self
	}

	@discardableResult
	func alignLeft() -> UILabel {
		self.textAlignment = .left
		return self
	}

	func styleMinor() {
		self.textColor = Theme.Text.minorColor
		self.font = Theme.Text.minorFont
	}

	func stylePrimary() {
		self.textColor = Theme.Text.primaryColor
		self.font = Theme.Text.primaryFont
	}
}