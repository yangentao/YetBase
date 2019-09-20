//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

extension String {

	func idx(_ n: Int) -> String.Index {
		return self.index(self.startIndex, offsetBy: n)
	}

	func charAt(n: Int) -> Character? {
		if n >= 0 && n < self.count {
			return self[self.idx(n)]
		}
		return nil
	}

	func at(_ n: Int) -> Character {
		return self[self.idx(n)]
	}

	var trimed: String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	var cstrUtf8: [CChar] {
		return self.cString(using: .utf8) ?? []
	}

	var dataUtf8: Data {
		return self.data(using: .utf8)!
	}

	func appendPath(_ s: String) -> String {
		if self.last == "/" {
			return self + s
		}
		return self + "/" + s
	}

	var lastPath: String {
		let ls = self.split(separator: "/").filter {
			!$0.isEmpty
		}
		if ls.isEmpty {
			return ""
		}
		return String(ls.last!)
	}

	var parentPath: String {

		if self.last == "/" {
			let s = self[self.startIndex..<self.index(before: self.endIndex)]
			return String(s).parentPath
		}
		if let n = self.lastIndex(of: "/") {
			return String(self[self.startIndex..<n])
		} else {
			return ""
		}
	}
}