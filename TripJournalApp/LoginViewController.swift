//
//  LoginViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/3/21.
//

import UIKit
import Alamofire
import SQLite3

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    let emptyEmailAlert = UIAlertController(title: "Email is empty", message: "Please type email", preferredStyle: .alert)
    let emptyPasswordAlert = UIAlertController(title: "Password is empty", message: "Please type password", preferredStyle: .alert)
    let loginAlert = UIAlertController(title: "Login error", message: "error message", preferredStyle: .alert)
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        
        emptyEmailAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        emptyPasswordAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        loginAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        
        // create database
        db = createDataBaseConnection() as OpaquePointer?
        createTables()
        closeDbConnection()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: ACTIONS
    
    @IBAction func login(_ sender: Any) {
        // Check if email is empty
        if (email.text?.count == 0 || email.text == nil) {
            self.present(emptyEmailAlert, animated: true, completion: nil)
            return
        }
        
        // Chekc if password is empty
        if (password.text?.count == 0 || password.text == nil) {
            self.present(emptyPasswordAlert, animated: true, completion: nil)
            return
        }
        
        // Create login request from input
        let loginRequest = LoginRequest(email: email.text, password: password.text)
                
        // Create request that contains the LoginRequest
        let request = AF.request("\(Constants.API_URL)/user/login", method: .post, parameters: loginRequest, encoder: JSONParameterEncoder.default).validate()
        var returnedUser = User()

        // Perform request(?), check if successful and save received user
        request.responseDecodable(of: User.self) { response in
            guard response.error == nil else {
                print(response.error?.errorDescription?.description ?? "default value")
                self.loginAlert.message = response.error?.errorDescription?.description
                self.present(self.loginAlert, animated: true, completion: nil)
                return
            }
            
            returnedUser = response.value!
            CurrentUser.user.copy(user: returnedUser)
        }
        
        // Go to home screen
        let homeViewController = storyboard?.instantiateViewController(identifier: "home")
        homeViewController?.modalPresentationStyle = .fullScreen
        homeViewController?.modalTransitionStyle = .crossDissolve
        present(homeViewController!, animated: true, completion: nil)
    }
    
    //MARK: DATABASE
    
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
                            "ownerId text, name text, photo text, destinationName text, destinationCoords text, " +
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
