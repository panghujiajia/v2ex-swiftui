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
    
    @State var topics: [V2Topic] = []
    
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
                            }
                        }
                    )){
                        ForEach(0..<Tabs.count, id:\.self) { index in
                            ZStack{
                                ScrollView(.vertical, showsIndicators: false){
                                    VStack(spacing: 0){
                                        ForEach(Tabs[index].topic) { topic in
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
                                        print("触发刷新")
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
            }
        }
    }
    
    func loadData(index: Int) async {
        
        do {
            var topics: [V2Topic]?
            
            if index == 0 {
                
                topics = try await v2ex.hotTopics()
            } else if index == 1 {
                
                topics = try await v2ex.latestTopics()
            } else {
                topics = try await v2ex.topics(nodeName: "pwa", page: 1)?.result
            }
            
            Tabs[index].topic = topics ?? []
            
            self.topics = topics ?? []
            
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
