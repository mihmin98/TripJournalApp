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
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)

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
            let tripId = trip.id! as NSString
            sqlite3_bind_text(insertStatement, 1, tripId.utf8String, -1, SQLITE_TRANSIENT)
            let ownerId = trip.ownerId! as NSString
            sqlite3_bind_text(insertStatement, 2, ownerId.utf8String, -1, SQLITE_TRANSIENT)
            let tripName = trip.name! as NSString
            sqlite3_bind_text(insertStatement, 3, tripName.utf8String, -1, SQLITE_TRANSIENT)
            let tripPhoto = trip.photo! as NSString
            sqlite3_bind_text(insertStatement, 4, tripPhoto.utf8String, -1, SQLITE_TRANSIENT)
            let tripDestinationName = trip.destinationName! as NSString
            sqlite3_bind_text(insertStatement, 5, tripDestinationName.utf8String, -1, SQLITE_TRANSIENT)
            let tripDestinationCoords = trip.destinationCoords! as NSString
            sqlite3_bind_text(insertStatement, 6, tripDestinationCoords.utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_double(insertStatement, 7, trip.cost)
            sqlite3_bind_int(insertStatement, 8, trip.rating)
            let tripDescription = trip.description! as NSString
            sqlite3_bind_text(insertStatement, 9, tripDescription.utf8String, -1, SQLITE_TRANSIENT)
        }

        if sqlite3_step(insertStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
        closeDbConnection()
    }
    
    public func update(trip: Trip) {
        if (db == nil) {
            db = openDB()
        }
        
        let updateStatementString = "UPDATE trip SET ownerId = ?, name = ?, photo = ?, destinationName = ?, destinationCoords = ?, cost = ?, rating = ?, description = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil;
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            let ownerId = trip.ownerId! as NSString
            sqlite3_bind_text(updateStatement, 1, ownerId.utf8String, -1, SQLITE_TRANSIENT)
            let tripName = trip.name! as NSString
            sqlite3_bind_text(updateStatement, 2, tripName.utf8String, -1, SQLITE_TRANSIENT)
            let tripPhoto = trip.photo! as NSString
            sqlite3_bind_text(updateStatement, 3, tripPhoto.utf8String, -1, SQLITE_TRANSIENT)
            let tripDestinationName = trip.destinationName! as NSString
            sqlite3_bind_text(updateStatement, 4, tripDestinationName.utf8String, -1, SQLITE_TRANSIENT)
            let tripDestinationCoords = trip.destinationCoords! as NSString
            sqlite3_bind_text(updateStatement, 5, tripDestinationCoords.utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_double(updateStatement, 6, trip.cost)
            sqlite3_bind_int(updateStatement, 7, trip.rating)
            let tripDescription = trip.description! as NSString
            sqlite3_bind_text(updateStatement, 8, tripDescription.utf8String, -1, SQLITE_TRANSIENT)
            
            let tripId = trip.id! as NSString
            sqlite3_bind_text(updateStatement, 9, tripId.utf8String, -1, SQLITE_TRANSIENT)
        }

        if sqlite3_step(updateStatement) != SQLITE_DONE {
            print("Could not update row")
        }
        
        sqlite3_finalize(updateStatement)
        closeDbConnection()
    }
    
    public func getTripById(tripId: String?) -> Trip? {
        let query: String = "SELECT * FROM trip WHERE id = '\(String(describing: tripId!))';"
        let trips = readTrips(query: query)
        if trips.count == 1 {
            return trips[0]
        } else {
            return nil
        }
    }
    
    public func readMyTrips() -> [Trip] {
        let query: String = "SELECT * FROM trip WHERE ownerId = '\(String(describing: CurrentUser.user.email!))';"
        return readTrips(query: query)
    }
    
    public func readFavoriteTrips() -> [Trip] {
        let query: String = "SELECT t.id, t.ownerId, t.name, t.photo, t.destinationName, t.destinationCoords, t.cost, t.rating, t.description FROM trip t JOIN favorites f ON t.id = f.trip_id WHERE f.user_id = '\(String(describing: CurrentUser.user.email!))';"
        return readTrips(query: query)
    }
    
    public func delete(tripId: String?) {
        if (db == nil) {
            db = openDB()
        }
        
        let deleteStatementString = "DELETE FROM trip WHERE id = \(String(describing: tripId));"
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
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let ownerId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let photo = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let destinationName = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let destinationCoords = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let cost = sqlite3_column_double(queryStatement, 6)
                let rating = sqlite3_column_int(queryStatement, 7)
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                
                trips.append(Trip(id: id, ownerId: ownerId, name: name, photo: photo, destinationName: destinationName, destinationCoords: destinationCoords, cost: cost, rating: rating, description: description))
            }
        }
        sqlite3_finalize(queryStatement)
        closeDbConnection()
        return trips
    }
    
    public func addFavoriteTrip(userId: String, tripId: String) {
        if db == nil {
            db = openDB()
        }

        let insertStatementString = "insert into favorites (user_id, trip_id) values (?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let user_id = userId as NSString
            sqlite3_bind_text(insertStatement, 1, user_id.utf8String, -1, SQLITE_TRANSIENT)
            let trip_id = tripId as NSString
            sqlite3_bind_text(insertStatement, 2, trip_id.utf8String, -1, SQLITE_TRANSIENT)

        }
        if sqlite3_step(insertStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: (errmsg)")
        }
        sqlite3_finalize(insertStatement)
        closeDbConnection()
    }

    public func deleteFavoriteTrip(userId: String, tripId: String) {
        if db == nil {
            db = openDB()
        }
        
        let deleteStatementString = "DELETE FROM favorites WHERE user_id = '\(String(describing: userId))' AND trip_id = '\(String(describing: tripId))';"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            let user_id = userId as NSString
            sqlite3_bind_text(deleteStatement, 1, user_id.utf8String, -1, SQLITE_TRANSIENT)
            let trip_id = tripId as NSString
            sqlite3_bind_text(deleteStatement, 2, trip_id.utf8String, -1, SQLITE_TRANSIENT)
            if sqlite3_step(deleteStatement) != SQLITE_DONE {
                print("Could not delete row")
            }
        }
        sqlite3_finalize(deleteStatement)
        closeDbConnection()
    }
}
