//
//  RegistrationView.swift
//  FamilyTree
//
//  Created by Amini on 02/06/22.
//

import SwiftUI
import Combine

struct RegistrationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var model: ProfileModelData = ProfileModelData()
    @State var showHomeView = false
    
    var body: some View {
        VStack (alignment: .center) {
            
            ZStack {
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                }
                
                VStack(spacing: 5) {
                    Text("Join in family of")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("....")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .padding(.all)
            
            ScrollView {
                VStack {
                    ZStack{
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(Color("youngleaves").opacity(0.5))
                            .frame(width: 120, height: 120)
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(Color("tree"))
                            .frame(width: 35, height: 35)
                            .offset(x: 40, y: -50)
                    }
                    .padding()
                    
                    CustomTextField(txt: $model.email, image: "person.text.rectangle", placeholder: "Name")
                    CustomTextField(txt: $model.email, image: "person.text.rectangle", placeholder: "Parents Name")
                    CustomTextField(txt: $model.email, image: "mappin.square", placeholder: "Tempat Lahir")
                    CustomTextField(txt: $model.email, image: "calendar", placeholder: "Tanggal Lahir")
                    
                    CustomTextField(txt: $model.email, image: "person.text.rectangle", placeholder: "Parents Name")
                    CustomTextField(txt: $model.email, image: "mappin.square", placeholder: "Tempat Lahir")
                    CustomTextField(txt: $model.email, image: "calendar", placeholder: "Tanggal Lahir")

                }
                .background(.white)
                .clipShape(RoundedShape())
            }
            
            Button(action: {
                showHomeView.toggle()
            }){
                Text("Continue")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color("tree"))
                    .clipShape(Capsule())
            }
            .padding()
            .fullScreenCover(isPresented: $showHomeView) {
//                CustomTabView()
                BasicTabView()
            }
            
        }

        .background(
            VStack {
                Rectangle()
                .fill()
                .foregroundColor(Color("tree"))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2, alignment: .top)
                
                Rectangle()
                .fill()
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2, alignment: .bottom)
            }
                .ignoresSafeArea()
        )
    }
}

struct CustomTextField: View {
    
    @Binding var txt: String
    var image: String
    var placeholder: String
    
    var body: some View {
        HStack{
            Image(systemName: image)
                .font(.system(size: 26))
                .foregroundColor(Color.gray)
                .frame(width: 50, height: 50)
            
            VStack {
                TextField(placeholder, text: $txt)
                    .frame(height: 45)
                    .padding(.vertical, 1)

                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
            }
            .padding(.horizontal, 2)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)

    }
}

class ProfileModelData: ObservableObject {
    
    @Published var email = ""
    @Published var passoword = ""
    
}

struct RegistrationPreviews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
