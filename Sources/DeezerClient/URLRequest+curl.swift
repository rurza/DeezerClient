//
//  URLRequest+curl.swift
//  DeezerClient
//
//  Created by Adam Różyński on 20/10/2019.
//  Copyright © 2019 Adam Różyński. All rights reserved.
//

import Foundation

extension URLRequest {
    var curl: String? {
        guard let url = url?.absoluteString else { return nil }
        let headersString = allHTTPHeaderFields?
            .keys
            .map { "-H \($0):\(allHTTPHeaderFields![$0]!) " }
            .joined()
        var bodyParameter: String?
        if let body = httpBody, let bodyString = String(bytes: body, encoding: .utf8) {
            bodyParameter = "-d \(bodyString)"
        }
        return "curl -v \(url) -X \(httpMethod ?? "GET") -m \(Int(timeoutInterval)) \(headersString ?? "") \(bodyParameter ?? "")"
    }
}
