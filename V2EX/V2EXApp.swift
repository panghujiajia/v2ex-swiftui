//
//  V2EXApp.swift
//  V2EX
//
//  Created by pumbaa on 2023/4/10.
//

import SwiftUI
import V2exAPI

var v2ex = V2exAPI()

let api = V2exService()

@main
struct V2EXApp: App {
//    @StateObject var data = TabList()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
