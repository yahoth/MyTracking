//
//  RealmManager.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 1/17/24.
//

import Foundation

import RealmSwift

class RealmManager {
    deinit {
        print("RealmManager deinit")
    }
    static let shared = RealmManager()

    var realm: Realm

    var notificationToken: NotificationToken?

    init() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
                    // 마이그레이션 코드를 작성합니다.
                }
            })

        Realm.Configuration.defaultConfiguration = config

        self.realm = try! Realm()

    }

    func create(object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func read() -> Results<TrackingData> {
        realm.objects(TrackingData.self).sorted(byKeyPath: "startDate", ascending: false)
    }

    //Delete All Objects in a Realm
    func deleteAll() {
        do {
            try realm.write/*(withoutNotifying: [notificationToken!])*/ {
                realm.deleteAll()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    //Delete All Objects of a Specific Type
    func deleteObjectsOf(type: Results<TrackingData>) {
        do {
            try realm.write {
//                let allObjectsOfType = realm.objects(TrackingData.self)
                realm.delete(type)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func update(str: String) {
        let item = realm.objects(TrackingData.self).first!

        do {
            try realm.write {
                item.startLocation = str
                item.endLocation = str
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
