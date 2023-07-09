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
        content: "",
        replies: 28,
        node_name: "apple",
        node_value: "apple",
        author: "zhangsan",
        avatar: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_mini.png?m=1657684598",
        last_reply_time: "1分钟前"
    )
    
    static let comment = (
        id: 1,
        content: "Testtt",
        contentRendered: "Testtt",
        created: 1272220126
    )
}

public struct Topic: Identifiable, Decodable {
    public let id: Int
    public let title: String
    public let content: String
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
}

class TabList: ObservableObject {
    @Published var tabs = [
        Tab(key: "HOT", value: "Top10", topic: []),
        Tab(key: "tech", value: "技术", topic: []),
        Tab(key: "creative", value: "创意", topic: []),
        Tab(key: "play", value: "好玩", topic: []),
        Tab(key: "apple", value: "Apple", topic: []),
        Tab(key: "jobs", value: "酷工作", topic: []),
        Tab(key: "deals", value: "交易", topic: []),
        Tab(key: "city", value: "城市", topic: []),
        Tab(key: "qna", value: "问与答", topic: []),
        Tab(key: "hot", value: "最热", topic: []),
        Tab(key: "all", value: "全部", topic: []),
        Tab(key: "r2", value: "R2", topic: []),
    ]
}
