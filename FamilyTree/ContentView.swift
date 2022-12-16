//
//  ContentView.swift
//  FamilyTree
//
//  Created by Amini on 01/06/22.
//

import SwiftUI
import Lottie
import Foundation
import Combine
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        SplashScreen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum PhoneNumberStatus {
    case empty
    case invalid
    case valid
}

class FormViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var isPhoneNumberValid = false
    @Published var selectedCountryCode = "+62"
    @Published var inlineErrorForPhoneNumber = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private var isPhoneNumberValidPublisher: AnyPublisher <PhoneNumberStatus, Never> {
        $phoneNumber
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                if $0.first == "0" { return PhoneNumberStatus.invalid }
                else if $0.count <= 9 { return PhoneNumberStatus.invalid }
                else if $0.isEmpty { return PhoneNumberStatus.empty }
                return PhoneNumberStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormPhoneNumberValid: AnyPublisher <Bool, Never> {
        isPhoneNumberValidPublisher
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 == .valid }
            .eraseToAnyPublisher()
    }
    
    init() {
        isFormPhoneNumberValid
            .receive(on: RunLoop.main)
            .assign(to: \.isPhoneNumberValid, on: self)
            .store(in: &cancellables)
        
        
        isPhoneNumberValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { phoneNumberStatus in
                switch phoneNumberStatus {
                case .empty:
                    return "Phone number is empty"
                case .invalid:
                    return "Phone number is invalid"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForPhoneNumber, on: self)
            .store(in: &cancellables)
    }
        
}

fileprivate func extractedFunc() -> FormViewModel {
    return FormViewModel()
}

struct SplashScreen: View {
    
    @State var show = false
    
    @StateObject private var formViewModel = FormViewModel()
    
    @State var showVerifyNumberView = false
    @State var showRegistrationView = false
    @State var showJoinFamilyView = false
    @State var showCountryCodeSelection = false
    
    @FocusState private var phoneNumberFieldFocused: Bool
        
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    AnimatedView(show: $show)
                        .frame(height: UIScreen.main.bounds.height / 2)
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 10, content: {
                                Text("Login")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("tree"))

                                Text("Enter your phone number to continue")
                                    .foregroundColor(Color("tree"))
                            })
                            Spacer(minLength: 15)
                        }
                        
                        VStack {
                            HStack {
                                Text(formViewModel.selectedCountryCode)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("tree"))
                                    .onTapGesture {
                                        showCountryCodeSelection.toggle()
                                    }

                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 1, height: 18)
                                
                                TextField("", text: $formViewModel.phoneNumber)
                                    .keyboardType(.numberPad)
                                    .focused($phoneNumberFieldFocused)
                            }
                            
                            Divider()
                                .foregroundColor(Color("tree"))
                            
                            Text("\(formViewModel.inlineErrorForPhoneNumber)")
                                .font(.callout)
                                .foregroundColor(.red)

                        }
                        .padding()
                        
                        Button(action: {
                            
//                            AuthManager.shared.startAuth(phoneNumber: formViewModel.phoneNumber){ success in
//                                guard success else {
//                                    print("0000000000000iiiii--- failed auth")
//                                    return
//                                }
//                                DispatchQueue.main.sync {
//                                    showVerifyNumberView.toggle()
//                                }
//                            }
                            showVerifyNumberView.toggle()
                            
                        }, label: {
                            Text("Verify Number")
                                .fontWeight(.bold)
                                .foregroundColor(formViewModel.isPhoneNumberValid ? Color.white : Color.white.opacity(0.5))
                                .padding(.vertical, 10)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                                .background(formViewModel.isPhoneNumberValid ? Color("tree") : Color.gray)
                                .clipShape(Capsule())
                        })
                        .disabled(!formViewModel.isPhoneNumberValid)
                        .fullScreenCover(isPresented: $showVerifyNumberView) {
                            VerificationView()
                        }
                        
                        HStack {
                            Rectangle()
                                .fill()
                                .frame(height: 1)
                                .foregroundColor(Color("tree"))
                            Text("or")
                                .font(.callout)
                                .foregroundColor(Color("tree"))
                            Rectangle()
                                .fill()
                                .frame(height: 1)
                                .foregroundColor(Color("tree"))
                        }

                        HStack(spacing: 15) {
                            
                            Button(action: {
                                showJoinFamilyView.toggle()
                            }, label: {
                                HStack(spacing: 10) {
                                    Text("Join Family")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("tree"))
                                }
                                .padding(.vertical, 10)
                                .frame(width: UIScreen.main.bounds.width/2 - 30, height: 50)
                                .background(Color.white)
                                .clipShape(Capsule())
                            })
                            .fullScreenCover(isPresented: $showJoinFamilyView) {
                                JoinCodeView()
                            }
                            
                            Button(action: {
                                showRegistrationView.toggle()
                            }, label: {
                                HStack(spacing: 10) {
                                    Text("Register Family")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("tree"))
                                }
                                .padding(.vertical, 10)
                                .frame(width: UIScreen.main.bounds.width/2 - 30, height: 50)
                                .background(.white)
                                .clipShape(Capsule())
                            })
                            .fullScreenCover(isPresented: $showRegistrationView) {
                                CreateFamilyView()
                            }
                        }
                    }
                    .padding()
                    .background(Color("youngleaves").opacity(0.5))
                    .cornerRadius(20)
                    .padding()
                    
                    .frame(height: show ? nil : 0)
                    .opacity(show ? 1 : 0)
                }
                .sheet(isPresented: $showCountryCodeSelection) {
                    SelectionCountryCodeView(dialCode: $formViewModel.selectedCountryCode)
                }
            }
        }
        .onTapGesture {
            phoneNumberFieldFocused = false
        }
    }
}

struct SelectionCountryCodeView: View {
    
    @Binding var dialCode: String
    @Environment(\.presentationMode) var presentationMode

    @State var selectedCode: CountryCode?
    var countryCode: [CountryCode] = CountryCode.all

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("tree"))
                })
                .frame(width: 50, height: 50)
                
                List(selection: $selectedCode) {
                    ForEach(countryCode, id: \.code) { code in
                        HStack {
                            Text("\(code.name)")
                                .hLeading()
                            
                            if selectedCode == code {
                                HStack {
                                    Text("\(code.dial_code)")
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title)
                                }
                                .hTrailing()

                            } else {
                                Text("\(code.dial_code)")
                                    .hTrailing()
                            }
                        }
                        .padding(5)
                        .onTapGesture {
                            selectedCode = code
                            dialCode = code.dial_code
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct CountryCode: Codable, Hashable {
    var name: String
    var dial_code: String
    var code: String
    
    static let all: [CountryCode] = Bundle.main.decode(file: "CountryCode.json")
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}


struct AnimatedView: UIViewRepresentable {
    
    @Binding var show: Bool
    
    func makeUIView(context: Context) -> some AnimationView {
        let view = AnimationView(name: "fallen-tree-and-wind", bundle: Bundle.main)
        
        view.play(fromProgress: 1, toProgress: 0) { (status) in
            
            if status {
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)){
                    show.toggle()
                }
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
