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
    func saveObject(_ entity: Object)
}

public final class RealmManager: IRealmManager {

    public init() {}

    public func getObjects<T: Object>() -> [T] {
        let realm = try! Realm()
        return Array(realm.objects(T.self))
    }

    public func saveObject(_ entity: Object) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(entity, update: .modified)
            }
        } catch {
            AppLogger.shared.logError(error.localizedDescription)
        }
    }

}
