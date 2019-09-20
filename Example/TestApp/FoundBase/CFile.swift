//
// Created by entaoyang@163.com on 2019-08-08.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation
import Darwin.C.stdio

func fileSizeOf(file: String) -> Int {
	var st = stat()
	stat(file.cString(using: .utf8), &st)
	return Int(st.st_size)
}

class CFile {
	fileprivate (set) var fp: UnsafeMutablePointer<FILE>? = nil
	private(set) var fileName: String

	init(filename: String) {
		self.fileName = filename
	}

	func open(model: String) -> Bool {
		guard let p = fopen(fileName.cString(using: .utf8), model.cString(using: .utf8)) else {
			return false
		}
		self.fp = p
		return true
	}

	var isOpen: Bool {
		return fp != nil
	}

	func close() {
		if let p = self.fp {
			fclose(p)
		}
		self.fp = nil
	}

	var fileSize: Int64 {
		var st = stat()
		stat(fileName.cString(using: .utf8), &st)
		return st.st_size
	}

	deinit {
		self.close()
	}
}

extension CFile {
	func openRead() -> Bool {
		return self.open(model: "rb")
	}

	func read(chars: CharPointer, len: Int) -> Int {
		guard let p = self.fp else {
			return 0
		}
		if len <= 0 {
			return 0
		}
		let sizeRead = fread(chars, 1, len, p)
		return sizeRead
	}

	func read(bytes: BytePointer, len: Int) -> Int {
		guard let p = self.fp else {
			return 0
		}
		if len <= 0 {
			return 0
		}
		let sizeRead = fread(bytes, 1, len, p)
		return sizeRead
	}
}

extension CFile {

	func openWrite() -> Bool {
		return self.open(model: "wb")
	}

	func write(bytes: BytePointer, len: Int) -> Int {
		return fwrite(bytes, 1, len, self.fp)
	}

	func write(chars: CharPointer, len: Int) -> Int {
		return fwrite(chars, 1, len, self.fp)
	}
}


