//
// Created by entaoyang on 2018-12-28.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

typealias Font = UIFont

extension Font {
	static func sys(_ size: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: size)
	}
}

class Fonts {

	static var title:Font = semibold(16)
	static var heading1:Font = semibold(20)
	static var heading2:Font = medium(17)
	static var body:Font = regular(13)
	static var caption:Font = semibold(14)
	static var tiny:Font = regular(12)



	static func thin(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.thin)
	}

	static func light(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.light)
	}

	static func regular(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.regular)
	}

	static func medium(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.medium)
	}

	static func semibold(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
	}

	static func bold(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.bold)
	}

	static func heavy(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
	}

	static func black(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.black)
	}

}