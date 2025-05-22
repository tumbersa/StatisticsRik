//
//  UserModel.swift
//  Core
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation

public struct UserModel {
    public let id: Int
    public let sex: SexModel
    public let username: String
    public let isOnline: Bool
    public let age: Int
    public let files: [UserFileModel]
    public let avatarImageData: Data?

    public init(
        id: Int,
        sex: SexModel,
        username: String,
        isOnline: Bool,
        age: Int,
        files: [UserFileModel],
        avatarImageData: Data?
    ) {
        self.id = id
        self.sex = sex
        self.username = username
        self.isOnline = isOnline
        self.age = age
        self.files = files
        self.avatarImageData = avatarImageData
    }
}

public enum SexModel: String {
    case men = "M"
    case women = "W"
    case unknown = "U"
}

public struct UserFileModel {
    public let id: Int
    public let url: String
    public let type: UserFileType

    public init(
        id: Int,
        url: String,
        type: UserFileType
    ) {
        self.id = id
        self.url = url
        self.type = type
    }
}

public enum UserFileType: String {
    case avatar
    case unknown
}
