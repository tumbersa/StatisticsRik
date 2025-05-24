//
//  RealmManager.swift
//  DatabaseLayer
//
//  Created by Глеб Капустин on 19.05.2025.
//

import Foundation
import RealmSwift
import Core

public protocol IRealmManager {
    func getObjects<T: Object>() -> [T]
    func saveObject(_ entity: Object, isUpdated: Bool)
    func deleteObjects<T: Object>(_ type: T.Type)
    func updateUser(id: Int, avatarImageData: Data)
}

public extension IRealmManager {

    func saveObject(_ entity: Object, isUpdated: Bool = false) {
        saveObject(entity, isUpdated: isUpdated)
    }

}

public final class RealmManager: IRealmManager {

    public init() {}

    public func getObjects<T: Object>() -> [T] {
        let realm = try! Realm()
        return Array(realm.objects(T.self))
    }

    public func saveObject(_ entity: Object, isUpdated: Bool) {
        let realm = try! Realm()
        do {
            try realm.write {
                isUpdated ? realm.add(entity, update: .modified) : realm.add(entity)
            }
        } catch {
            AppLogger.shared.logError(error.localizedDescription)
        }
    }

    public func updateUser(id: Int, avatarImageData: Data) {
        let usersEntity: [UserEntity] = getObjects()
        let realm = try! Realm()
        if let userEntity = usersEntity.first(where: { $0.id == id}) {
            try? realm.write {
                userEntity.avatarImageData = avatarImageData
                realm.add(userEntity, update: .modified)
            }
        }
    }

    public func deleteObjects<T: Object>(_ type: T.Type) {
        let realm = try! Realm()
        let objects: [T] = getObjects()
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            AppLogger.shared.logError("Failed to delete \(T.description()): \(error.localizedDescription)")
        }
    }

}
