//
// Created by entaoyang@163.com on 2017/10/25.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

let ERR_MSG_TOAST = "msg.err.toast"

class MyError: Error, CustomStringConvertible {
	let msg: String
	var baseError: Error? = nil
	
	init(_ msg: String, _ base: Error? = nil) {
		self.msg = msg
		self.baseError = base
	}
	
	var description: String {
		get {
			return "Error: \(msg)"
		}
	}
}

func throwIf(_ cond: Bool, _ msg: String) throws {
	if (cond) {
		throw MyError(msg)
	}
}

func fatalIf(_ cond: Bool, _ msg: String) {
	if cond {
		fatalError(msg)
	}
}

func fataIfDebug(_ msg: String = "") {
	if isDebug {
		fatalError(msg)
	}
}

func debugFatal(_ msg: String = "Fatal Error!") {
	if isDebug {
		fatalError(msg)
	}
}
