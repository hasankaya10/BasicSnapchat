//
//  UserSingleton.swift
//  BasicSnapchat
//
//  Created by Hasan Kaya on 26.05.2022.
//

import Foundation


class UserSingleton{
    
    static let sharedUserInfo = UserSingleton()
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
}
