//
//  Session.swift
//  Memo
//
//  Created by 박원빈 on 2020/05/17.
//  Copyright © 2020 PoApper. All rights reserved.
//

import Foundation
import Combine
import KeychainSwift

class Session: ObservableObject {
    @Published var isAuth = false
    private let keychain: KeychainSwift
    
    private var newMemoAction = false
    var newMemo: Bool {
        get {
            let temp = newMemoAction
            newMemoAction = false
            return temp
        }
    }
    
    init() {
        keychain = KeychainSwift()
    }
    
    func auth(password: String) -> Bool {
        if password == keychain.get("password") {
            isAuth = true
        } else {
            isAuth = false
        }
        return isAuth
    }
    
    func setPassword(_ password: String) {
        keychain.set(password, forKey: "password")
    }
    
    func deletePasswoed() {
        keychain.delete("password")
    }
    
    func passWordIsSet() -> Bool {
        if (keychain.get("password") != nil) {
            return true
        } else {
            return false
        }
    }
    
    func quickAction(_ quickAction: String) {
        if quickAction == "NewMemo" {
            newMemoAction = true
        }
    }
}
