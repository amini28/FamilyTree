//
//  LoginViewModel.swift
//  FamilyTree
//
//  Created by Amini on 02/06/22.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var phoneNumber = ""
    @Published var code = ""
}
