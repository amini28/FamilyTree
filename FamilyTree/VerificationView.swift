//
//  VerificationView.swift
//  FamilyTree
//
//  Created by Amini on 02/06/22.
//

import SwiftUI

struct VerificationView: View {
    
    @StateObject var loginData = LoginViewModel()
    @State var error:Bool = false
    @State var showSuccessResult: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack {
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(Color("tree"))
                        }
                        
                        Spacer()
                        
                    }
                    .padding()
                    
                    Text("Code Sent To +62-813-135-097-50")
                        .foregroundColor(Color("tree"))
                        .padding()
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 15) {
                        ForEach(0..<6, id: \.self) { index in
                            CodeView(code: getCodeAtIndex(index: index))
                        }
                    }
                    .padding()
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 6) {
                        Text("Didn't Receive Code ?")
                            .foregroundColor(Color("tree"))

                        Button(action: {}) {
                            Text("Request Again")
                                .fontWeight(.bold)
                                .foregroundColor(Color("tree"))

                        }
                    }
                    
                    Button(action: {}){
                        Text("Get via Call")
                            .foregroundColor(Color("tree"))
                            .fontWeight(.bold)
                    }
                    .padding(.top, 6)
                    
                    Button(action: {
//                        error = true
                        showSuccessResult.toggle()
                    }){
                        Text("Verify Code")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .background(Color("tree"))
                            .cornerRadius(15)
                    }
                    .padding()
                    .fullScreenCover(isPresented: $showSuccessResult, content: {
                        RegistrationView()
                    })
                }
                .frame(height: UIScreen.main.bounds.height/1.8)
                .background(.white)
                .cornerRadius(20)
                
                Spacer()
                
                CustomNumberPad(value: $loginData.code, isVerify: true)
            }
            .background(.white)
            
            if error {
                AlertView(msg: "Showing Error", show: $error)
            }
        }
    }
    
    func getCodeAtIndex(index: Int) -> String {
        
        if loginData.code.count > index {
            let start = loginData.code.startIndex
            let current = loginData.code.index(start, offsetBy: index)
            
            return String(loginData.code[current])
        }
        return ""
    }
}

struct CodeView: View {
    var code: String
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Text(code)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .font(.title2)
                .frame(height: 45)
            
            Capsule()
                .fill(Color("tree").opacity(0.5))
                .frame(height: 4)
            
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
