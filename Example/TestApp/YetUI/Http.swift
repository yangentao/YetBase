//
// Created by entaoyang@163.com on 2017/10/10.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit
import Dispatch
import  Yson

protocol HttpProgress {
	func onHttpStart(_ total: Int)

	func onHttpProgress(_ current: Int, _ total: Int, _ percent: Int)

	func onHttpFinish(_ success: Bool)
}

class HttpResult {
	let content: Data?
	let response: HTTPURLResponse?
	let error: Error?

	init(_ response: HTTPURLResponse?, _ data: Data?, _ error: Error?) {
		self.response = response
		self.content = data
		self.error = error
	}

	var httpCode: Int {
		if error != nil {
			return -1
		}
		return response?.statusCode ?? -1
	}

	var OK: Bool {
		return httpCode >= 200 && httpCode < 300
	}
	var errorMsg: String? {
		if self.error != nil {
			return self.error?.localizedDescription
		} else {
			return httpMsgByCode(httpCode)
		}
//		switch error {
//		case nil:
//			return httpMsgByCode(httpCode)
////		case let e as URLError:
////			loge("HttpError: \(e)")
////			return e.failureURLString
//		default:
//			return error?.localizedDescription ?? "未知错误"
//		}
	}

	var str: String? {
		if OK {
			if let dt = content {
				let encName = response?.textEncodingName ?? "UTF-8"
				if let enc = String.Encoding.fromName(encName) {
					return String(data: dt, encoding: enc)
				}
			}
		}
		return nil
	}

	var ysonObject: YsonObject? {
		if let s = str {
			return Yson.parseObject(s)
		}
		return nil
	}
}

typealias HttpCallback = (HttpResult) -> Void

//文件上传用multipart方法, 文件合计大小不超过10M
//

class Http {
	private static let GET: Int = 0
	private static let POST: Int = 1
	private static let POST_RAW: Int = 2
	private static let POST_MULTIPART: Int = 3
	private static let CRLF = "\r\n"

	let url: String
	var timeout: TimeInterval = 15.0
	var progressRecv: HttpProgress? = nil
	var progressSend: HttpProgress? = nil

	private let BOUNDARY = UUID().uuidString
	private let BOUNDARY_START: String
	private let BOUNDARY_END: String

	private var argMap = [String: String]()
	private var headerMap = [String: String]()
	private var fileMap = [String: String]()
	private var fileDataMap = [String: Data]()
	private var fileNameMap = [String: String]()
	private var rawData: Data?
	private var session: URLSession = URLSession.shared

	private var sendStart = false
	private var recvStart = false

	init(_ url: String) {
		self.url = url
		BOUNDARY_START = "--" + self.BOUNDARY + Http.CRLF
		BOUNDARY_END = "--" + self.BOUNDARY + "--" + Http.CRLF

		accept("*/*")
		acceptLanguage("zh-CN,en-US;q=0.8,en;q=0.6")
		header("Accept-Charset", "UTF-8,*")
		header("Connection:", "close")
		header("Charset", "utf-8")
		userAgent("Mozilla/5.0");

	}

	func get() -> HttpResult {
		if Thread.isMainThread {
			loge("不应该在主线程执行阻塞网络任务")
		}
		return self.requestSync(Http.GET)
	}

	func post() -> HttpResult {
		if Thread.isMainThread {
			logd("不应该在主线程执行阻塞网络任务")
		}
		header("Content-Type", "application/x-www-form-urlencoded; charset=utf-8")
		return self.requestSync(Http.POST)
	}

	func multipart() -> HttpResult {
		if Thread.isMainThread {
			logd("不应该在主线程执行阻塞网络任务")
		}
		header("Content-Type", "multipart/form-data; boundary=\(BOUNDARY)")
		return self.requestSync(Http.POST_MULTIPART)
	}

	func postRawData(contentType: String, data: Data) -> HttpResult {
		self.rawData = data
		header("Content-Type", contentType)
		return requestSync(Http.POST_RAW)
	}

	func getAsync(_ callback: @escaping HttpCallback) -> URLSessionTask {
		return request(Http.GET, callback)
	}

	func postAsync(_ callback: @escaping HttpCallback) -> URLSessionTask {
		header("Content-Type", "application/x-www-form-urlencoded; charset=utf-8")
		return request(Http.POST, callback)
	}

	func multipartAsync(_ callback: @escaping HttpCallback) -> URLSessionTask {
		header("Content-Type", "multipart/form-data; boundary=\(BOUNDARY)")
		return request(Http.POST_MULTIPART, callback)
	}

	func postRawDataAsync(_ contentType: String, _ data: Data, _ callback: @escaping HttpCallback) -> URLSessionTask {
		self.rawData = data
		header("Content-Type", contentType)
		return request(Http.POST_RAW, callback)
	}

	func postRawJsonAsync(_ json: String, _ callback: @escaping HttpCallback) -> URLSessionTask {
		return postRawDataAsync("text/json;charset=utf-8", json.dataUtf8, callback)
	}

	func postRawXmlAsync(_ xml: String, _ callback: @escaping HttpCallback) -> URLSessionTask {
		return postRawDataAsync("text/xml;charset=utf-8", xml.dataUtf8, callback)
	}

	@discardableResult
	func file(_ name: String, _ file: String) -> Http {
		fileMap[name] = file
		return self
	}

	@discardableResult
	func fileData(_ name: String, _ data: Data) -> Http {
		fileDataMap[name] = data
		return self
	}

	@discardableResult
	func args(_ kvs: [(String, String)]) -> Http {
		for (k, v) in kvs {
			argMap[k] = v
		}
		return self
	}

	@discardableResult
	func args(_ kvs: (String, String)...) -> Http {
		for (k, v) in kvs {
			argMap[k] = v
		}
		return self
	}

	@discardableResult
	func arg(_ key: String, _ value: String) -> Http {
		argMap[key] = value
		return self
	}

	@discardableResult
	func args(_ kvs: [KeyValue]) -> Http {
		for kv in kvs {
			arg(kv.key, kv.strValue)
		}
		return self
	}

	@discardableResult
	func args(_ kvs: KeyValue...) -> Http {
		for kv in kvs {
			arg(kv.key, kv.strValue)
		}
		return self
	}

	func headers(_ kvs: (String, String)...) {
		for (k, v) in kvs {
			headerMap[k] = v
		}
	}

	func header(_ key: String, _ value: String) {
		headerMap[key] = value
	}

	func acceptHtml() {
		accept("text/html")
	}

	func acceptJson() {
		accept("application/json")
	}

	func accept(_ val: String) {
		header("Accept", val)
	}

	func acceptLanguage(_ val: String) {
		header("Accept-Language", val)
	}

	func authBearer(token: String) {
		header("Authorization", "Bearer " + token)
	}

	func authBasic(user: String, pwd: String) {
		let s = user + ":" + pwd
		let ss = s.dataUtf8.base64
		header("Authorization", "Basic " + ss)
	}

	func userAgent(_ agent: String) {
		header("User-Agent", agent)
	}

	func contentTypeJson() {
		contentType(value: "application/json")
	}

	func contentType(value: String) {
		header("Content-type", value)
	}

	private func buildQueryString() -> String {
		var s = ""
		for (k, v) in argMap {
			if !s.empty {
				s += "&"
			}
			s += k.urlEncoded + "=" + v.urlEncoded
		}
		return s
	}

	func buildGetUrl() -> String {
		let query = buildQueryString()
		if (query.empty) {
			return url
		}
		if url.lastIndexOf("?") >= 0 {
			if "?" == url.last {
				return url + query
			} else {
				return url + "&" + query
			}
		} else {
			return url + "?" + query
		}
	}

	private func buildMultipartData() -> Data {
		var data: Data = Data(capacity: 4096)
		for (k, v) in argMap {
			data.appendUtf8(BOUNDARY_START)
			data.appendUtf8("Content-Disposition: form-data; name=\"\(k)\"\(Http.CRLF)")
			data.appendUtf8("Content-Type:text/plain;charset=utf-8\(Http.CRLF)")
			data.appendUtf8(Http.CRLF)
			data.appendUtf8(v)
			data.appendUtf8(Http.CRLF)
		}
		for (k, v) in fileMap {
			if let fileData = try? Data(contentsOf: URL(fileURLWithPath: v)) {
				let filename = v.lastPath
				data.appendUtf8(BOUNDARY_START)
				data.appendUtf8("Content-Disposition:form-data;name=\"\(k)\";filename=\"\(filename)\"\(Http.CRLF)")
				data.appendUtf8("Content-Type:application/octet-stream\r\n")
				data.appendUtf8("Content-Transfer-Encoding: binary\r\n")
				data.appendUtf8(Http.CRLF)
				data.append(fileData)
				data.appendUtf8(Http.CRLF)
			} else {
				loge("multipart, 读取文件失败")
			}
		}
		for (k, v) in fileDataMap {
			let filename = k
			data.appendUtf8(BOUNDARY_START)
			data.appendUtf8("Content-Disposition:form-data;name=\"\(k)\";filename=\"\(filename)\"\(Http.CRLF)")
			data.appendUtf8("Content-Type:application/octet-stream\r\n")
			data.appendUtf8("Content-Transfer-Encoding: binary\r\n")
			data.appendUtf8(Http.CRLF)
			data.append(v)
			data.appendUtf8(Http.CRLF)
		}
		data.appendUtf8(BOUNDARY_END)
		return data
	}

	private func buildRequest(_ method: Int) -> URLRequest {
		logd("请求: ", url)
		logd("参数: ", buildQueryString())
		var urlStr = url
		if method == Http.GET || method == Http.POST_RAW {
			urlStr = buildGetUrl()
		}
		var req = URLRequest(url: URL(string: urlStr)!)
		req.timeoutInterval = timeout
		req.httpShouldHandleCookies = true
		req.httpMethod = method == Http.GET ? "GET" : "POST"
		if method == Http.POST {
			let qs = buildQueryString()
			if qs.notEmpty {
				req.httpBody = qs.dataUtf8
			}
		} else if method == Http.POST_RAW {
			req.httpBody = self.rawData!
		} else if method == Http.POST_MULTIPART {
			req.httpBody = buildMultipartData()
		}
		for (k, v) in headerMap {
			req.setValue(v, forHTTPHeaderField: k)
		}
		return req
	}

	private func request(_ method: Int, _ callback: @escaping HttpCallback) -> URLSessionTask {
		let req = self.buildRequest(method)
		let task: URLSessionTask = self.session.dataTask(with: req, completionHandler: { (nsdata: Data?, urlResp: URLResponse?, err: Error?) -> Void in
			let result = HttpResult(urlResp as? HTTPURLResponse, nsdata, err)
			callback(result)
		})
		task.resume()
		self.watchRecv(task: task)
		self.watchSend(task: task)
		return task
	}

	private func requestSync(_ method: Int) -> HttpResult {
		let req = self.buildRequest(method)
		var hr: HttpResult!
		let sem = DispatchSemaphore(value: 0);
		let task: URLSessionTask = self.session.dataTask(with: req, completionHandler: { (nsdata: Data?, urlResp: URLResponse?, err: Error?) -> Void in
			hr = HttpResult(urlResp as? HTTPURLResponse, nsdata, err)
			sem.signal()
		})
		task.resume()
		self.watchRecv(task: task)
		self.watchSend(task: task)
		sem.wait()
		return hr
	}

	private func watchRecv(task: URLSessionTask) {
		guard let pp = self.progressRecv else {
			return
		}
		Task.foreDelay(0.2) {
			self.calcRecvProgress(p: pp, task: task)
		}
	}

	private func calcRecvProgress(p: HttpProgress, task: URLSessionTask) {
		let received = Int(task.countOfBytesReceived)
		let total: Int = Int(task.countOfBytesExpectedToReceive)
		if received > 0 || total > 0 {
			if !recvStart {
				recvStart = true
				p.onHttpStart(total)
				p.onHttpProgress(0, total, 0)
			}
			let percent: Int = received * 100 / total
			p.onHttpProgress(received, total, percent)
		}
		if task.state == URLSessionTask.State.running || task.state == URLSessionTask.State.suspended {
			self.watchRecv(task: task)
		} else {
			let OK = task.state == URLSessionTask.State.completed
			if OK {
				p.onHttpProgress(total, total, 100)
			}
			p.onHttpFinish(OK)
		}

	}

	private func watchSend(task: URLSessionTask) {
		guard let pp = self.progressSend else {
			return
		}
		Task.foreDelay(0.2) {
			self.calcSendProgress(p: pp, task: task)
		}
	}

	private func calcSendProgress(p: HttpProgress, task: URLSessionTask) {
		let sent = Int(task.countOfBytesSent)
		let total = Int(task.countOfBytesExpectedToSend)
		if sent > 0 || total > 0 {
			if !sendStart {
				sendStart = true
				p.onHttpStart(total)
				p.onHttpProgress(0, total, 0)
			}
			let percent = sent * 100 / total
			p.onHttpProgress(sent, total, percent)
		}
		if task.state == URLSessionTask.State.running || task.state == URLSessionTask.State.suspended {
			self.watchSend(task: task)
		} else {
			let OK = task.state == URLSessionTask.State.completed
			if OK {
				p.onHttpProgress(total, total, 100)
			}
			p.onHttpFinish(OK)
		}
	}
}

private var codeMap = [
	100: "Continue",
	101: "Switching Protocols",
	102: "Processing",
	200: "OK",
	201: "Created",
	202: "Accepted",
	203: "Non-Authoritative Information",
	204: "No Content",
	205: "Reset Content",
	206: "Partial Content",
	207: "Multi-Status",
	300: "Multiple Choices",
	301: "Moved Permanently",
	302: "Move temporarily",
	303: "See Other",
	304: "Not Modified",
	305: "Use Proxy",
	306: "Switch Proxy",
	307: "Temporary Redirect",
	400: "Bad Request",
	401: "Unauthorized",
	402: "Payment Required",
	403: "Forbidden",
	404: "Not Found",
	405: "Method Not Allowed",
	406: "Not Acceptable",
	407: "Proxy Authentication Required",
	408: "Request Timeout",
	409: "Conflict",
	410: "Gone",
	411: "Length Required",
	412: "Precondition Failed",
	413: "Request Entity Too Large",
	414: "Request-URI Too Long",
	415: "Unsupported Media Type",
	416: "Requested Range Not Satisfiable",
	417: "Expectation Failed",
	421: "too many connections",
	422: "Unprocessable Entity",
	423: "Locked",
	424: "Failed Dependency",
	425: "Unordered Collection",
	426: "Upgrade Required",
	449: "Retry With",
	451: "Unavailable For Legal Reasons",
	500: "Internal Server Error",
	501: "Not Implemented",
	502: "Bad Gateway",
	503: "Service Unavailable",
	504: "Gateway Timeout",
	505: "HTTP Version Not Supported",
	506: "Variant Also Negotiates",
	507: "Insufficient Storage",
	509: "Bandwidth Limit Exceeded",
	510: "Not Extended",
	600: "Unparseable Response Headers"
]

func httpMsgByCode(_ code: Int) -> String? {
	return codeMap[code]
}