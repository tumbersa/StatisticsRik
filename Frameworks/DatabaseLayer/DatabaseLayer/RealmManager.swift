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
    func clearObjects<T: Object>(_ type: T.Type)
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

    public func clearObjects<T: Object>(_ type: T.Type) {
        let realm = try! Realm()
        let objects: [T] = getObjects()
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            AppLogger.shared.logError("Failed to clear \(T.description()): \(error.localizedDescription)")
        }

    }

    public func clearDatabase() {
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch {
                AppLogger.shared.logError("Failed to clear database: \(error.localizedDescription)")
            }
        }

        public func deleteDatabaseFiles() {
            // Закрываем все Realm-сессии
            autoreleasepool {
                _ = try? Realm()
            }

            // Получаем URL файла Realm по умолчанию
            guard let realmURL = Realm.Configuration.defaultConfiguration.fileURL else {
                AppLogger.shared.logError("Realm file URL not found")
                return
            }

            let realmURLs = [
                realmURL,
                realmURL.appendingPathExtension("lock"),
                realmURL.appendingPathExtension("note"),
                realmURL.appendingPathExtension("management")
            ]

            // Удаляем все связанные файлы
            for url in realmURLs {
                do {
                    try FileManager.default.removeItem(at: url)
                    AppLogger.shared.logInfo("Deleted Realm file at: \(url.path)")
                } catch {
                    AppLogger.shared.logError("Error deleting Realm file: \(error.localizedDescription)")
                }
            }
        }

}
