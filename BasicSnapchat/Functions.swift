//
//  Functions.swift
//  BasicSnapchat
//
//  Created by Hasan Kaya on 25.05.2022.
//

import Foundation
import UIKit


func makeAlert(title :String, message : String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(okButton)
    return alert
    
}
