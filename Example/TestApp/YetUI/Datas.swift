//
// Created by entaoyang@163.com on 2017/10/10.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

extension Data {
	
	var bytes: [UInt8] {
		return [UInt8](self)
	}
	
	mutating func appendUtf8(_ s: String) {
		self.append(s.dataUtf8)
	}
	
	var stringUtf8: String? {
		return String(data: self, encoding: .utf8)
	}

	var base64:String {
		get {
			return self.base64EncodedString(options: Base64EncodingOptions.endLineWithCarriageReturn)
		}

	}
}