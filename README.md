# Yson

[![CI Status](https://img.shields.io/travis/yangentao/Yson.svg?style=flat)](https://travis-ci.org/yangentao/Yson)
[![Version](https://img.shields.io/cocoapods/v/Yson.svg?style=flat)](https://cocoapods.org/pods/Yson)
[![License](https://img.shields.io/cocoapods/l/Yson.svg?style=flat)](https://cocoapods.org/pods/Yson)
[![Platform](https://img.shields.io/cocoapods/p/Yson.svg?style=flat)](https://cocoapods.org/pods/Yson)

## Example

```kotlin
class Person: Codable {
	var name: String = ""
	var age: Int = 0
}
```
```kotlin
let jsonStr = """
		          {"name":"Yang","age":99}
		          """
if let a = YsonObject(jsonStr) {
  a.put("age", 100)
	let s = a.yson
	print(s)
	if let p: Person = Yson.fromYson(Person.self, a) {
	  print(p.name)
		print(p.age)
		let ss = p.toYsonObject.yson
		print(ss)
	}
 }
```
Output:

{"name":"Yang","age":100}   
Yang   
100   
{"name":"Yang","age":100}   


## Requirements

## Installation

Yson is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Yson'
```

## Author

yangentao, entaoyang@163.com

## License

Yson is available under the MIT license. See the LICENSE file for more info.
