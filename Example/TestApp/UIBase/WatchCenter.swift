//
// Created by entaoyang@163.com on 2017/10/14.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

class WatchItem: Equatable {
	weak var item: NSObject?
	var propName: String = ""
	var fireMsg: String = ""
	weak var layoutView: UIView?
	var layoutSuper: Bool = false

	init(obj: NSObject, prop: String) {
		self.item = obj
		self.propName = prop
	}

	@discardableResult
	func fire(_ msg: String) -> WatchItem {
		fireMsg = msg
		return self
	}

	@discardableResult
	func layout(_ view: UIView) -> WatchItem {
		layoutView = view
		return self
	}

	@discardableResult
	func layoutSuperView() -> WatchItem {
		layoutSuper = true
		return self
	}

	fileprivate func isMsg(_ m: String) -> Bool {
		return self.fireMsg == m
	}

	static func ==(lhs: WatchItem, rhs: WatchItem) -> Bool {
		if lhs === rhs {
			return true
		}
		if lhs.propName == rhs.propName {
			if let a = lhs.item, let b = rhs.item, a === b {
				return true
			}
		}
		return false
	}
}

class ObjectWatch: NSObject {

	fileprivate var all = Array<WatchItem>()

	deinit {
		for item in all {
			item.item?.removeObserver(self, forKeyPath: item.propName)
		}
		all.removeAll()
	}

	func watch(obj: NSObject, property: String) -> WatchItem {
		let item = WatchItem(obj: obj, prop: property)
		all.append(item)
		item.item?.addObserver(self, forKeyPath: item.propName, options: [.new], context: nil)
		return item
	}

	func remove(obj: NSObject, _ property: String) {
		obj.removeObserver(self, forKeyPath: property)
		sync(self) {
			_ = all.drop {
				return $0.item === obj && $0.propName == property
			}
		}
	}

	func remove(obj: NSObject) {
		sync(self) {
			_ = all.drop {
				if $0.item === obj {
					obj.removeObserver(self, forKeyPath: $0.propName)
					return true
				}
				return false
			}
		}
	}

	override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if let kp = keyPath, let obj = object as? NSObject {
			sync(self) {
				all.filter { item in
					return item.item === obj && item.propName == kp
				}.forEach { item in
					if !item.fireMsg.isEmpty {
						fireFore(item.fireMsg)
					}
					if let v = item.layoutView {
						v.setNeedsLayout()
					}
					if item.layoutSuper {
						if let v = item.item as? UIView {
							v.superview?.setNeedsLayout()
						}
					}
				}

				_ = all.drop { item in
					return item.item == nil
				}
			}
		}

	}
}

let WatchCenter = ObjectWatch()