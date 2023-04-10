//
//  MockModel.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//


import SwiftUI
import Foundation

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
}

let Tabs = [
    Tab(key: "1", value: "全部"),
    Tab(key: "2", value: "创意"),
    Tab(key: "3", value: "技术"),
    Tab(key: "4", value: "问与答"),
    Tab(key: "5", value: "游戏"),
    Tab(key: "6", value: "交易"),
    Tab(key: "7", value: "创意"),
    Tab(key: "8", value: "技术"),
    Tab(key: "9", value: "问与答"),
    Tab(key: "10", value: "游戏"),
    Tab(key: "11", value: "交易"),
]

let Topics = [
    Topic(name: "George", time: "5分钟前", imageName: "1", title: "让你的员工为共同的目标工作，绝不要为你的人格魅力工作。", detail: "让你的员工为共同的目标工作，绝不要为你的人格魅力工作让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作让你的员工为共同的目标工作，绝不要为你的人格魅力工作。让你的员工为共同的目标工作，绝不要为你的人格魅力工作", tag: "IOS", reply: 36),
    Topic(name: "Tom", time: "2分钟前", imageName: "2", title: "HarmonyOS的原子化理念是不是也导致应用开发的概念也需要做个转变？", detail: "HarmonyOS的原子化理念是不是也导致应用开发的概念也需要做个转变？HarmonyOS的原子化理念是不是也导致应用开发的概念也需要做个转变？", tag: "信息安全", reply: 75),
    Topic(name: "Jhon", time: "1小时前", imageName: "3", title: "最大的错误就是停在原地不动，就是不犯错误。关键在于总结、反思，错误还得犯，关键是不…", detail: "最大的错误就是停在原地不动，就是不犯错误。关键在于总结、反思，错误还得犯，关键是不…最大的错误就是停在原地不动，就是不犯错误。关键在于总结、反思，错误还得犯，关键是不…", tag: "问与答", reply: 8),
    Topic(name: "Jack", time: "28秒前", imageName: "4", title: "大家有什么便宜划算的云服务器推荐的?", detail: "大家有什么便宜划算的云服务器推荐的?大家有什么便宜划算的云服务器推荐的?", tag: "创意", reply: 15),
    Topic(name: "Branch", time: "30分钟前", imageName: "5", title: "AWS 和 AZURE 买的号，哪里能查看有沒有被开了 API。", detail: "AWS 和 AZURE 买的号，哪里能查看有沒有被开了 API。AWS 和 AZURE 买的号，哪里能查看有沒有被开了 API", tag: "技术", reply: 128),
]
