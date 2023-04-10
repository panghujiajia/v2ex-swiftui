//
//  TabView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI

struct TabViewView: View {
    @State var selectedIndex = 0
    @Namespace var ScrollTabViewAnimation
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
                        }
                    )){
                        ForEach(0..<Tabs.count, id:\.self) { index in
                            ZStack{
                                ScrollView(.vertical, showsIndicators: false){
                                    VStack(spacing: 0){
                                        ForEach(0..<Topics.count, id:\.self) { index in
                                            VStack(spacing: 0){
                                                TopicItemView(topic: Topics[index])
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
    }
}

struct TabViewView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewView()
    }
}
