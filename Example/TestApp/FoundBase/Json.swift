//
// Created by entaoyang@163.com on 2017/10/11.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation

class Json {

	static func decode<T:Decodable>(_ json: String?) -> T? {
		return decode(T.self, json: json)
	}

	static func decode<T>(_ type: T.Type, json: String?) -> T? where T: Decodable {
		return decode(type, json: json) {
			$0.dateDecodingStrategy = .millisecondsSince1970
		}
	}

	static func decode<T>(_ type: T.Type, json: String?, _ block: (JSONDecoder) -> Void) -> T? where T: Decodable {
		if let s = json, s.notEmpty {
		let d = JSONDecoder()
		block(d)
			return try? d.decode(type, from: s.dataUtf8)
		}
		return nil
	}

	static func encode<T>(_ value: T, pretty: Bool = false) -> String? where T: Encodable {
		return encode(value) {
			$0.dateEncodingStrategy = .millisecondsSince1970
			if pretty {
				$0.outputFormatting = .prettyPrinted
			}
		}
	}

	static func encode<T>(_ value: T, _ block: (JSONEncoder) -> Void) -> String? where T: Encodable {
		let e = JSONEncoder()
		block(e)
		return (try? e.encode(value))?.stringUtf8
	}
}



//
//
//class Person: Codable {
//	var address: String = "JiNan"
//	var age: Int = 33
//
//	enum CodingKeys: String, CodingKey {
//		case address = "addr"
//		case age
//	}
//}
//
//func test() {
//	let s = """
//	{
//		"addr":"shan dong",
//		"age":32
//	}
//	"""
//	let p = Json.decode(Person.self, json: s)
//	dump(p)
//
//	let e = Person().toJson()
//	logd(e)
//}