//
//  UserEntity.swift
//  DatabaseLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation
import RealmSwift

public class UserEntity: Object {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var sex: String
    @Persisted public var username: String
    @Persisted public var isOnline: Bool
    @Persisted public var age: Int
    @Persisted public var files: List<UserFileEntity>
    @Persisted public var avatarImageData: Data?

    public override init() {}
}

public class UserFileEntity: Object {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var url: String
    @Persisted public var type: String

    public override init() {}
}
