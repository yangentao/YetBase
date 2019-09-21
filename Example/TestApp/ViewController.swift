//
//  ViewController.swift
//  TestApp
//
//  Created by entaoyang on 2019-07-03.
//  Copyright © 2019 entao.dev. All rights reserved.
//

import UIKit

//import Yson

import YetBase

class Person: Codable {
	var name: String = ""
	var age: Int = 0
}

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		hello()
	}

}

func hello() {

	let _ = A()
	defer {
		log("defer()")
	}
	log("hello...")
}

class A {
	init() {
		log("A.init")

	}

	deinit {
		log("A.deinit")
	}

}
