//
//  AlertView.swift
//  FamilyTree
//
//  Created by Amini on 04/06/22.
//

import SwiftUI

struct AlertView: View {
    
    var msg: String
    @Binding var show: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            Text("Message")
                .fontWeight(.bold)
                .foregroundColor(Color("tree"))
            
            Text(msg)
                .foregroundColor(.black)
            
            Button(action: {
                withAnimation{
                    show.toggle()
                }
            }, label: {
                Text("Close")
                    .foregroundColor(Color.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(Color("tree"))
                    .clipShape(Capsule())
            })
            .frame(alignment: .center)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3).ignoresSafeArea())
        
    }
    
}

