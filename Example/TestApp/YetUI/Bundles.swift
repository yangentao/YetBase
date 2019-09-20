//
// Created by entaoyang on 2019-02-14.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {

	func file(_ file: String) -> File {
		let p = Bundle.main.bundlePath.appendPath(file)
		return File(p)
	}
}