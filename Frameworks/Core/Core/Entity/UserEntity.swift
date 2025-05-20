//
//  UserEntity.swift
//  DatabaseLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation
import RealmSwift

class UserEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var sex: String
    @Persisted var username: String
    @Persisted var isOnline: Bool
    @Persisted var age: Int
    @Persisted var files: List<UserFileEntity>
    @Persisted var avatarImageData: Data?
}

class UserFileEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var url: String
    @Persisted var type: String
}
