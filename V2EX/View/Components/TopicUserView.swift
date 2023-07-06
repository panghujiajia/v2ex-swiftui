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
    var avatar: String
    var username: String
    var lastReply: Int
    
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
                VStack(alignment: .leading){
                    Text(username)
                        .font(.subheadline)
                        .foregroundColor(Color("000000"))
                    Text("\(Date(timeIntervalSince1970: TimeInterval(lastReply)).fromNow())")
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

extension Date {
    func fromNow() -> String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first!)
        
        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: self, relativeTo: Date.now)
        
        return relativeDate
    }
}

struct TopicUserView_Previews: PreviewProvider {
    static var previews: some View {
        let avatar = "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_large.png?m=1657684598"
        let username = "ljsh093"
        let lastReply = 1657684598
        TopicUserView(avatar: avatar, username: username, lastReply: lastReply)
    }
}
