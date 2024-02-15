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
//        let config = Realm.Configuration(
//          // 새로운 스키마 버전. 이전보다 숫자가 커야 합니다.
//          schemaVersion: 1,
//
//          // 스키마 버전이 이전 버전보다 높을 때 호출되는 블록입니다.
//          migrationBlock: { migration, oldSchemaVersion in
//            // 여기에서 데이터베이스의 마이그레이션을 수행합니다.
//            // 예를 들어, 'TrackingData.activityType' 속성을 추가했다면,
//            // 이전 버전의 'TrackingData' 객체를 순회하면서 새 속성에 기본값을 설정할 수 있습니다.
//          })
//
//        // 이 설정을 기본 Realm에 적용합니다.
//        Realm.Configuration.defaultConfiguration = config
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
