//
//  TreeView.swift
//  FamilyTree
//
//  Created by Amini on 03/06/22.
//

import SwiftUI
import CoreGraphics

struct TreeView: View {
    
    @StateObject private var treeLine: TreeLineViewModel = TreeLineViewModel()
    
    @State var scale: CGFloat = 1.0
    @State var isFirst: Bool = true
    
    var body: some View {
        VStack {
            ScrollView([.horizontal, .vertical]){
                ZStack {
                    let person = persons.filter( { return $0.id == "-3" } )[0]
                    VStack {
                        NestedView(nested: person, isOrigin: true, isLastChild: false, isHavingSiblings: false)
                            .environmentObject(treeLine)
                    }
//                    .scaleEffect(0.3)
//                    DrawLine
                    LineView(nested: person).environmentObject(treeLine)
                }
//                .overlay(
//                    DrawLine
//                )
//                .scaleEffect(0.3)
            }
        }
//        .navigationTitle("Bani")
//        .navigationBarHidden(false)
//        .navigationBarTitleDisplayMode(.automatic)
    }
    
//    var DrawLine: some View {
//
//        checkOriginPoint()
//        return ZStack{
//            ForEach(treeLine.lineModel){ line in
//                ParentChildLine(startPoint: lastOriginPoint, breakPoint: [], endPoint: line.coordinate.origin)
//                    .stroke(.red, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
//                    .onAppear {
//                        lastOriginPoint = line.coordinate.origin
//                    }
//            }
//        }
//    }
    
    @State var lastOriginPoint: CGPoint = CGPoint(x: 0, y: 0)
    func checkOriginPoint() {
        if !treeLine.lineModel.isEmpty {
            lastOriginPoint = treeLine.lineModel[0].coordinate.origin
        }
    }
    
    func scaleOut() {
        print("test out")
        self.scale = scale - 0.2
    }
    
    func scaleIn() {
        print("test in")
        self.scale = scale + 0.2
    }
    
}

struct LineView: View {
    var nested: Person
    @EnvironmentObject private var treeLine: TreeLineViewModel

    var body: some View {
        ZStack {
            if let parentCoordinate = treeLine.lineModel.filter({ $0.id == nested.id }).first {
                
                if (nested.children ?? []).count > 1 {
                    ForEach((nested.children ?? []), id: \.self) { child in
                        if let childProfile = persons.filter({ return $0.id == child }).first,
                           let childCoordinate = treeLine.lineModel.filter({ $0.id == childProfile.id }).first {
                            
                            let starpoint = parentCoordinate.coordinate.origin
                            let endpoint = childCoordinate.coordinate.origin
                            
                            let breakpoint = [
                                CGPoint(x: starpoint.x,
                                        y: starpoint.y + (endpoint.y - starpoint.y)/2),
                                CGPoint(x: endpoint.x,
                                        y: starpoint.y + (endpoint.y - starpoint.y)/2)
                            ]
                            
                            ParentChildLine(startPoint: starpoint,
                                            breakPoint: breakpoint,
                                            endPoint: endpoint)
                            .stroke(.red, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                            
                            LineView(nested: childProfile).environmentObject(treeLine)
                        }
                    }
                } else if (nested.children ?? []).count == 1 {
                    if let childProfile = persons.filter({ return $0.id == nested.children![0] }).first,
                       let childCoordinate = treeLine.lineModel.filter({ $0.id == childProfile.id }).first {
                        
                        let starpoint = parentCoordinate.coordinate.origin
                        let endpoint = childCoordinate.coordinate.origin
                        
                        ParentChildLine(startPoint: starpoint,
                                        breakPoint: [],
                                        endPoint: CGPoint(x: starpoint.x, y: endpoint.y))
                        .stroke(.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        
                        LineView(nested: childProfile).environmentObject(treeLine)
                    }
                }
            }
        }
    }
}

struct ParentChildLine: Shape {
    var startPoint: CGPoint
    var breakPoint: [CGPoint]
    var endPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var linkPath = Path()
        
        linkPath.move(to: startPoint)
        if !breakPoint.isEmpty {
            for point in breakPoint {
                linkPath.addLine(to: point)
            }
        }
        linkPath.addLine(to: endPoint)
        
        return linkPath
    }
}

struct Tree_Previews: PreviewProvider {
    static var previews: some View {
        TreeView()
    }
}
