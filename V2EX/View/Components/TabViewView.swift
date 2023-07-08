//
//  TabView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI
import V2exAPI

struct TabViewView: View {
    @State var selectedIndex = 0
    @Namespace var ScrollTabViewAnimation
    
    @State var topics: [V2Topic]?
    
//    @EnvironmentObject var data: TabList
    
//    @StateObject var data = TabList()
    
    @ObservedObject var data = TabList()
    
    var body: some View {
        VStack{
            ScrollViewReader { ScrollViewProxy in
                VStack(spacing: 0){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(0..<Tabs.count, id: \.self) { index in
                                ZStack(alignment: .bottom){
                                    Text(Tabs[index].value)
                                        .fontWeight(selectedIndex == index ? .bold : .regular)
                                        .foregroundColor(selectedIndex == index ? Color("4474FF") : Color("999999"))
                                        .frame(maxHeight: .infinity)
                                        .padding(.horizontal, 10)
                                        .id(index)
                                    if selectedIndex == index {
                                        Capsule()
                                            .fill(Color("4474FF"))
                                            .matchedGeometryEffect(id: "ScrollTabViewAnimation", in: ScrollTabViewAnimation)
                                            .frame(width: 20,height: 3)
                                    } else {
                                        Capsule()
                                            .fill(Color("4474FF"))
                                            .matchedGeometryEffect(id: "ScrollTabViewAnimation", in: ScrollTabViewAnimation)
                                            .frame(width: 20,height: 3)
                                            .hidden()
                                    }
                                }
                                .frame(height: 40)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3,dampingFraction: 0.7)) {
                                        selectedIndex = index
                                        ScrollViewProxy.scrollTo(selectedIndex, anchor: .center)
                                    }
                                    Task {
                                        await self.loadData(index: index)
                                    }
                                }
                            }
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.bottom, 5)
                    
                    Divider()
                    
                    TabView(selection: .init(
                        get: {
                            selectedIndex
                        },
                        set: { newTab in
                            withAnimation(.spring(response: 0.3,dampingFraction: 0.7)) {
                                selectedIndex = newTab
                                ScrollViewProxy.scrollTo(selectedIndex, anchor: .center)
                            }
                            Task {
                                await self.loadData(index: newTab)
                                
                                if newTab + 1 <= Tabs.count && self.data.tabs[newTab + 1].topic.isEmpty {
                                    await self.loadData(index: newTab + 1)
                                }
                            }
                        }
                    )){
                        ForEach(0..<data.tabs.count, id: \.self) { index in
                            ZStack(){
                                if data.tabs[index].topic.isEmpty {
                                    TopicSkeleton()
                                } else {
                                    ScrollView(.vertical, showsIndicators: false){
                                        VStack(spacing: 0){
                                            ForEach(data.tabs[index].topic) { topic in
                                                VStack(spacing: 0){
                                                    TopicItemView(topic: topic)
                                                    Divider()
                                                        .padding(.leading)
                                                        .padding(.vertical, 0)
                                                        .opacity(0.4)
                                                }
                                            }
                                        }
                                        .refreshable {
                                            Task {
                                                self.data.tabs[selectedIndex].topic = []
                                                await self.loadData(index: selectedIndex)
                                                
                                                if selectedIndex + 1 <= Tabs.count && self.data.tabs[selectedIndex + 1].topic.isEmpty {
                                                    await self.loadData(index: selectedIndex + 1)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            Task {
                await self.loadData(index: 0)
                
                if self.data.tabs[1].topic.isEmpty {
                    await self.loadData(index: 1)
                }
            }
        }
    }
    
    func loadData(index: Int) async {
        
        do {
//            var topics: [V2Topic]?
            
            if index == 0 {
                
                topics = try await v2ex.hotTopics()
            } else if index == 1 {
                
                topics = try await v2ex.latestTopics()
            } else {
                topics = try await v2ex.topics(nodeName: "pwa", page: 1)?.result
                
//                print(topics)
            }
            
            self.data.tabs[index].topic = topics ?? []
            
//            self.topics = topics ?? []
            
        } catch {
            print("error")
        }
    }
}

struct TabViewView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView()
    }
}
