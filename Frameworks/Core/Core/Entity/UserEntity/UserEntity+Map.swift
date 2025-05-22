//
//  UserEntity+Map.swift
//  DatabaseLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation
import RealmSwift

public extension UserEntity {
    convenience init(from userModel: UserModel) {
        self.init()
        self.id = userModel.id
        self.sex = userModel.sex.rawValue
        self.username = userModel.username
        self.isOnline = userModel.isOnline
        self.age = userModel.age
        self.avatarImageData = userModel.avatarImageData

        let files = List<UserFileEntity>()
        userModel.files.forEach { file in
            let userFileEntity = UserFileEntity()
            userFileEntity.id = file.id
            userFileEntity.url = file.url
            userFileEntity.type = file.type.rawValue
            files.append(userFileEntity)
        }
        self.files = files
    }
}
