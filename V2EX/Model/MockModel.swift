//
//  MockModel.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//


import SwiftUI
import Foundation



struct PreviewData {
    static let topic = Topic(
        id: 957317,
        title: "别人移动我的自行车，把别人的车刮了，该赔偿吗？",
        replies: 5,
        node_name: "Project Babel",
        node_value: "babel",
        author: "Livid",
        avatar: "https://cdn.v2ex.com/avatar/c4ca/4238/1_xlarge.png?m=1687853010",
        last_reply_time: "1分钟前"
    )
    
    static let comment = Comment(
        page: 1,
        content: "",
        publish_time: "1分钟前",
        subtle_list: [PreviewData.subtle_list],
        reply_list: [PreviewData.reply_list]
    )
    
    static let subtle_list = Subtle(
        subtle_time: "1分钟前",
        subtle_content: "附言内容"
    )
    
    static let reply_list = Reply(
        author: "zhangsan",
        avatar: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_mini.png?m=1657684598",
        is_master: false,
        reply_time: "1分钟前",
        like_num: "5",
        content: "评论内容"
    )
}

public struct Topic: Identifiable, Decodable {
    public let id: Int
    public let title: String
    public let replies: Int
    public let node_name: String
    public let node_value: String
    public let author: String
    public let avatar: String
    public let last_reply_time: String
}

struct Comment: Decodable {
    public let page: Int
    public let content: String
    public let publish_time: String
    public let subtle_list: [Subtle]?
    public var reply_list: [Reply]?
}

struct Reply: Decodable {
    public let author: String
    public let avatar: String
    public let is_master: Bool
    public let reply_time: String
    public let like_num: String
    public let content: String
}

struct Subtle: Decodable {
    public let subtle_time: String
    public let subtle_content: String
}

struct Tab: Identifiable {
    var id = UUID()
    var key: String
    var value: String
    var topic: [Topic]?
    var lastRequestTime: Int
}

class TabList: ObservableObject {
    @Published var tabs = [
        Tab(key: "hot", value: "最热", topic: [], lastRequestTime: 0),
        Tab(key: "tech", value: "技术", topic: [], lastRequestTime: 0),
        Tab(key: "creative", value: "创意", topic: [], lastRequestTime: 0),
        Tab(key: "play", value: "好玩", topic: [], lastRequestTime: 0),
        Tab(key: "apple", value: "Apple", topic: [], lastRequestTime: 0),
        Tab(key: "jobs", value: "酷工作", topic: [], lastRequestTime: 0),
        Tab(key: "deals", value: "交易", topic: [], lastRequestTime: 0),
        Tab(key: "city", value: "城市", topic: [], lastRequestTime: 0),
        Tab(key: "qna", value: "问与答", topic: [], lastRequestTime: 0),
        Tab(key: "all", value: "全部", topic: [], lastRequestTime: 0),
        Tab(key: "r2", value: "R2", topic: [], lastRequestTime: 0),
    ]
}
