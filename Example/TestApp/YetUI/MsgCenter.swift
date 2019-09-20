//
// Created by entaoyang@163.com on 2017/10/11.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

class Msg {
	var msg: String = ""

	var result = Array<Any>()
	var argAny: Any?
	var argN1 = 0
	var argN2 = 0
	var argS1 = ""
	var argS2 = ""
	var argB1 = false
	var argB2 = false

	init(_ msg: IString) {
		self.msg = msg.toString
	}

	func n1(_ n: Int) -> Msg {
		self.argN1 = n
		return self
	}

	func n2(_ n: Int) -> Msg {
		self.argN2 = n
		return self
	}

	func s1(_ s: String) -> Msg {
		self.argS1 = s
		return self
	}

	func s2(_ s: String) -> Msg {
		self.argS2 = s
		return self
	}

	static func ==(lhs: Msg, rhs: IString) -> Bool {
		return lhs.msg == rhs.toString
	}
}

protocol MsgListener: AnyObject {
	func onMsg(msg: Msg)
}

fileprivate class MsgItem: Equatable {
	var key: String
	weak var listener: MsgListener?

	init(_ key: IString, _ L: MsgListener) {
		self.key = key.toString
		self.listener = L
	}

	var isNull: Bool {
		return listener == nil
	}

	func isListener(_ L: MsgListener) -> Bool {
		if let l = self.listener {
			return l === L
		}
		return false
	}

	static func ==(lhs: MsgItem, rhs: MsgItem) -> Bool {
		if lhs.key != rhs.key {
			return false
		}
		if let a = lhs.listener, let b = rhs.listener, a === b {
			return true
		}
		return false
	}

}

fileprivate class ListenerAllItem: Equatable {
	weak var listener: MsgListener?

	init(_ l: MsgListener) {
		self.listener = l
	}

	static func ==(lhs: ListenerAllItem, rhs: ListenerAllItem) -> Bool {
		if lhs === rhs {
			return true
		}
		if let a = lhs.listener, let b = rhs.listener, a === b {
			return true
		}
		return false
	}
}

class MsgCenterObject {
	private var all = [MsgItem]()
	private var allItems = [ListenerAllItem]()

	func remove(_ listener: MsgListener) {
		sync(self) {
			all.removeAll(where: { $0.listener === listener })
			allItems.removeAll(where: { $0.listener === listener })
		}
	}

	func listenAll(_ listener: MsgListener) {
		sync(self) {
			let item = ListenerAllItem(listener)
			if !allItems.contains(item) {
				allItems.append(item)
			}
		}
	}

	func listen(_ listener: MsgListener, _ msg: IString, _ msgs: IString...) {
		listen(msg.toString, listener)
		for m in msgs {
			listen(m.toString, listener)
		}
	}

	private func listen(_ msg: String, _ listener: MsgListener) {
		let item = MsgItem(msg, listener)
		sync(self) {
			if !all.contains(item) {
				all.append(item)
			}
		}
	}

	func fireCurrent(_ msg: Msg) {
		_ = allItems.drop {
			$0.listener == nil
		}
		let aItems = allItems
		aItems.forEach { item in
			item.listener?.onMsg(msg: msg)
		}

		var arr = Array<MsgItem>()
		sync(self) {
			_ = self.all.drop { a in
				return a.isNull
			}
			let someItems = self.all.filter { a in
				return a.key == msg.msg
			}
			arr.append(contentsOf: someItems)

		}
		for item in arr {
			item.listener?.onMsg(msg: msg)
		}
	}

	func fire(_ msg: Msg) {
		Task.fore {
			MsgCenter.fireCurrent(msg)
		}
	}
}

let MsgCenter = MsgCenterObject()

func fireFore(_ msg: IString) {
	fireFore(Msg(msg.toString))
}

func fireFore(_ msg: IString, _ block: (Msg) -> Void) {
	let m = Msg(msg.toString)
	block(m)
	fireFore(m)
}

func fireFore(_ msg: Msg) {
	Task.fore {
		MsgCenter.fireCurrent(msg)
	}
}