//
//  PostCell.swift
//  FirebaseDemo
//
//  Created by Ron Yi on 2018/6/1.
//  Copyright © 2018年 AppCoda. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var voteButton: LineButton! {
        didSet {
            voteButton.tintColor = .white
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            avatarImageView.clipsToBounds = true
        }
    }
    
    //用來讓cell知道他該回應哪一則貼文圖片
    private var currentPost: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post: Post) {
        
        //設定目前的貼文
        currentPost = post
        
        //設計Cell樣式
        selectionStyle = .none
        
        //設計姓名與喜愛數
        nameLabel.text = post.user
        voteButton.setTitle("\(post.votes)", for: .normal)
        voteButton.tintColor = .white
        
        //重設圖片視圖的圖片
        photoImageView.image = nil
        
        //先檢查快取內是否有圖片，有的話就立刻顯示圖片，沒有的話就到Firebase建立一個URLSession資料任務來下載貼文圖片
        if let image = CacheManager.shared.getFromCache(key: post.imageFileURL) as? UIImage {
            photoImageView.image = image
        }else{
            if let url = URL(string: post.imageFileURL) {
                
                let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    guard let imageData = data else {
                        return
                    }
                    OperationQueue.main.addOperation {
                        guard let image = UIImage(data: imageData) else { return }
                        
                        // 在下載任務的完成處理器加上簡單的確認，確保只顯示正確的圖片
                        if self.currentPost?.imageFileURL == post.imageFileURL{
                            self.photoImageView.image = image
                        }
                        
                        //加入下載圖片至快取
                        CacheManager.shared.cache(object: image, key: post.imageFileURL)
                    }
                })
                downloadTask.resume()
            }
        }
    }

}
