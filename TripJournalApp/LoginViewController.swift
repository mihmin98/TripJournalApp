//
//  LoginViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/3/21.
//

import UIKit
import Alamofire
import SQLite3
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var googleSignInButton: GIDSignInButton!
    
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
        
        // Google stuff
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
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
        
        // Check if password is empty
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
            
            // Go to home screen
            let homeViewController = self.storyboard?.instantiateViewController(identifier: "home")
            homeViewController?.modalPresentationStyle = .fullScreen
            homeViewController?.modalTransitionStyle = .crossDissolve
            self.present(homeViewController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
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
        
        // TODO: make (user_id, trip_id) be unique
        if sqlite3_exec(db, "create table if not exists favorites (id integer primary key autoincrement, " +
                            "user_id text, trip_id text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        print("tables successfully created!")
    }
}

//mMARK: GOOGLE

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        print("loginvc sign in")
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        //      let userId = user.userID                  // For client-side use only!
        //      let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        //      let givenName = user.profile.givenName
        //      let familyName = user.profile.familyName
        //      let email = user.profile.email
        
        CurrentUser.user.email = user.profile.email
        
        // if there isn't a database entry with the current email then create it
        let request = AF.request("\(Constants.API_URL)/user/\(CurrentUser.user.email!)", method: .get).validate()
        request.responseDecodable(of: User.self) { response in
            guard response.error == nil else {
                if response.response?.statusCode == 404 {
                    // create new account
                    let newUser = User(email: CurrentUser.user.email!, password: "", username: fullName!, favorites: [])
                    
                    let registerRequest = AF.request("\(Constants.API_URL)/user", method: .post, parameters: newUser, encoder: JSONParameterEncoder.default).validate()
                    registerRequest.responseDecodable(of: User.self) { response in
                        guard response.error == nil else {
                            print(response.error?.errorDescription?.description ?? "default value")
                            return
                        }
                    }
                }
                
                return
            }
        }

        // Go to home screen
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "home")
        homeViewController?.modalPresentationStyle = .fullScreen
        homeViewController?.modalTransitionStyle = .crossDissolve
        self.present(homeViewController!, animated: true, completion: nil)
    }
}
