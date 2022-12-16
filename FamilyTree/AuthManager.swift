//
//  AuthManager.swift
//  FamilyTree
//
//  Created by Amini on 22/06/22.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private var verificationID: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil){ [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                return
            }
            
            self?.verificationID = verificationId
            completion(true)
        }
    }
    
    public func createUser() {
        
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void){
        guard let verificationId = verificationID else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                return
            }
            completion(true)
        }
    }
    
}
