//
//  ContentView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .featured
    
    enum Tab {
            case featured
            case list
        }
    init() {
        //修改tabbar底部的背景色
        UITabBar.appearance().backgroundColor = .white
//        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    var body: some View {
        NavigationView{
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        Label("首页", systemImage: "house")
                    }
                    .tag(Tab.featured)
                
                TagView()
                    .tabItem {
                        Label("节点", systemImage: "tag")
                    }
                    .tag(Tab.featured)
                
                MyView()
                    .tabItem {
                        Label("我的", systemImage: "person")
                    }
                    .tag(Tab.list)
            }
            .accentColor(Color("4474FF"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
