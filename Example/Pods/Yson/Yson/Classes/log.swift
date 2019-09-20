//
// Created by entaoyang on 2019-07-03.
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
