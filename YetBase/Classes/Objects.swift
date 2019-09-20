//
// Created by entaoyang@163.com on 2017/10/10.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation

private var attr_key = "_attrkey_"

private class MapWrap {
	var map = [String: Any]()
}

public extension NSObject {

	private var _attrMap: MapWrap {
		if let m = objc_getAssociatedObject(self, &attr_key) as? MapWrap {
			return m
		} else {
			let map = MapWrap()
			objc_setAssociatedObject(self, &attr_key, map, .OBJC_ASSOCIATION_RETAIN)
			return map
		}
	}

	func setAttr(_ key: String, _ value: Any?) {
		if let v = value {
			self._attrMap.map[key] = v
		} else {
			self._attrMap.map.removeValue(forKey: key)
		}
	}

	func getAttr(_ key: String) -> Any? {
		return _attrMap.map[key]
	}

	var tagS: String {
		get {
			return (getAttr("_tagS_") as? String) ?? ""
		}
		set {
			setAttr("_tagS_", newValue)
		}
	}
}