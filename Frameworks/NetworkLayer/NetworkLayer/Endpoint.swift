//
//  Endpoint.swift
//  NetworkLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation

public struct Endpoint {
    private var components: URLComponents

    init() {
        self.components = URLComponents()
    }

    public func base(_ baseURL: String) -> Endpoint {
        var copy = self
        let url = URL(string: baseURL)
        copy.components.path =  url?.path ?? ""
        copy.components.scheme = url?.scheme
        copy.components.host = url?.host
        return copy
    }

    public func path(_ path: String) -> Endpoint {
        var copy = self
        copy.components.path += path
        return copy
    }

    public func queryItem(name: String, value: String?) -> Endpoint {
        var copy = self
        var queryItems = copy.components.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        copy.components.queryItems = queryItems
        return copy
    }

    public func queryItems(_ items: [String: String?]) -> Endpoint {
        var copy = self
        var queryItems = copy.components.queryItems ?? []
        items.forEach { key, value in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        copy.components.queryItems = queryItems
        return copy
    }

}

public extension Endpoint {
    var url: URL {
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
}

public extension Endpoint {

    static var users: Self {
        Endpoint()
            .base(NetworkConstants.baseUrl)
            .path(NetworkConstants.Path.users)
    }

    static var statistics: Self {
        Endpoint()
            .base(NetworkConstants.baseUrl)
            .path(NetworkConstants.Path.statistics)
    }

}

