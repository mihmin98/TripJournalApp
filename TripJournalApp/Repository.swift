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
    
    func closeDbConnection() {
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        db = nil
    }
    
    public func addTrip(trip: Trip) {
        if db == nil {
            db = openDB()
        }
        
        let insertStatementString = "insert into trip (id, ownerId, name, photo, destinationName, destinationCoords, cost, rating, description) values (?,?,?,?,?,?,?,?,?);"
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
        closeDbConnection()
    }
    
    public func update(trip: Trip) {
        if (db == nil) {
            db = openDB()
        }
        
        let updateStatementString = "UPDATE trips SET ownerId = ?, name = ?, photo = ?, destinationName = ?, destinationCoords = ?, cost = ?, rating = ?, description = ?;"
        var updateStatement: OpaquePointer? = nil;
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) != SQLITE_DONE {
                print("Could not update row")
            }
        }
        sqlite3_finalize(updateStatement)
        closeDbConnection()
    }
    
    public func readMyTrips() -> [Trip] {
        let query: String = "SELECT * FROM trips WHERE ownerId = 'ceva';"
        return readTrips(query: query)
    }
    
    public func readFavoriteTrips() -> [Trip] {
        let query: String = "SELECT t.id, t.ownerId, t.name, t.photo, t.destinationName, t.destinationCoords, t.cost, t.rating, t.description FROM trips t JOIN favorites f ON t.id = f.tripId WHERE f.ownerId = 'ceva';"
        return readTrips(query: query)
    }
    
    public func delete(tripId: String?) {
        if (db == nil) {
            db = openDB()
        }
        
        let deleteStatementString = "DELETE FROM trips WHERE id = \(String(describing: tripId));"
        var deleteStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, tripId, -1, nil)
            if sqlite3_step(deleteStatement) != SQLITE_DONE {
                print("Could not delete row")
            }
        }
        sqlite3_finalize(deleteStatement)
        closeDbConnection()
    }
    
    private func readTrips(query: String) -> [Trip] {
        if db == nil {
            db = openDB()
        }
        
        var queryStatement:OpaquePointer? = nil
        var trips:[Trip] = []
        
        if (sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK) {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let ownerId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let photo = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let destinationName = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let destinationCoords = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let cost = sqlite3_column_double(queryStatement, 7)
                let rating = sqlite3_column_int(queryStatement, 8)
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                
                trips.append(Trip(id: id, ownerId: ownerId, name: name, photo: photo, destinationName: destinationName, destinationCoords: destinationCoords, cost: cost, rating: rating, description: description))
            }
        }
        sqlite3_finalize(queryStatement)
        closeDbConnection()
        return trips
    }
    
}
