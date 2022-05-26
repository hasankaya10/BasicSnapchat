//
//  LogOutViewController.swift
//  BasicSnapchat
//
//  Created by Hasan Kaya on 25.05.2022.
//

import UIKit
import Firebase
class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func LogOutButtonTouched(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        } catch {
            self.present(makeAlert(title: "Error", message: "Not Log Out"), animated: true)
        }
    }
    
}
