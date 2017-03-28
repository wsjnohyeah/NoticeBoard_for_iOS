//
//  PostTableViewCell.swift
//  NoticeBoard
//
//  Created by Ethan Hu on 25/03/2017.
//  Copyright © 2017 Ethan Hu. All rights reserved.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    var id:String!
    
    override func awakeFromNib() {
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
    }
    
    var post:Post? {
        didSet {
            updateUI()
        }
    }
    
    
    private func updateUI() {
        id = post?.id
        author?.text = post?.author
        title?.text = post?.title
        content?.text = post?.content
        createdTime?.text = post?.createdDate
        avatar?.image = nil
        
        avatar.kf.setImage(with: post?.avatar)
    }
    
}
