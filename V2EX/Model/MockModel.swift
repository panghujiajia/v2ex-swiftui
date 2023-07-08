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
    static let member = V2Member(id: 79764,
                                 username: "ljsh093",
                                 url: "https://www.v2ex.com/u/ljsh093",
                                 avatarMini: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_mini.png?m=1657684598",
                                 avatarNormal: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_normal.png?m=1657684598",
                                 avatarLarge: "https://cdn.v2ex.com/avatar/ff10/6e6c/79764_large.png?m=1657684598",
                                 created: 1414903742,
                                 lastModified: 1657684598)

    static let topic = V2Topic(id: 1,
                               node: nil,
                               member: PreviewData.member,
                               lastReplyBy: "ljsh093",
                               lastTouched: 1658649862,
                               title: "万行原生 Javascript 该如何维护？",
                               url: "https://www.v2ex.com/t/868366",
                               created: 1658649797,
                               deleted: 0,
                               content: "想拆成 Typescript 模块化，有没有什么指路手册？",
                               contentRendered: "<p>想拆成 Typescript 模块化，有没有什么指路手册？</p>\n",
                               lastModified: 1658649797,
                               replies: 1111)

    static let comment = V2Comment(id: 1,
                                   content: "Testtt",
                                   contentRendered: "Testtt",
                                   created: 1272220126,
                                   member: member)
}

struct Topic: Identifiable {
    var id = UUID()
    var name: String
    var time: String
    var imageName: String
    var title: String
    var detail: String
    var tag: String
    var reply: Int
}

struct Tab: Identifiable {
    var id = UUID()
    var key: String
    var value: String
    var topic: [V2Topic]
}

var Tabs = [
    Tab(key: "0", value: "Top10", topic: []),
    Tab(key: "1", value: "全部", topic: []),
    Tab(key: "2", value: "创意", topic: []),
    Tab(key: "3", value: "技术", topic: []),
    Tab(key: "4", value: "问与答", topic: []),
    Tab(key: "5", value: "游戏", topic: []),
    Tab(key: "6", value: "交易", topic: []),
    Tab(key: "7", value: "创意", topic: []),
    Tab(key: "8", value: "技术", topic: []),
    Tab(key: "9", value: "问与答", topic: []),
    Tab(key: "10", value: "游戏", topic: []),
    Tab(key: "11", value: "交易", topic: []),
]

class TabList: ObservableObject {
    
    @Published var tabs = [
        Tab(key: "0", value: "Top10", topic: []),
        Tab(key: "1", value: "全部", topic: []),
        Tab(key: "2", value: "创意", topic: []),
        Tab(key: "3", value: "技术", topic: []),
        Tab(key: "4", value: "问与答", topic: []),
        Tab(key: "5", value: "游戏", topic: []),
        Tab(key: "6", value: "交易", topic: []),
//        Tab(key: "7", value: "创意", topic: []),
//        Tab(key: "8", value: "技术", topic: []),
//        Tab(key: "9", value: "问与答", topic: []),
//        Tab(key: "10", value: "游戏", topic: []),
//        Tab(key: "11", value: "交易", topic: []),
    ]
}

let Topics = [
    Topic(name: "George", time: "5分钟前", imageName: "1", title: "让你的员工为共同的目标工作，绝不要为你的人格魅力工作。", detail: "让你的员工为共同的目标工作，绝不要为你的人格魅力工作让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作", tag: "IOS", reply: 36),
    Topic(name: "Tom", time: "2分钟前", imageName: "2", title: "HarmonyOS的原子化理念是不是也导致应用开发的概念也需要做个转变？", detail: "HarmonyOS的原子化理念是不是也导致应用开发的概念也需要做个转变？HarmonyOS的原子化理念是不是也导致应用开发的概念也需要做个转变？", tag: "信息安全", reply: 75),
    Topic(name: "Jhon", time: "1小时前", imageName: "3", title: "最大的错误就是停在原地不动，就是不犯错误。关键在于总结、反思，错误还得犯，关键是不…", detail: "最大的错误就是停在原地不动，就是不犯错误。关键在于总结、反思，错误还得犯，关键是不…最大的错误就是停在原地不动，就是不犯错误。关键在于总结、反思，错误还得犯，关键是不…", tag: "问与答", reply: 8),
    Topic(name: "Jack", time: "28秒前", imageName: "4", title: "大家有什么便宜划算的云服务器推荐的?", detail: "大家有什么便宜划算的云服务器推荐的?大家有什么便宜划算的云服务器推荐的?", tag: "创意", reply: 15),
    Topic(name: "Branch", time: "30分钟前", imageName: "5", title: "AWS 和 AZURE 买的号，哪里能查看有沒有被开了 API。", detail: "AWS 和 AZURE 买的号，哪里能查看有沒有被开了 API。AWS 和 AZURE 买的号，哪里能查看有沒有被开了 API", tag: "技术", reply: 128),
]
