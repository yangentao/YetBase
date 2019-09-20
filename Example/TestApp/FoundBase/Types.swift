//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

typealias Byte = UInt8

typealias BytePointer = UnsafeMutablePointer<Byte>
typealias ConstBytePointer = UnsafePointer<Byte>
typealias CharPointer = UnsafeMutablePointer<Int8>
typealias ConstCharPointer = UnsafePointer<Int8>

typealias BlockVoid = () -> Void