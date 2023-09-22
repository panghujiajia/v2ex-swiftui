//
//  TopicDetailView.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI
import RichText
import MarkdownUI
import SwiftSoup

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
    
    @State private var page = 1
    
    @State private var webViewHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0){
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 0){
                    VStack(alignment: .leading){
                        TopicUserView(avatar: topic.avatar, author: topic.author, time: comment?.publish_time ?? topic.last_reply_time, is_master: false, like_num: "")
                            .padding(.top)
                        // 标题
                        Text(topic.title)
                            .font(.headline)
                            .foregroundColor(Color("333333"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.top, 6)
                        if comment != nil && !comment!.content.isEmpty {
                            HTMLView(htmlString: comment!.content, webViewHeight: $webViewHeight)
                                .frame(height: webViewHeight)
                            if webViewHeight == 0 {
                                Text("")
                                    .skeleton(with: true)
                                    .shape(type: .rectangle)
                                    .multiline(lines: 5, scales: [1: 0.6])
                                    .animation(type: .pulse())
                                    .frame(height: 100)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
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
                                        TopicUserView(avatar: reply.avatar, author: reply.author, time: reply.reply_time, is_master: reply.is_master, like_num: reply.like_num)
                                        Spacer()
                                        Text("#\(index + 1)")
                                            .font(.footnote)
                                            .foregroundColor(Color("999999"))
                                    }
                                    ReplyWebView(htmlString: reply.content)
                                        .padding(.leading, 40)
//                                        .font(.body)
//                                        .fontWeight(.regular)
//                                        .foregroundColor(Color("333333"))
//                                        .multilineTextAlignment(.leading)
//                                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                                        .padding(.top, 6)
//                                        .padding(.leading, 40)
//                                        .id(index)
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
                    await loadData()
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
    
    
    func loadData() async {
        let result: Comment? = await api.getTopicDetail(id: topic.id, p: self.page)
        
        if result != nil {
            // 初次加载
            if self.page == 1 {
                comment = result
            } else {
                var reply_list = comment!.reply_list
                reply_list! += result!.reply_list!
                comment!.reply_list = reply_list
            }
            // 有分页
            if comment!.page != self.page {
                self.page += 1
                await loadData()
            }
        }
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TopicDetailView(topic: PreviewData.topic, comment: PreviewData.comment)
    }
}
