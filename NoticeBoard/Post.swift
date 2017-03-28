//
//  Post.swift
//  NoticeBoard
//
//  Created by Ethan Hu on 25/03/2017.
//  Copyright © 2017 Ethan Hu. All rights reserved.
//

import Foundation

class Post {
    var id:String
    var title:String
    var content:String
    var createdDate:String
    var author:String
    var avatar:URL
    
    init(id:String, title:String, content:String, createdDate:String, author:String, avatar:String) {
        self.id = id
        self.title = title
        self.content = content
        self.createdDate = createdDate
        self.author = author
        self.avatar = URL(string: avatar) ?? URL(string: "https://ww4.sinaimg.cn/small/006dLiLIgw1fawexxhv3hj31hc1hcdzh.jpg")!
    }
    
}
