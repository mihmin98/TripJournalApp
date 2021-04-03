//
//  LoginViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/3/21.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    let emptyEmailAlert = UIAlertController(title: "Email is empty", message: "Please type email", preferredStyle: .alert)
    let emptyPasswordAlert = UIAlertController(title: "Password is empty", message: "Please type password", preferredStyle: .alert)
    let loginAlert = UIAlertController(title: "Login error", message: "error message", preferredStyle: .alert)
    
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
        
        // TODO: Go to main scene
    }
}
