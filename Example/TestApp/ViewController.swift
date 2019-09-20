//
//  ViewController.swift
//  TestApp
//
//  Created by entaoyang on 2019-07-03.
//  Copyright © 2019 entao.dev. All rights reserved.
//

import UIKit
//import Yson

class Person: Codable {
	var name: String = ""
	var age: Int = 0
}

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

//        if let a = YsonObject("""
//                              {"name":"Yang","age":99}
//                              """) {
//            a.put("age", 100)
//            let s = a.yson
//            print(s)
//            if let p: Person = Yson.fromYson(Person.self, a) {
//                print(p.name)
//                print(p.age)
//                let ss = p.toYsonObject.yson
//                print(ss)
//            }
//        }
	}

}
