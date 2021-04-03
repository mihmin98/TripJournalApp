//
//  Repository.swift
//  TripJournalApp
//
//  Created by user191232 on 4/3/21.
//

import Foundation
import SQLite3

public class Repository {
    
    internal init() {
        self.db = openDB()
    }

    var db: OpaquePointer?
    
    public func openDB() -> OpaquePointer? {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("test.sqlite")
        
        // open database
        
        var db: OpaquePointer?
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return db
        }
        return db
    }
    
    public func addTrip(trip: Trip) {
        if db == nil {
            db = openDB()
        }
        
        let insertStatementString = "insert into trip (id, ownerId, name, photo, destinationName, destinationCoords, cost, rating, description) values (?,?,?,?,?,?,?,?,?,);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, trip.id, -1, nil)
            sqlite3_bind_text(insertStatement, 2, trip.ownerId, -1, nil)
            sqlite3_bind_text(insertStatement, 3, trip.name, -1, nil)
            sqlite3_bind_text(insertStatement, 4, trip.photo, -1, nil)
            sqlite3_bind_text(insertStatement, 5, trip.destinationName, -1, nil)
            sqlite3_bind_text(insertStatement, 6, trip.destinationCoords, -1, nil)
            sqlite3_bind_double(insertStatement, 7, trip.cost)
            sqlite3_bind_int(insertStatement, 8, trip.rating)
            sqlite3_bind_text(insertStatement, 9, trip.description, -1, nil)
        }

        if sqlite3_step(insertStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
        }
    }
}
