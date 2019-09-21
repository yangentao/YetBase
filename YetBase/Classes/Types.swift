//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

public typealias Byte = UInt8
public typealias Long = Int64
public typealias BytePointer = UnsafeMutablePointer<Byte>
public typealias ConstBytePointer = UnsafePointer<Byte>
public typealias CharPointer = UnsafeMutablePointer<Int8>
public typealias ConstCharPointer = UnsafePointer<Int8>
public typealias BlockVoid = () -> Void
public typealias BoolBlock = (Bool) -> Void
public typealias StringBlock = (String) -> Void
public typealias IntBlock = (Int) -> Void
public typealias DoubleBlock = (Double) -> Void