//
// Created by entaoyang@163.com on 2019/9/19.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class FileMap<K: Codable & Hashable, V: Codable> {

	public var map: Dictionary<K, V> = Dictionary<K, V>(minimumCapacity: 256)
	private var file: File

	fileprivate init(_ filename: String) {
		self.file = Files.docFile(filename)
		load()
	}

	private func load() {
		self.map.removeAll()
		if let text = self.file.readText() {
			if let ls: Dictionary<K, V> = Json.decode(text) {
				self.map = ls
			}
		}
	}

	public func save() {
		if let s = Json.encode(self.map) {
			self.file.writeText(text: s)
		}
	}

	func get(_ k: K) -> V? {
		return self.map[k]
	}

	func put(_ k: K, _ v: V) {
		self.map[k] = v
	}

	@discardableResult
	func remove(_ k: K) -> V? {
		return self.map.removeValue(forKey: k)
	}
}

private var FileMapStore = [String: WeakRef<AnyObject>]()

public func FileMapOf<K: Codable & Hashable, V: Codable>(_ filename: String) -> FileMap<K, V> {
	if let old = FileMapStore[filename]?.value {
		return old as! FileMap<K, V>
	}
	let a = FileMap<K, V>(filename)
	FileMapStore[filename] = WeakRef(a as AnyObject)
	return a
}