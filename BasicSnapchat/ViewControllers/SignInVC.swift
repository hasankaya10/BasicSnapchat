//
//  ViewController.swift
//  BasicSnapchat
//
//  Created by Hasan Kaya on 25.05.2022.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func SignInButtonTouched(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != ""  {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil {
                    self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "Error be an occured"), animated: true)
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            present(makeAlert(title: "Error", message: "Please enter an E-Mail , Password and Username"), animated: true)
        }
        
    }
    @IBAction func SignUpButtonTouched(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" && usernameTextField.text != nil {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil {
                    self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "Error be an occured"), animated: true)
                } else {
                    
                    let userDictionary = ["email" : self.emailTextField.text!, "username" : self.usernameTextField.text!] as [String : Any]
                    let firestore = Firestore.firestore().collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            self.present(makeAlert(title: "Error", message: error?.localizedDescription ?? "" ), animated: true)
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            present(makeAlert(title: "Error", message: "Please enter an E-Mail , Password and Username"), animated: true)
        }
    }
    

}

