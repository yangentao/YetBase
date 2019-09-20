//
// Created by entaoyang@163.com on 2017/10/10.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

private let LogLock: NSRecursiveLock = NSRecursiveLock()

func printA(_ items: Any...) {
	for a in items {
		print(a, terminator: "")
	}
}

func println(_ items: Any...) {
	for a in items {
		print(a, terminator: "")
	}
	print("")
}

func log(_ ss: Any?...) {
#if DEBUG
	LogLock.lock()
	printA(Date.formatDateTimeMill)
	printA(" INFO:")
	var first = true
	for s in ss {
		if first {
			first = false
		} else {
			printA(" ")
		}
		if let a = s {
			printA(a)
		} else {
			printA("nil")
		}
		
	}
	println()
	LogLock.unlock()
#endif
}

func logd(_ ss: Any?...) {
#if DEBUG
	LogLock.lock()
	printA(Date.formatDateTimeMill)
	printA(" DEBUG:")
	var first = true
	for s in ss {
		if first {
			first = false
		} else {
			printA(" ")
		}
		if let a = s {
			printA(a)
		} else {
			printA("nil")
		}
		
	}
	println()
	LogLock.unlock()
#endif
}


func loge(_ ss: Any?...) {
#if DEBUG
	LogLock.lock()
	printA(Date.formatDateTimeMill)
	printA(" ERROR:")
	var first = true
	for s in ss {
		if first {
			first = false
		} else {
			printA(" ")
		}
		if let a = s {
			printA(a)
		} else {
			printA("nil")
		}

	}
	println()
	LogLock.unlock()
#endif
}
