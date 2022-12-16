//
//  HomeView.swift
//  FamilyTree
//
//  Created by Amini on 04/06/22.
//

import SwiftUI
import Foundation
import Combine

class TabsViewModel: ObservableObject {
    @Published var selected: Tab = .house
    @Published var showTabs: Bool = true
}

struct BasicTabView : View {
    @StateObject var tabsModel: TabsViewModel = TabsViewModel()
    @State var titleHidden: Bool = false
    
    init(){
        UITabBar.appearance().backgroundColor = UIColor(Color("tree"))
        UITabBar.appearance().barTintColor = UIColor(Color("tree"))
        UITabBar.appearance().unselectedItemTintColor = UIColor(.white.opacity(0.5))
    }
        
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $tabsModel.selected) {
                    EventView()
                        .tag(Tab.house)
                        .tabItem {
                            Image(systemName: "house")
                        }
                    TreeView()
                        .tag(Tab.person)
                        .tabItem {
                            Image(systemName: "person")
                        }
                    PersonListView(tabsModel: tabsModel)
                        .tag(Tab.message)
                        .tabItem {
                            Image(systemName: "message")
                        }
                }
                .accentColor(.white)
            }
            .navigationTitle("Bani")
            .navigationBarHidden(false)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

struct CustomTabView: View {
    @StateObject var tabsModel: TabsViewModel = TabsViewModel()
    @State var titleHidden: Bool = false
    
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack {
            TabView(selection: $tabsModel.selected) {
                
                EventView()
                    .tag(Tab.house)

                TreeView()
                    .tag(Tab.person)

                PersonListView(tabsModel: tabsModel)
                    .tag(Tab.message)
            }
        
            if tabsModel.showTabs {
                withAnimation() {
                    
                    HStack(spacing: 0) {
                        TabBarButton(image: "house", selectedTab: $tabsModel.selected, current: .house)
                        TabBarButton(image: "person", selectedTab: $tabsModel.selected, current: .person)
                        TabBarButton(image: "message", selectedTab: $tabsModel.selected, current: .message)
                    }
                    .padding()
                    .background(Color("tree"))
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        BasicTabView()
    }
}

struct TabBarButton: View {
    
    var image: String
    @Binding var selectedTab: Tab
    var current: Tab
    
    
    var body: some View {
        
        GeometryReader{ reader in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)){
                        selectedTab = current
                    }
                }){
                    Image(systemName: "\(image)\(selectedTab.rawValue == image ? ".fill" : "")")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(Color.white)
                    
                        .offset(y: selectedTab.rawValue == image ? -10 : 0)
                }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 50)
    }
    
}

enum Tab: String, CaseIterable {
    case house = "house"
    case person = "person"
    case message = "message"
}
