//
//  PersonListView.swift
//  FamilyTree
//
//  Created by Amini on 05/06/22.
//

import SwiftUI

struct PersonListView: View {
    @StateObject var tabsModel: TabsViewModel
    @State var searchQuery = ""
    @State var showMessage = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {

            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $searchQuery)
                }
                .padding(.vertical, 15)
                .padding(.horizontal)
                .background(Color.primary.opacity(0.05))
                .clipShape(Capsule())
                
                VStack(alignment:.leading, spacing: 15) {
                    ForEach(persons){ item in
                        if item.phoneNumber != nil {
                            PersonRowView(tabsModel:tabsModel, person: item)
                        }
                        
                    }
                }
            }
        }
//        .navigationTitle("Bani")
//        .navigationBarHidden(false)
//        .navigationBarTitleDisplayMode(.automatic)
    }
            
}

var Families = Family(id: "1", name: "Harmaen", description:"", members: [""])

var persons = [
    
    Person(
        id:"-3",
        name: "Dani",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "decease|married",
        marriageRelations: ["-2"],
        children: ["0"],
        phoneNumber: nil,
        generationLevel: 0),
    
    Person(
        id:"-2",
        name: "Dina",
        detail: "too close",
        image: "profile",
        gender: "p",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "decease",
        marriageRelations: ["2"],
        children: ["0"],
        phoneNumber: nil,
        generationLevel: 0),
    
    Person(
        id:"-1",
        name: "Roni",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "inlaw|decease",
        marriageRelations: ["2"],
        children: ["1","4"],
        phoneNumber: nil,
        generationLevel: 1),
    
    Person(
        id:"0",
        name: "Rina",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "decease|married",
        marriageRelations: ["-1"],
        children: ["1","4"],
        phoneNumber: nil,
        generationLevel: 1),
    
    Person(
        id:"1",
        name: "Mikasa",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "decease|married",
        marriageRelations: ["2"],
        children: ["3"],
        phoneNumber: nil,
        generationLevel: 2),
    
    Person(
        id:"2",
        name: "Eren",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "inlaw",
        marriageRelations: nil,
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: nil
    ),
    Person(
        id: "3",
        name: "Levy",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "married",
        marriageRelations: ["13"],
        children: ["14"],
        phoneNumber: "+62 12",
        generationLevel: nil
    ),
    Person(
        id: "13",
        name: "Rona",
        detail: "too close",
        image: "profile",
        gender: "p",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "inlaw|married",
        marriageRelations: ["13"],
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: nil
    ),
    Person(
        id: "14",
        name: "Vira",
        detail: "too close",
        image: "profile",
        gender: "p",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "",
        marriageRelations: nil,
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: nil
    ),
    
    Person(
        id: "4",
        name: "Deva",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "married",
        marriageRelations: ["5", "6"],
        children: ["7","8","9","10","11","12"],
//        children: nil,
        phoneNumber: "+62 12",
        generationLevel: 2
    ),

    Person(
        id: "5",
        name: "Defi",
        detail: "too close",
        image: "profile",
        gender: "p",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "inlaw|decease",
        marriageRelations: nil,
        children: ["7","8","9","10","11","12"],
        phoneNumber: nil,
        generationLevel: nil
    ),

    Person(
        id: "6",
        name: "Nina",
        detail: "too close",
        image: "profile",
        gender: "p",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "inlaw",
        children: ["12"],
        phoneNumber: "+62 12",
        generationLevel: nil
    ),

    Person(
        id: "7",
        name: "Jack",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "",
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: 3
    ),

    Person(
        id: "8",
        name: "Yora",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "",
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: 3
    ),

    Person(
        id: "9",
        name: "Riki",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "",
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: 3
    ),

    Person(
        id: "10",
        name: "Reza",
        detail: "too close",
        image: "profile",
        gender: "l",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "",
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: 3
    ),

    Person(
        id: "11",
        name: "Vivi",
        detail: "too close",
        image: "profile",
        gender: "p",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "",
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: 3
    ),

    Person(
        id: "12",
        name: "Sena",
        detail: "too close",
        image: "profile",
        gender: "p",
        dateOfBirth: "21042001",
        placeOfBirth: "Tsm",
        status: "married|inlaw|decease",
        children: nil,
        phoneNumber: "+62 12",
        generationLevel: 3
    )
]

struct PersonRowView: View {
    @StateObject var tabsModel: TabsViewModel
    
    var person: Person
    var body: some View {
        HStack {
            Image(person.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(person.name)
                    .fontWeight(.bold)
                
                Text(person.detail)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            NavigationLink(destination: MessageView(), label: {
                Image(systemName: "message.fill")
                    .foregroundColor(Color("tree"))
                    .padding()
                    .background(Color("youngleaves").opacity(0.2))
                    .clipShape(Circle())
            }).simultaneousGesture(TapGesture().onEnded{
            })
            
            Button(action: {
            }) {
                Image(systemName: "phone.fill")
                    .foregroundColor(Color("tree"))
                    .padding()
                    .background(Color("youngleaves").opacity(0.2))
                    .clipShape(Circle())
            }
        }
    }
}

struct Person: Identifiable, Hashable {
    var id: String
    var name: String
    var detail: String
    var image: String
    var gender: String
    var dateOfBirth: String
    var placeOfBirth: String
    var status: String
    var marriageRelations: [String]?
    var children: [String]?
    var phoneNumber: String?
    var generationLevel: Int?
}

struct Family: Identifiable {
    var id: String
    var name: String
    var description: String
    var members: [String]
}

