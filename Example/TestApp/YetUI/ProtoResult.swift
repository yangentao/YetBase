//
// Created by entaoyang on 2019-01-10.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import  Yson

class ProtoResult {
	let httpResult: HttpResult
	var CodeOKValue = ProtoResult.CODE_OK
	var CodeName = ProtoResult.CODE
	var DataName = ProtoResult.DATA
	var MsgName = ProtoResult.MSG

	init(_ r: HttpResult) {
		httpResult = r
	}

	lazy var yo: YsonObject = self.httpResult.ysonObject ?? YsonObject()
	var code: Int {
		if httpResult.OK {
			return yo.int(CodeName) ?? -1
		} else {
			return httpResult.httpCode
		}
	}
	var OK: Bool {
		return httpResult.OK && code == CodeOKValue
	}
	var msg: String {
		if httpResult.OK {
			return yo.str(MsgName) ?? ""
		} else {
			return httpResult.errorMsg ?? "未知错误"
		}
	}

	var dataObject: YsonObject? {
		return yo.obj(DataName)
	}
	var dataArray: YsonArray? {
		return yo.array(DataName)
	}
	var dataInt: Int? {
		return yo.int(DataName)
	}
	var dataDouble: Double? {
		return yo.double(DataName)
	}
	var dataString: String? {
		return yo.str(DataName)
	}

	func dataListObject() -> [YsonObject] {
		if OK {
			if let ar = self.dataArray {
				return ar.arrayObject
			}
		}
		return []
	}

	func dataModel<V: Decodable>() -> V? {
		if let d = self.dataObject {
			return d.toModel()
		}
		return nil
	}

	func dataListModel<V: Decodable>() -> [V] {
		var ls = [V]()
		if OK {
			if let ar = self.dataArray {
				for n in ar {
					if let ob = n as? YsonObject {
						if let m: V = ob.toModel() {
							ls.append(m)
						}
					}
				}
			}
		}
		return ls
	}

	static var CODE_OK = 0
	static var CODE = "code"
	static var DATA = "data"
	static var MSG = "msg"

}