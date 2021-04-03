//
//  ViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/3/21.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db = createDataBaseConnection() as OpaquePointer?
        createTables()
        closeDbConnection()
    }
    
    func createDataBaseConnection() -> OpaquePointer? {
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
        print("successfully opening database")
        return db
    }
    
    func closeDbConnection() {
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        print("successfully closing database")
    }
    
    func createTables() {
        if sqlite3_exec(db, "create table if not exists user (username text, email text primary key, favorite_id integer)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "create table if not exists trip (id text primary key, " +
                            "ownerId text, name text, photo blob, destinationName text, destinationCoords text, " +
                            "cost real, rating integer, description text, favorite_id integer)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "create table if not exists favorites (id integer primary key autoincrement, " +
                            "user_id integer, trip_id text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        print("tables successfully created!")
    }
    
}

