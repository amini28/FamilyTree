//
//  NestedView.swift
//  FamilyTree
//
//  Created by Amini on 10/06/22.
//

import SwiftUI

class TreeLineViewModel: ObservableObject {
    @Published var lineModel: [TreeLineModel] = []
}

struct TreeLineModel: Identifiable {
    var id: String
    var coordinate: CGRect
}

struct NestedView: View {
    
    @EnvironmentObject private var model: TreeLineViewModel
    
    var nested: Person
    var isOrigin: Bool
    var isLastChild: Bool
    var isHavingSiblings: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ProfileView(person: nested)
                
                if nested.status.contains("married") {
                    
                    ForEach(nested.marriageRelations ?? [], id: \.self) { marrie in
                        let person = persons.filter({ return $0.id == marrie })
                        ForEach(person, id: \.self) { profile in
                            
                            ZStack {
                                Rectangle()
                                    .fill()
                                    .frame(width: 100, height: 2)
                                    .offset(y: 35)
                                Button(action: {}) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                .overlay(
                                    GeometryReader { geo in
                                        addViewCoordinate(proxy: geo, personID: nested.id)
                                    }
                                )
                            }
                            
                            ProfileView(person: profile)
                        }
                    }
                }
                else {
                    ZStack {
                        Button(action: {}) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .overlay(
                            GeometryReader { geo in
                                addViewCoordinate(proxy: geo, personID: nested.id)
                            }
                        )
                    }
                }
            }
            .padding()
            
            if (nested.children ?? []).count != 0 {

                HStack(alignment: .top) {
                    ForEach(nested.children ?? [], id: \.self) { child in
                        let person = persons.filter({ return $0.id == child }) [0]

                        if nested.children?.count ?? 0 > 1 {
                            NestedView(nested: person, isOrigin: false, isLastChild: child == nested.children?.last, isHavingSiblings: true)
                                .environmentObject(model)
                        } else {
                            NestedView(nested: person, isOrigin: false, isLastChild: child == nested.children?.last, isHavingSiblings: false)
                                .environmentObject(model)
                        }
                    }
                }
                .padding(.horizontal, 50)
            }
        }
        .padding(.horizontal, -10)
    }
    
    func addViewCoordinate(proxy: GeometryProxy, personID: String) -> some View {
        print(model.lineModel)
        if model.lineModel.filter({ return $0.id == personID }).isEmpty {
            model.lineModel.append(TreeLineModel(id: personID,
                                                 coordinate: CGRect(origin: proxy.frame(in: .global).origin,
                                                                    size: proxy.frame(in: .global).size)))
        }
        return Color.clear
    }
}

struct ProfileView : View {
    var person: Person
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if person.gender == "l" {
                        Color.cyan.opacity(0.8)
                            .clipShape(Circle())
                    } else {
                        Color.pink.opacity(0.8)
                            .clipShape(Circle())
                    }
                    
                    if person.status.contains("decease") {
                        Image(person.image)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .padding(.vertical, 2)
                            .clipShape(Circle())
                            .grayscale(1)
                    } else {
                        Image(person.image)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .padding(.vertical, 2)
                            .clipShape(Circle())
                    }
                }
                .frame(width: 85, height: 85)
                
                Text(person.name)
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
            }
        }
    }
}

struct NestedView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView()
    }
}
