//
//  TopicInfoView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI
import V2exAPI

struct TopicInfoView: View {
    var name: String
    var replies: Int
    
    var body: some View {
        HStack {
            NavigationLink{
                Text("节点页面")
            } label: {
                Text("# \(name)")
                    .font(.footnote)
                    .padding(.horizontal, 15.0)
                    .padding(.vertical, 6.0)
                    .background(Color("F6F6F6"))
                    .foregroundColor(Color("000000"))
                    .cornerRadius(20)
            }
            
            Spacer()
            if replies > 0 {
                Text("\(replies)条回复")
                    .font(.footnote)
                    .foregroundColor(Color("999999"))
            }
        }
    }
}

struct TopicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let name = "ljsh093"
        let replies = 0
        TopicInfoView(name: name, replies: replies)
    }
}
