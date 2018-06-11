//
//  Post.swift
//  FirebaseDemo
//
//  Created by Ron Yi on 2018/6/6.
//  Copyright © 2018年 AppCoda. All rights reserved.
//

import Foundation

struct Post {
    
    var postID: String
    var imageFileURL: String
    var user: String
    var votes: Int
    var timestamp: Int
    
    // Firebase Keys
    enum PostInfoKey {
        static let imageFileURL = "imageFileURL"
        static let user = "user"
        static let votes = "votes"
        static let timestamp = "timestamp"
    }
    
    // 初始化
    init(postID: String, imageFileURL: String, user: String, votes: Int, timestamp: Int = Int(NSDate().timeIntervalSince1970 * 1000)) {
        self.postID = postID
        self.imageFileURL = imageFileURL
        self.user = user
        self.votes = votes
        self.timestamp = timestamp
    }
    
    init?(postID: String, postInfo: [String: Any]) {
        guard let imageFileURL = postInfo[PostInfoKey.imageFileURL] as? String,
        let user = postInfo[PostInfoKey.user] as? String,
        let votes = postInfo[PostInfoKey.votes] as? Int,
            let timestamp = postInfo[PostInfoKey.timestamp] as? Int else {
                return nil
        }
        self = Post(postID: postID, imageFileURL: imageFileURL, user: user, votes: votes, timestamp: timestamp)
    }
    
}







