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
    
    var topic: V2Topic
    
    @State var commentList: [V2Comment]?
    
    let markdownString = """
      ## Try MarkdownUI

      **MarkdownUI** is a native Markdown renderer for SwiftUI
      compatible with the
      [GitHub Flavored Markdown Spec](https://github.github.com/gfm/).
      """
    
    var body: some View {
        VStack(spacing: 0){
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 0){
                    VStack(alignment: .leading){
                        TopicUserView(avatar: (topic.member?.avatarLarge)!, username: (topic.member?.username)!, lastReply: topic.lastModified!)
                        .padding(.top)
                        // 标题
                        Text(topic.title ?? "")
                            .font(.headline)
                            .foregroundColor(Color("333333"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.bottom)
                            .padding(.top, 6)
                        
                        Markdown(topic.content ?? "")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(Color("333333"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        // 详情
//                        Text(topic?.member?.username ?? "")
//                            .font(.body)
//                            .fontWeight(.regular)
//                            .foregroundColor(Color("333333"))
//                            .multilineTextAlignment(.leading)
//                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    
//                    Divider()
//                        .opacity(0.4)
//
//                    VStack(spacing: 0){
//                        Text("第一条附言：")
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                            .foregroundColor(Color("333333"))
//                            .multilineTextAlignment(.leading)
//                            .frame(maxWidth: .infinity, alignment: .topLeading)
//                            .padding(.bottom, 10)
//                        Text(topic?.member?.username ?? "")
//                            .font(.body)
//                            .fontWeight(.regular)
//                            .foregroundColor(Color("666666"))
//                            .multilineTextAlignment(.leading)
//                            .frame(maxWidth: .infinity, alignment: .topLeading)
//
//                        Divider()
//                            .opacity(0.4)
//                            .padding(.vertical)
//
//                        Text("第二条附言：")
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                            .foregroundColor(Color("333333"))
//                            .multilineTextAlignment(.leading)
//                            .frame(maxWidth: .infinity, alignment: .topLeading)
//                            .padding(.bottom, 10)
//                        Text(topic?.member?.username ?? "")
//                            .font(.body)
//                            .foregroundColor(Color("666666"))
//                            .multilineTextAlignment(.leading)
//                            .frame(maxWidth: .infinity, alignment: .topLeading)
//                    }
//                    .padding()
//                    .background(Color("F6F6F6"))
//                    .padding(.bottom)
                    
                    TopicInfoView(name: (topic.node?.title)!, replies: topic.replies!)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Rectangle()
                        .fill(Color("F6F6F6"))
                        .frame(width: UIScreen.main.bounds.width, height: 10)
                    
                    if (commentList != nil) {
                        VStack(spacing: 0){
                            ForEach(0 ..< commentList!.count, id: \.self) { index in
                                let comment = commentList![index]
                                
                                VStack(alignment: .leading){
                                    TopicUserView(avatar: (comment.member.avatarLarge)!, username: (comment.member.username)!, lastReply: comment.created)
                                    
                                    Markdown(comment.content)
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
            }
            .onAppear {
                loadComments(page: 1)
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
    
    
    func loadComments(page: Int) {
        Task {
            do {
                let res = try await v2ex.repliesAll(topicId: topic.id)
                commentList = res
            } catch {
            }
        }
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TopicDetailView(topic: PreviewData.topic,
                        commentList: [
                            PreviewData.comment,
                            PreviewData.comment,
                            PreviewData.comment
                        ])
    }
}
