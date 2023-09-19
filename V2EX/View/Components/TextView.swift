//
//  TextView.swift
//  V2EX
//
//  Created by pumbaa on 2023/9/14.
//

import SwiftUI

//struct TextView: View {
//    let htmlString: String
//
//    var body: some View {
//        Text(" ") + Text(htmlString.htmlToAttributedString() ?? "")
//            .font(.body)
//            .lineLimit(nil)
//    }
//}
//
//extension String {
//    func htmlToAttributedString() -> NSAttributedString? {
//        guard let data = self.data(using: .utf8) else {
//            return nil
//        }
//
//        do {
//            return try NSAttributedString(
//                data: data,
//                options: [.documentType: NSAttributedString.DocumentType.html],
//                documentAttributes: nil
//            )
//        } catch {
//            return nil
//        }
//    }
//}
