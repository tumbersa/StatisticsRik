//
//  UsersEntry.swift
//  NetworkLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation

// MARK: - UsersEntry
public struct UsersEntry: Codable {
    public let users: [User]

    // MARK: - User
    public struct User: Codable {
        public let id: Int
        public let sex, username: String
        public let isOnline: Bool
        public let age: Int
        public let files: [File]
    }

    // MARK: - File
    public struct File: Codable {
        public let id: Int
        public let url: String
        public let type: String
    }

}
