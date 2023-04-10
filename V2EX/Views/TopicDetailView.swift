//
//  TopicDetailView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI

struct TopicDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var topic: Topic
    
    var body: some View {
        VStack(spacing: 0){
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 0){
                    VStack(alignment: .leading){
                        NavigationLink{
                            Text("用户主页")
                        } label: {
                            TopicUserView(topic: topic)
                        }
                        .padding(.top)
                        // 标题
                        Text(topic.title)
                            .font(.headline)
                            .foregroundColor(Color("333333"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.bottom)
                            .padding(.top, 6)
                        // 详情
                        Text(topic.detail)
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(Color("333333"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    Divider()
                        .opacity(0.4)

                    VStack(spacing: 0){
                        Text("第一条附言：")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color("333333"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.bottom, 10)
                        Text(topic.detail)
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(Color("666666"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)

                        Divider()
                            .opacity(0.4)
                            .padding(.vertical)

                        Text("第二条附言：")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color("333333"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.bottom, 10)
                        Text(topic.detail)
                            .font(.body)
                            .foregroundColor(Color("666666"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding()
                    .background(Color("F6F6F6"))
                    .padding(.bottom)
                    
                    TopicInfoView(topic: topic)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Rectangle()
                        .fill(Color("F6F6F6"))
                        .frame(width: UIScreen.main.bounds.width, height: 10)
                    
                    VStack(spacing: 0){
                        ForEach(0..<Topics.count, id:\.self) { index in
                            VStack(alignment: .leading){
                                TopicUserView(topic: Topics[index])
                                Text(topic.detail)
                                    .font(.body)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color("333333"))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.top, 6)
                                    .padding(.leading, 40)
                            }
                            .padding()
                            Divider()
                                .opacity(0.4)
                                .padding(.leading)
                                .padding(.leading, 40)
                                
                                
                        }
                        
                    }
                }
            }
            
            ZStack{
                VStack{
                    Divider()
                        .opacity(0.4)
                    HStack{
                        Capsule()
                            .fill(Color("F6F6F6"))
                            .frame(width: 200,height: 40)
                            .overlay{
                                HStack{
                                    Image(systemName: "pencil.line")
                                    Text("说点什么..")
                                    Spacer()
                                }
                                .padding(.leading)
                            }
                    }
                }
            }
        }
        .navigationTitle("主题详情")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .accentColor(Color("333333"))
                })
            ,
            trailing:
                Button(action: {
                    
                }, label: {
                    Image(systemName: "ellipsis")
                        .accentColor(Color("333333"))
                })
        )
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//
//        }
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TopicDetailView(topic: Topics[0])
    }
}
