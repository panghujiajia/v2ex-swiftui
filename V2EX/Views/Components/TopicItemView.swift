//
//  TopicItem.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI

struct TopicItemView: View {
    var topic: Topic
    
    var body: some View {
        NavigationLink{
            TopicDetailView(topic: topic)
        } label: {
            VStack(alignment: .leading) {
                NavigationLink{
                    Text("用户主页")
                } label: {
                    TopicUserView(topic: topic)
                }
                Text(topic.title)
                    .font(.headline)
                    .foregroundColor(Color("333333"))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, 6)
                TopicInfoView(topic: topic)
            }
            .navigationTitle("哈哈哈")
            .padding()
        }
    }
}

struct TopicItemView_Previews: PreviewProvider {
    static var previews: some View {
        TopicItemView(topic: Topics[0])
    }
}
