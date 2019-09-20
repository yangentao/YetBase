//
// Created by entaoyang@163.com on 2019-07-28.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

private var preTempFileName = ""

extension Date {

	var formated: String {
		return Date.format(self, "yyyy-MM-dd")
	}
	var formatedDateTime: String {
		return Date.format(self, "yyyy-MM-dd HH:mm:ss")
	}
	var formatedDateTimeMill: String {
		return Date.format(self, "yyyy-MM-dd HH:mm:ss.SSS")
	}

	var formatedTime: String {
		return Date.format(self, "HH:mm:ss")
	}

	static var tempFileName: String {
		let s = Date.format(Date(), "yyyyMMdd_HHmmss_SSS")
		if s != preTempFileName {
			preTempFileName = s
			return s
		} else {
			let a = Int(ProcessInfo.processInfo.systemUptime * 1000000000)
			return s + "_\(a)"
		}
	}

	static var formatDateTimeMill: String {
		return Date.format(Date(), "yyyy-MM-dd HH:mm:ss.SSS")
	}
	static var formatDateTime: String {
		return Date.format(Date(), "yyyy-MM-dd HH:mm:ss")
	}
	static var formatDate: String {
		return Date.format(Date(), "yyyy-MM-dd")
	}

	static func format(_ date: Date, _ format: String) -> String {
		let f = DateFormatter()
		f.dateFormat = format
		return f.string(from: date)
	}

	static func byDate(year: Int, month: Int, day: Int) -> Date {
		let c = Calendar.current
		var b = DateComponents()
		b.year = year
		b.month = month
		b.day = day
		return c.date(from: b)!
	}
}
