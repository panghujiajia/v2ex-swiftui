//
//  UserView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI

struct TopicUserView: View {
    var topic: Topic
    
    var body: some View {
        HStack(spacing: 0){
            Image(topic.imageName)
                .resizable()
                .frame(width: 30, height: 30)
                .cornerRadius(30)
            VStack(alignment: .leading){
                Text(topic.name)
                    .font(.subheadline)
                    .foregroundColor(Color("000000"))
                Text(topic.time)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            .frame(height: 34, alignment: .center)
            .padding(.leading, 10)
        }
        .frame(height: 30)
    }
}

struct TopicUserView_Previews: PreviewProvider {
    static var previews: some View {
        TopicUserView(topic: Topics[1])
    }
}
