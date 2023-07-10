//
//  MockModel.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//


import SwiftUI
import Foundation
import V2exAPI



struct PreviewData {
    static let topic = Topic(
        id: 1,
        title: "万行原生 Javascript 该如何维护？",
        replies: 28,
        node_name: "apple",
        node_value: "apple",
        author: "zhangsan",
        avatar: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_mini.png?m=1657684598",
        last_reply_time: "1分钟前"
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

struct Comment: Identifiable {
    let id: Int
    let content: String
    let created: Int
    let contentRendered: String
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
        Tab(key: "HOT", value: "Top10", topic: [], lastRequestTime: 0),
        Tab(key: "tech", value: "技术", topic: [], lastRequestTime: 0),
        Tab(key: "creative", value: "创意", topic: [], lastRequestTime: 0),
        Tab(key: "play", value: "好玩", topic: [], lastRequestTime: 0),
        Tab(key: "apple", value: "Apple", topic: [], lastRequestTime: 0),
        Tab(key: "jobs", value: "酷工作", topic: [], lastRequestTime: 0),
        Tab(key: "deals", value: "交易", topic: [], lastRequestTime: 0),
        Tab(key: "city", value: "城市", topic: [], lastRequestTime: 0),
        Tab(key: "qna", value: "问与答", topic: [], lastRequestTime: 0),
        Tab(key: "hot", value: "最热", topic: [], lastRequestTime: 0),
        Tab(key: "all", value: "全部", topic: [], lastRequestTime: 0),
        Tab(key: "r2", value: "R2", topic: [], lastRequestTime: 0),
    ]
}
