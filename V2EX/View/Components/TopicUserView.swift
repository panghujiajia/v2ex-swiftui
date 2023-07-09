//
//  UserView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI
import V2exAPI
import Kingfisher

struct TopicUserView: View {
    let topic: Topic
    
    var body: some View {
        NavigationLink{
            Text("用户主页")
        } label: {
            HStack(spacing: 0){
                KFImage.url(URL(string: topic.avatar))
                    .placeholder{
                        Image("1")
                    }
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
                VStack(alignment: .leading){
                    Text(topic.author)
                        .font(.subheadline)
                        .foregroundColor(Color("000000"))
                    Text(topic.last_reply_time)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
                .frame(height: 34, alignment: .center)
                .padding(.leading, 10)
            }
            .frame(height: 30)
        }
    }
}

struct TopicUserView_Previews: PreviewProvider {
    static var previews: some View {
        let topic = PreviewData.topic
        TopicUserView(topic: topic)
    }
}
