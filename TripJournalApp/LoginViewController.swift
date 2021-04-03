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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        
        emptyEmailAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        emptyPasswordAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
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
        /*
        print("email: \(email.text); password: \(password.text)")
        */
        
        if (email.text?.count == 0) {
            self.present(emptyEmailAlert, animated: true, completion: nil)
            return
        }
        
        if (password.text?.count == 0) {
            self.present(emptyPasswordAlert, animated: true, completion: nil)
            return
        }
        
        let url = "https://ab89a8a8dbef.ngrok.io/user/login"
        
        let request = AF.request(url, method: .post).validate()
        request.responseJSON{ (data) in print(data) }
    }
}
