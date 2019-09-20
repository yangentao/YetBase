//
// Created by entaoyang@163.com on 2019-08-10.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

class ByteBuffer {
	private(set) var capacity: Int
	private(set) var bytes: BytePointer

	init(capacity: Int) {
		self.capacity = capacity
		bytes = BytePointer.allocate(capacity: capacity)
		bytes.initialize(to: 0)
	}

	subscript(i: Int) -> Byte {
		get {
			return self.bytes[i]
		}
		set {
			self.bytes[i] = newValue
		}
	}

	var asChars: UnsafeMutablePointer<Int8> {
		return UnsafeMutableRawPointer(self.bytes).bindMemory(to: Int8.self, capacity: self.capacity)
	}

	deinit {
		self.bytes.deallocate()
	}

	func dump() {
		for i in 0..<self.capacity {
			print(self.bytes[i])
		}
	}
}

class CharBuffer {
	private(set) var capacity: Int
	private(set) var chars: CharPointer

	init(capacity: Int) {
		self.capacity = capacity
		chars = CharPointer.allocate(capacity: capacity)
		chars.initialize(to: 0)
	}

	subscript(i: Int) -> CChar {
		get {
			return self.chars[i]
		}
		set {
			self.chars[i] = newValue
		}
	}

	var asBytes: UnsafeMutablePointer<UInt8> {
		return UnsafeMutableRawPointer(self.chars).bindMemory(to: UInt8.self, capacity: self.capacity)
	}

	deinit {
		self.chars.deallocate()
	}

	func dump() {
		for i in 0..<self.capacity {
			print(self.chars[i])
		}
	}
}