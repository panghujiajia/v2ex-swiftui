//
//  Html.swift
//  V2EX
//
//  Created by pumbaa on 2023/7/19.
//

import Foundation


func getHtmlStr(content: String) -> String{
    return
            """
            \(htmlStrStart)
            \(content)
            \(htmlStrEnd)
            """
}

let htmlStrStart = """
            <!DOCTYPE html>
                <html lang="en">
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
                        <title>Document</title>
                    </head>
                    <style tyle="text/css">
                        * {margin: 0; padding: 0;font-family: "Helvetica Neue", "Luxi Sans", "Segoe UI", "Hiragino Sans GB", "Microsoft Yahei", sans-serif, "Apple Logo";}
                        img {
                            max-width: 100%;
                            height: auto;
                        }
                        .embedded_image {
                            max-width: 100%;
                            image-orientation: from-image;
                            vertical-align: bottom;
                        }
                        a {
                            color: #778087;
                        }
                        .markdown_body>:first-child {
                            margin-top: 0!important
                        }

                        .markdown_body>:last-child {
                            margin-bottom: 0!important
                        }
            
                        .markdown_body p {
                            margin: 14px 0;
                            color: #000;
                        }

                        .markdown_body img {
                            max-width: 100%
                        }
                    </style>
                    <body>
                        <div>
            """

let htmlStrEnd = """
                        </div>
                    </body>
                </html>
            """