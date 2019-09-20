//
// Created by entaoyang@163.com on 2017/10/11.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit


class Dim {
	static var sep: CGFloat = 8
	static var sep2: CGFloat = 16

	static var edge0: CGFloat = 12
	static var edge1: CGFloat = 16
	static var edge: CGFloat = 16
	static var edge2: CGFloat = 22
	static var edgeInput: CGFloat = 32

	static var iconSize0: CGFloat = 25
	static var iconSize: CGFloat = 32
	static var iconSize2: CGFloat = 72

	static var itemHeightNormal: CGFloat = 52
	static var itemHeightLarge: CGFloat = 90
}

class Theme {
	static var imagePostfix = "-light"

	static var themeColor: UIColor = 0x4FB29D.rgb
	static var fadeColor: UIColor = 0xff8800.rgb

	static var dangerColor: UIColor = 0xd81e06.rgb
	static var safeColor: UIColor = 0x36ab60.rgb
	static var grayBackColor: UIColor = Color.whiteF(0.85)

	static var sepratorColor: UIColor = Color.whiteF(0.85)


	class Text {
		static var primaryColor: UIColor = 0x4A4A4A.rgb
		static var minorColor: UIColor = Color.whiteF(0.50)
		static var disabledColor: UIColor = Color.rgb(135, 154, 168)

		static var primaryFont: UIFont = Font.sys(16)
		static var minorFont: UIFont = Font.sys(14)
		static var height: CGFloat = 25
		static var height2: CGFloat = 30
		static var heightMinor: CGFloat = 20

	}

	class Edit {
		static var heightMini: CGFloat = 25
		static var heightSmall: CGFloat = 32
		static var height: CGFloat = 42
		static var corner: CGFloat = 6
		static var borderNormal: UIColor = Color.rgb(200, 200, 200)
		static var borderActive: UIColor = Theme.themeColor //Colors.rgb(74, 144, 226)
		static var borderError: UIColor = Theme.dangerColor
	}

	class Button {
		static var textColor: UIColor = Theme.Text.primaryColor
		static var textColorFade: UIColor = Theme.fadeColor
		static var backColor: UIColor = UIColor.white
		static var borderColor: UIColor = Color.whiteF(0.5)
		static var disabledColor: UIColor = 0xE9EDF1.rgb


		static var roundCorner: CGFloat = 5
		static var height: CGFloat = 36
		static var heightLarge: CGFloat = 42

	}

	class TabBar {
		static var lightColor: UIColor? = Theme.themeColor
		static var grayColor: UIColor? = 0x707070.rgb
		static var backgroundColor: UIColor? = 0xf8f8f8.rgb

		static var imageSize: CGFloat = 30
	}

	class TitleBar {
		static var textColor: UIColor = UIColor.white
		static var backgroundColor: UIColor = Theme.themeColor

		static var imageSize: CGFloat = 30
	}


}


