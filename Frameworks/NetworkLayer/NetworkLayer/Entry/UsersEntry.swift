//
//  UsersEntry.swift
//  NetworkLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation

// MARK: - UsersEntry
public struct UsersEntry: Codable {
    let users: [User]

    // MARK: - User
    public struct User: Codable {
        let id: Int
        let sex, username: String
        let isOnline: Bool
        let age: Int
        let files: [File]
    }

    // MARK: - File
    public struct File: Codable {
        let id: Int
        let url: String
        let type: String
    }

}
