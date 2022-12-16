//
//  JoinCodeView.swift
//  FamilyTree
//
//  Created by Amini on 23/06/22.
//

import SwiftUI

struct JoinCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var joinCode: String = ""
    var body: some View {
        ZStack {
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
                
                VStack(alignment: .leading){
                    
                    Text("Enter the code provided by family admin")
                        .font(.callout)
                        .foregroundColor(Color("tree"))
                        
                    TextField("", text: $joinCode)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Divider()
                        .background(.black)
                }.padding(.bottom, 50)

                
                VStack(alignment: .leading){
                    
                    Text("Enter Your Name")
                        .font(.callout)
                        .foregroundColor(Color("tree"))
                        
                    TextField("", text: $joinCode)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Divider()
                        .background(.black)
                }.padding(.bottom, 50)
                
                VStack(alignment: .leading){
                    
                    Text("Enter Your Phone Number")
                        .font(.callout)
                        .foregroundColor(Color("tree"))
                        
                    TextField("", text: $joinCode)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Divider()
                        .background(.black)
                }.padding(.bottom, 50)
                
                Button(action: {}, label: {
                    Text("Request to Join")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
//                        .foregroundColor(formViewModel.isPhoneNumberValid ? Color.white : Color.white.opacity(0.5))
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width - 60, height: 50)
//                        .background(formViewModel.isPhoneNumberValid ? Color("tree") : Color.gray)
                        .background(Color("tree"))
                        .clipShape(Capsule())
                    
                })
                .padding()
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct JoinCodeView_Previews: PreviewProvider {
    static var previews: some View {
        JoinCodeView()
    }
}
