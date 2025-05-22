//
//  UserModel+Map.swift
//  Core
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation

public extension UserModel {
    init(from userEntry: UsersEntry.User) {
        let files = userEntry.files.map { file in
            UserFileModel(
                id: file.id,
                url: file.url,
                type: UserFileType(rawValue: file.type) ?? .unknown
            )
        }
        self.init(
            id: userEntry.id,
            sex: SexModel(rawValue: userEntry.sex) ?? .unknown,
            username: userEntry.username,
            isOnline: userEntry.isOnline,
            age: userEntry.age,
            files: files,
            avatarImageData: nil
        )
    }

    init(from userEntity: UserEntity) {
        let files = Array(userEntity.files).map { file in
            UserFileModel(
                id: file.id,
                url: file.url,
                type: UserFileType(rawValue: file.type) ?? .unknown
            )
        }
        self.init(
            id: userEntity.id,
            sex: SexModel(rawValue: userEntity.sex) ?? .unknown,
            username: userEntity.username,
            isOnline: userEntity.isOnline,
            age: userEntity.age,
            files: files,
            avatarImageData: userEntity.avatarImageData
        )
    }

    func withAvatarImageData(_ data: Data) -> UserModel {
        UserModel(
            id: self.id,
            sex: self.sex,
            username: self.username,
            isOnline: self.isOnline,
            age: self.age,
            files: self.files,
            avatarImageData: data
        )
    }
}
