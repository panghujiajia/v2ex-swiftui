//
//  TopicItem.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI
import V2exAPI

struct TopicItemView: View {
    let topic: Topic
    
    var body: some View {
        NavigationLink{
            TopicDetailView(topic: topic)
        } label: {
            VStack(alignment: .leading) {
                TopicUserView(avatar: topic.avatar, author: topic.author, time: topic.last_reply_time, is_master: false, like_num: "")
                Text(topic.title)
                    .font(.headline)
                    .foregroundColor(Color("333333"))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, 6)
                TopicInfoView(topic: topic)
            }
            .padding()
        }
    }
}

struct TopicItemView_Previews: PreviewProvider {
    static var previews: some View {
        let topic = PreviewData.topic
        TopicItemView(topic: topic)
    }
}
