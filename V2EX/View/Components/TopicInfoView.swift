//
//  TopicInfoView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI

struct TopicInfoView: View {
    let topic: Topic
    
    var body: some View {
        HStack {
            NavigationLink{
                Text("节点页面")
            } label: {
                Text("# \(topic.node_name)")
                    .font(.footnote)
                    .padding(.horizontal, 15.0)
                    .padding(.vertical, 6.0)
                    .background(Color("F6F6F6"))
                    .foregroundColor(Color("000000"))
                    .cornerRadius(20)
            }
            
            Spacer()
            if topic.replies > 0 {
                Text("\(topic.replies)条回复")
                    .font(.footnote)
                    .foregroundColor(Color("999999"))
            }
        }
    }
}

struct TopicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let topic = PreviewData.topic
        TopicInfoView(topic: topic)
    }
}
