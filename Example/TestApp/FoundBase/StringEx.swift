//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

fileprivate let Chars09: Array<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

extension Character {
	var isNumber: Bool {
		return Chars09.contains(self)
	}
}

extension String.Encoding {

	static func fromName(_ name: String) -> String.Encoding? {
		let cfEncode = CFStringConvertIANACharSetNameToEncoding((name as NSString) as CFString)
		if cfEncode != kCFStringEncodingInvalidId {
			let raw = CFStringConvertEncodingToNSStringEncoding(cfEncode)
			return String.Encoding(rawValue: raw)
		}
		return nil
	}
}

extension String {

	var cstrUtf8: [CChar] {
		return self.cString(using: .utf8) ?? []
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

	//trim(",;"
	func trim(_ cs: String) -> String {
		return self.trimmingCharacters(in: CharacterSet(charactersIn: cs))
	}

	func endWith(_ s: String) -> Bool {
		return self.hasSuffix(s)
	}

	func startWith(_ s: String) -> Bool {
		return self.hasPrefix(s)
	}

	func match(_ reg: String) -> Bool {
		let p = NSPredicate(format: "SELF MATCHES %@", [reg])
		return p.evaluate(with: self)
	}

	var formatedPhone: String {
		var s = ""
		for c: Character in self {
			if c.isNumber {
				s.append(c)
			}
		}
		return s
	}

	var toInt: Int? {
		return Int(self)
	}
	var toDouble: Double? {
		return Double(self)
	}
	var toBool: Bool? {
		return Bool(self)
	}

	var trimed: String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	var urlEncoded: String {
		return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
	}

	var notEmpty: Bool {
		return !self.isEmpty
	}

	var empty: Bool {
		return self.isEmpty
	}

	var dataUtf8: Data {
		return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
	}
	var dataUnicode: Data {
		return self.data(using: String.Encoding.unicode, allowLossyConversion: false)!
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

	func substr(_ from: Int) -> String {
		if from < self.count {
			return String(self[idx(from)...])
		}
		return ""
	}

	//[from, to)
	func substr(_ from: Int, _ to: Int) -> String {
		let c = self.count
		if from >= c {
			return ""
		}
		if to >= c {
			return String(self[self.idx(from)..<self.idx(c)])
		}
		return String(self[self.idx(from)..<self.idx(to)])
	}

	func header(_ size: Int) -> String {
		return substr(0, size)
	}

	func tail(_ size: Int) -> String {
		var from = self.count - size
		if from < 0 {
			from = 0
		}
		return self.substr(from)
	}

	//没有返回-1
	func lastIndexOf(_ c: Character) -> Int {
		var n = self.count - 1
		while n >= 0 {
			if c == at(n) {
				return n
			}
			n -= 1
		}
		return -1
	}

	func indexOf(_ c: Character) -> Int? {
		if let n = self.firstIndex(of: c) {
			return self.distance(from: self.startIndex, to: n)
		}
		return nil
	}

	mutating func removeAt(_ n: Int) -> Character? {
		if n >= 0 && n < self.count {
			return self.remove(at: self.idx(n))
		}
		return nil
	}

	mutating func insertAt(_ n: Int, _ c: Character) {
		if (n == self.count) {
			self.append(c)
			return
		}
		self.insert(c, at: self.idx(n))
	}

	func replaced(_ map: [Character: String]) -> String {
		var buf: String = ""
		for ch in self {
			if let s = map[ch] {
				buf.append(s)
			} else {
				buf.append(ch)
			}
		}
		return buf
	}

	func replaced(_ cs: [Character], to str: String) -> String {
		var buf: String = ""
		for ch in self {
			if cs.contains(ch) {
				buf.append(str)
			} else {
				buf.append(ch)
			}
		}
		return buf
	}

	var escapedSQL: String {
		return self.replaced(["'": "''"])
	}

	var local: String {
		get {
			return NSLocalizedString(self, comment: self)
		}
	}

	subscript(value: PartialRangeUpTo<Int>) -> Substring {
		get {
			return self[..<self.idx(value.upperBound)]
		}
	}

	subscript(value: PartialRangeThrough<Int>) -> Substring {
		get {
			return self[...self.idx(value.upperBound)]
		}
	}

	subscript(value: PartialRangeFrom<Int>) -> Substring {
		get {
			return self[self.idx(value.lowerBound)...]
		}
	}
	subscript(value: ClosedRange<Int>) -> Substring {
		get {
			return self[self.idx(value.lowerBound)...self.idx(value.upperBound)]
		}
	}
	subscript(value: Range<Int>) -> Substring {
		get {
			return self[self.idx(value.lowerBound)..<self.idx(value.upperBound)]
		}
	}

	func idx(_ n: Int) -> String.Index {
		return self.index(self.startIndex, offsetBy: n)
	}

}

extension Substring {

	func toString() -> String {
		return String(self)
	}
}



func htmlStr(_ font: UIFont, _ s: String) -> NSAttributedString {
	let ss = try? NSMutableAttributedString(data: s.dataUnicode, options: [
		NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
	], documentAttributes: nil)
	if let sss = ss {
		sss.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: sss.length))
		return sss
	}
	return NSAttributedString(string: s)
}


extension NSAttributedString {

	func linkfy() -> NSMutableAttributedString {
		let s = NSMutableAttributedString(attributedString: self)

		guard let detect = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue) else {
			return s
		}
		let ms = detect.matches(in: s.string, range: NSRange(location: 0, length: s.length))
		for m in ms {
			if m.resultType == .link, let url = m.url {
				s.addAttributes([NSAttributedString.Key.link: url,
				                 NSAttributedString.Key.foregroundColor: UIColor.blue,
				                 NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.rawValue
				], range: m.range)
			} else if m.resultType == .phoneNumber, let pn = m.phoneNumber {
				s.addAttributes([NSAttributedString.Key.link: pn,
				                 NSAttributedString.Key.foregroundColor: UIColor.blue,
				                 NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.rawValue
				], range: m.range)
			}
		}
		return s
	}

}