//
//  MessageView.swift
//  FamilyTree
//
//  Created by Amini on 05/06/22.
//

import SwiftUI

struct MessageView: View {
    @StateObject var tabsModel: TabsViewModel = TabsViewModel()

    @State var message = ""
    @State var imagePicker = false
    @State var imgData: Data = Data(count: 0)
    
    @StateObject var allMessage = Messages()
    

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ZStack {
                
                HStack {
                    Button(action: {
                        tabsModel.showTabs.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
//                    Button(action: {}){
//                        Image(systemName: "gear")
//                            .font(.system(size: 22))
//                            .foregroundColor(.white)
//                    }
                }
                
                VStack(spacing: 5) {
                    Text("Raihan")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Active")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .padding(.all)
            
            VStack {
                Spacer()
                
                // Display Message ..
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { reader in
                        VStack(spacing: 20) {
                            ForEach(allMessage.messages) { msg in
                                
                                // Chat Bubbles..
                                ChatBubble(msg: msg)
                            }
                            .onChange(of: allMessage.messages) { (value) in
                                
                                if value.last!.myMessage {
                                    reader.scrollTo(value.last?.id)
                                }
                            }
                        }
                        .padding([.horizontal, .bottom])
                        .padding(.top, 25)
                    }
                }
                    
                withAnimation(.easeInOut) {
                    
                    HStack(spacing: 15) {
                        HStack(spacing: 15) {
                            TextField("Message", text: self.$message)
                            
                            Button(action: {
                                imagePicker.toggle()
                            }) {
                                
                                Image(systemName: "paperclip.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color("tree"))
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color.black.opacity(0.06))
                        .clipShape(Capsule())
                        
                        if message != "" {
                            Button(action: {
                                
                                withAnimation(.easeIn) {
                                    
                                    allMessage.messages.append(Message(id: Date(), message: message, myMessage: true, profilePic: "profile", photo: nil))
                                    
                                    message = ""
                                    
                                }
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 22))
                                    .rotationEffect(.init(degrees: 45))
                                    .padding(.vertical, 12)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 17)
                                    .background(Color.black.opacity(0.07))
                                    .clipShape(Circle())
                                    .foregroundColor(Color("tree"))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
//                .animation(.easeInOut)
            }
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .background(.white)
            .clipShape(RoundedShape())
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color("tree").edgesIgnoringSafeArea(.top))
        
        .fullScreenCover(isPresented: self.$imagePicker, onDismiss: {
            
            if self.imgData.count != 0 {
                allMessage.writeMessage(id: Date(), msg: "", photo: self.imgData, myMessage: true, profilepic: "profile")
            }
        }) {
            ImagePicker(imagePicker: self.$imagePicker, imgData: self.$imgData)
        }
        .navigationBarHidden(true)
    }
}

struct BubbleArrow: Shape {
    
    var myMsg: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: myMsg ? [.topLeft, .bottomLeft, .bottomRight] : [.topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        return Path(path.cgPath)
    }
    
}

struct RoundedShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
    
}

struct ChatBubble: View {
    
    var msg: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            if msg.myMessage {
                
                // Pushing msg to left
                
                // Minimum space
                Spacer(minLength: 25)
                
                if msg.photo == nil {
                    Text(msg.message)
                        .padding(.all)
                        .background(Color.black.opacity(0.06))
                        .clipShape(BubbleArrow(myMsg: msg.myMessage))
                } else {
                    Image(uiImage: UIImage(data: msg.photo!)!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
                        .clipShape(BubbleArrow(myMsg: msg.myMessage))
                }
                
                // Profile Image..
                Image(msg.profilePic)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                
            } else {
                // Pushing msg to Right
                // Profile Image..
                Image(msg.profilePic)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                
                if msg.photo == nil {
                    Text(msg.message)
                        .padding(.all)
                        .foregroundColor(.white)
                        .background(Color("tree"))
                        .clipShape(BubbleArrow(myMsg: msg.myMessage))
                } else {
                    Image(uiImage: UIImage(data: msg.photo!)!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
                        .clipShape(BubbleArrow(myMsg: msg.myMessage))
                }

                Spacer(minLength: 25)

            }
        }
    }
}

struct Message: Identifiable, Equatable {
    var id: Date
    var message: String
    var myMessage: Bool
    var profilePic: String
    var photo: Data?
}

class Messages: ObservableObject {
    @Published var messages: [Message] = []
    
    //Sample Data ..
    
    init() {
        let strings = ["Hii", "Hello !!", "What's Up, What are you doing ??", "Nothing just simply Enjoying quarantine holidays.. you ??", "same :))"]
        
        for i in 0..<strings.count {
            messages.append(Message(id: Date(), message: strings[i], myMessage: i % 2 == 0 ? true : false, profilePic: "profile"))
        }
    }
    
    func writeMessage(id: Date, msg: String, photo: Data?, myMessage: Bool, profilepic: String) {
        
        messages.append(Message(id: id, message: msg, myMessage: myMessage, profilePic: profilepic, photo: photo))
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator.init(parent1: self)
    }
    
    
    @Binding var imagePicker: Bool
    @Binding var imgData: Data
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(parent1: ImagePicker) {
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.imagePicker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            parent.imgData = image.jpegData(compressionQuality: 0.5)!
            parent.imagePicker.toggle()
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
