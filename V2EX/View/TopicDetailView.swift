//
//  TopicDetailView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI
import MarkdownUI
import V2exAPI

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct TopicDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let topic: Topic
    
    @State var comment: Comment?
    
    var body: some View {
        VStack(spacing: 0){
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 0){
                    VStack(alignment: .leading){
                        TopicUserView(avatar: topic.avatar, author: topic.author, time: topic.last_reply_time, is_master: false)
                            .padding(.top)
                        // 标题
                        Text(topic.title)
                            .font(.headline)
                            .foregroundColor(Color("333333"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.bottom)
                            .padding(.top, 6)
                        if comment != nil {
                            Markdown(comment!.content)
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(Color("333333"))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        } else {
                            Text("")
                                .skeleton(with: true)
                                .shape(type: .rectangle)
                                .multiline(lines: 5, scales: [1: 0.6])
                                .animation(type: .pulse())
                                .frame(height: 100)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    
                    if comment != nil && comment!.subtle_list != nil {
                        Divider()
                            .opacity(0.4)
                        VStack(spacing: 0){
                            ForEach(Array(comment!.subtle_list!.enumerated()), id: \.offset) { index, subtle in
                                Text("第 \(index + 1) 条附言 · \(subtle.subtle_time)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("333333"))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.bottom, 10)
                                Text(subtle.subtle_content)
                                    .font(.body)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color("666666"))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                if (index + 1) < comment!.subtle_list!.count {
                                    Divider()
                                        .opacity(0.4)
                                        .padding(.vertical)
                                }
                            }
                        }
                        .padding()
                        .background(Color("F6F6F6"))
                        .padding(.bottom)
                    }
                    
                    TopicInfoView(topic: topic)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Rectangle()
                        .fill(Color("F6F6F6"))
                        .frame(width: UIScreen.main.bounds.width, height: 10)
                    
                    if comment != nil && comment!.reply_list != nil {
                        VStack(spacing: 0){
                            ForEach(Array(comment!.reply_list!.enumerated()), id: \.offset) { index, reply in
                                VStack(alignment: .leading){
                                    HStack(alignment: .top) {
                                        TopicUserView(avatar: reply.avatar, author: reply.author, time: reply.reply_time, is_master: reply.is_master)
                                        Spacer()
                                        Text("\(index + 1)楼")
                                            .font(.footnote)
                                            .foregroundColor(Color("999999"))
                                    }
                                    Markdown(reply.content)
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
                    } else {
                        TopicSkeleton()
                    }
                }
            }
            .onAppear {
                Task {
                    await loadData(page: 1)
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
    }
    
    
    func loadData(page: Int) async {
        comment = await api.getTopicDetail(id: topic.id, p: page)
        print(comment!)
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TopicDetailView(topic: PreviewData.topic, comment: PreviewData.comment)
    }
}
