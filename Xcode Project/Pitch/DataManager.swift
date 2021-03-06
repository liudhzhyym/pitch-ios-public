//
//  DataManager.swift
//  Pitch
//
//  Created by Daniel Kuntz on 12/27/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift

struct DataManager {
    
    static let realm = try! Realm()
    
    // MARK: - Analytics
    
    static func resetToday() {
        DispatchQueue.main.async {
            let day = today()
            try! realm.write {
                realm.delete(day)
            }
        }
    }
    
    static func today() -> Day {
        let days = data(forPastDaysIncludingToday: 1)
        if days.count > 0 {
            return days[0]
        } else {
            let day = Day()
            add(day)
            sendUsageStatistics()
            return day
        }
    }
    
    static func data(forPastDaysIncludingToday days: Int) -> Results<Day> {
        let numberOfDays = max(days, 1)
        let today = Calendar.current.startOfDay(for: Date())
        let startDate = today.adding(-(numberOfDays - 1))
        
        let days = realm.objects(Day.self).filter("date >= %@", startDate)
        return days
    }
    
    static func allDays() -> Results<Day> {
        let days = realm.objects(Day.self)
        return days
    }
    
    fileprivate static func add(_ day: Day) {
        DispatchQueue.main.async {
            try! realm.write {
                realm.add(day, update: true)
            }
        }
    }
    
    // MARK: - Sessions
    
    static func sessions() -> [Session] {
        let results = realm.objects(Session.self)
        var sessions: [Session] = []
        sessions.append(contentsOf: results)
        sessions.sort(by: { $0.date > $1.date })
        return sessions
    }
    
    static func add(_ session: Session, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            try! realm.write {
                realm.add(session, update: true)
            }
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    static func delete(_ session: Session, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            try! realm.write {
                session.prepareForDeletion()
                realm.delete(session)
            }
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    static func rename(_ session: Session, to newName: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            try! realm.write {
                session.name = newName
            }
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    static func setHasSeenAnalyticsAnimation(_ hasSeen: Bool, forSession session: Session, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            try! realm.write {
                session.analytics?.hasSeenAnimation = hasSeen
            }
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    // MARK: - Fabric Statistics
    
    fileprivate static func sendUsageStatistics() {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.sendUsageStatistics()
    }
}
