//
//  TabView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI
import SwiftSoup
import V2exAPI

struct TabViewView: View {
    @State var selectedIndex = 0
    @Namespace var ScrollTabViewAnimation
    @State var loading: Bool = true
    
//    @EnvironmentObject var data: TabList
    
//    @StateObject var data = TabList()
    
    @ObservedObject var data = TabList()
    
    var body: some View {
        VStack{
            ScrollViewReader { ScrollViewProxy in
                VStack(spacing: 0){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(Array(data.tabs.enumerated()), id: \.offset) { index, tab in
                                ZStack(alignment: .bottom){
                                    Text(tab.value)
                                        .fontWeight(selectedIndex == index ? .bold : .regular)
                                        .foregroundColor(selectedIndex == index ? Color("4474FF") : Color("999999"))
                                        .frame(maxHeight: .infinity)
                                        .padding(.horizontal, 10)
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
                                    if selectedIndex != index {
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
                                
//                                if newTab + 1 <= data.tabs.count && self.data.tabs[newTab + 1].topic!.isEmpty {
//                                    await self.loadData(index: newTab + 1)
//                                }
                            }
                        }
                    )){
                        ForEach(Array(data.tabs.enumerated()), id: \.offset) { index, tab in
                            ZStack(){
                                if loading {
                                    TopicSkeleton()
                                } else if tab.topic!.isEmpty {
                                    Text("暂无数据")
                                        .foregroundColor(Color("999999"))
                                } else {
                                    ScrollView(.vertical, showsIndicators: false){
                                        VStack(spacing: 0){
                                            ForEach(Array(tab.topic!.enumerated()), id: \.offset) { i, topic in
                                                VStack(spacing: 0){
                                                    TopicItemView(topic: topic)
                                                    Divider()
                                                        .padding(.leading)
                                                        .padding(.vertical, 0)
                                                        .opacity(0.4)
                                                }
                                            }
                                        }
                                    }
                                    .refreshable {
                                        Task {
                                            await self.loadData(index: selectedIndex, refresh: true)
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
//                if self.data.tabs[1].topic!.isEmpty {
//                    await self.loadData(index: 1)
//                }
            }
        }
    }
    
    func loadData(index: Int, refresh: Bool? = false) async {
        loading = true
        let tab = data.tabs[index].key
        let lastRequestTime = data.tabs[index].lastRequestTime
        
        // 刷新或者初次加载或者距离上次加载超过 gap 分钟才去请求数据
        if refresh! || lastRequestTime == 0 || isDifferenceFifteenMinutes(timestamp: TimeInterval(lastRequestTime), gap: 10) {
            print("加载中...")
            var topics: [Topic]?
            topics = await api.getTabTopics(tab: tab)
            self.data.tabs[index].topic = topics ?? []
            self.data.tabs[index].lastRequestTime = Int(Date().timeIntervalSince1970)
        }
        loading = false
    }
}

struct TabViewView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView()
    }
}
