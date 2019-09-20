//
// Created by entaoyang@163.com on 2019-07-26.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

var isDebug: Bool {
	get {
		#if DEBUG
		return true
		#else
		return false
		#endif
	}
}

func tick(_ msg: String, _ block: BlockVoid) {
	let start = Date().timeIntervalSince1970
	block()
	let end = Date().timeIntervalSince1970
	let delta = end - start
	logd("Tick: ", msg, ": ", delta)
}

func tickR<R>(_ msg: String, _ block: () -> R) -> R {
	let start = Date().timeIntervalSince1970
	let r = block()
	let end = Date().timeIntervalSince1970
	let delta = end - start
	logd("Tick: ", msg, ": ", delta)
	return r
}

func findUrlParam(url: String, param: String) -> String? {
	if !url.hasPrefix("http") || !url.contains(param) {
		return nil
	}
	guard  let cmp = URLComponents(string: url) else {
		return nil
	}
	guard let code = cmp.queryItems?.first(where: { $0.name == param }) else {
		return nil
	}
	return code.value
}

extension Bundle {

	func file(_ file: String) -> File {
		let p = self.bundlePath.appendPath(file)
		return File(p)
	}
}