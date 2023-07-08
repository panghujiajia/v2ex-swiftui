//
//  TopicSkeleton.swift
//  V2EX
//
//  Created by pumbaa on 2023/7/7.
//

import SwiftUI
import SkeletonUI

struct TopicSkeleton: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<8, id: \.self) { index in
                VStack(alignment: .leading) {
                    HStack(spacing: 0){
                        Text("")
                            .skeleton(with: true)
                            .animation(type: .pulse())
                            .frame(width: 40, height: 40)
                            .cornerRadius(4)
                        VStack(alignment: .leading){
                            Text("")
                                .skeleton(with: true)
                                .shape(type: .rectangle)
                                .animation(type: .pulse())
                                .frame(width: 60, height: 16)
                            Text("")
                                .skeleton(with: true)
                                .shape(type: .rectangle)
                                .animation(type: .pulse())
                                .frame(width: 80, height: 14)
                        }
                        .frame(height: 34, alignment: .center)
                        .padding(.leading, 10)
                    }
                    .frame(height: 30)
                    Text("")
                        .skeleton(with: true)
                        .shape(type: .rectangle)
                        .multiline(lines: 2, scales: [1: 0.6])
                        .animation(type: .pulse())
                        .frame(width: .infinity, height: 40)
                        .padding(.top, 6)
                    HStack {
                        Text("")
                            .skeleton(with: true, size: CGSize(width: 80, height: 14))
                            .animation(type: .pulse())
                        Spacer()
                        Text("")
                            .skeleton(with: true, size: CGSize(width: 40, height: 14))
                            .animation(type: .pulse())
                    }
                }
                .padding()
                Divider()
                    .padding(.leading)
                    .padding(.vertical, 0)
                    .opacity(0.4)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct TopicSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        TopicSkeleton()
    }
}
