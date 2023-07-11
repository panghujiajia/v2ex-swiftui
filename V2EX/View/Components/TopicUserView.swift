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
    let avatar: String
    let author: String
    let time: String
    let is_master: Bool
    let like_num: String?
    
    var body: some View {
        NavigationLink{
            Text("用户主页")
        } label: {
            HStack(spacing: 0){
                KFImage.url(URL(string: avatar))
                    .placeholder{
                        Image("1")
                    }
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
                VStack(alignment: .leading, spacing: 0){
                    HStack(alignment: .center) {
                        Text(author)
                            .font(.subheadline)
                            .foregroundColor(Color("000000"))
                        if is_master {
                            Text("OP")
                                .font(.caption2)
                                .foregroundColor(Color("4474FF"))
                                .padding(.horizontal, 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .stroke(Color("4474FF"), lineWidth: 1)
                                )
                        }
                        if !like_num!.isEmpty {
                            HStack(spacing: 0) {
                                Image("heart")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                Text(like_num)
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .padding(.leading, 4)
                            }
                            .padding(.leading, 6)
                        }
                    }
                    Text(time)
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
        TopicUserView(avatar: topic.avatar, author: topic.author, time: topic.last_reply_time, is_master: false, like_num: "3")
    }
}
