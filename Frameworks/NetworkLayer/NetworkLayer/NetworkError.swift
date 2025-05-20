//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation

enum NetworkError: Error {
    case error(Error)
    case emptyData
    case statusCode(Int)
    case decodingFailed(Error)
}
