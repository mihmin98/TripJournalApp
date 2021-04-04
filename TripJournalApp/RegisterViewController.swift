//
//  RegisterViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/3/21.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    
    let emptyEmailAlert = UIAlertController(title: "Email is empty", message: "Please type email", preferredStyle: .alert)
    let emptyPasswordAlert = UIAlertController(title: "Password is empty", message: "Please type password", preferredStyle: .alert)
    let emptyUsernameAlert = UIAlertController(title: "Username is empty", message: "Please type username", preferredStyle: .alert)
    let registerAlert = UIAlertController(title: "Register error", message: "error message", preferredStyle: .alert)
    let createdUserAlert = UIAlertController(title: "Created User", message: "Successfully created user", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.delegate = self
        password.delegate = self
        username.delegate = self
        
        emptyEmailAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        emptyPasswordAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        emptyUsernameAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        registerAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        createdUserAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            // Go back to login screen
            let loginViewController = self.storyboard?.instantiateViewController(identifier: "login")
            loginViewController?.modalPresentationStyle = .fullScreen
            loginViewController?.modalTransitionStyle = .crossDissolve
            self.present(loginViewController!, animated: true, completion: nil)
        }))
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }

    
    //MARK: ACTIONS

    @IBAction func register(_ sender: Any) {
        if (email.text?.count == 0 || email.text == nil) {
            self.present(emptyEmailAlert, animated: true, completion: nil)
            return
        }
        
        if (password.text?.count == 0 || password.text == nil) {
            self.present(emptyPasswordAlert, animated: true, completion: nil)
            return
        }
        
        if (username.text?.count == 0 || password.text == nil) {
            self.present(emptyUsernameAlert, animated: true, completion: nil)
            return
        }
        
        let newUser = User(email: email.text!, password: password.text!, username: username.text!, favorites: [])
        var createdUser = User()
        
        let request = AF.request("\(Constants.API_URL)/user", method: .post, parameters: newUser, encoder: JSONParameterEncoder.default).validate()
        
        request.responseDecodable(of: User.self) { response in
            guard response.error == nil else {
                print(response.error?.errorDescription?.description ?? "default value")
                self.registerAlert.message = response.error?.errorDescription?.description
                self.present(self.registerAlert, animated: true, completion: nil)
                return
            }
            
            createdUser = response.value!
            self.present(self.createdUserAlert, animated: true, completion: nil)
        }
    }
}
