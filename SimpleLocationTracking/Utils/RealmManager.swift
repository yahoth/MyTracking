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
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    //Delete All Objects of a Specific Type
    func deleteObjectsOf(type: TrackingData) {
        do {
            try realm.write(withoutNotifying: [notificationToken!]) {
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
