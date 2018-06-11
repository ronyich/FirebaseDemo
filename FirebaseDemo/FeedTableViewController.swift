//
//  FeedTableViewController.swift
//  FirebaseDemo
//
//  Created by Ron Yi on 2018/6/1.
//  Copyright © 2018年 AppCoda. All rights reserved.
//
import Foundation
import UIKit
import ImagePicker
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FeedTableViewController: UITableViewController {
    
    // 存放所有目前的貼文 (以反向時間排序)
    var postfeed: [Post] = []
    // 這個屬性標示App是否從Firebase下載貼文 (實作無限滾動時會用到)
    // fileprivate作為限制只能在自己定義的原始檔中的實體(entity)所存取
    // 只能在FeedTableViewController.swift中的實體所存取
    fileprivate var isLoadingPost = false
    
    
    // 相機按鈕
    @IBAction func openCamera (_ sender: Any) {
        let imagePickerController = ImagePickerController()
        // 定義一個委派，來執行圖片從照片庫中被選取，或使用相機來照相，並一次只能選擇一張
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1

        present(imagePickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設置下拉式更新
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.black
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(loadRecentPost), for: UIControlEvents.valueChanged)

        //消除tableView多餘的格線
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //載入最新的貼文
        loadRecentPost()
        
        /*
        PostService.shared.getRecentPosts(limit: 3) { (newPost) in
            newPost.forEach({ (post) in
                print("------")
                print("Post ID:\(post.postID)")
                print("Image URL:\(post.imageFileURL)")
                print("User:\(post.user)")
                print("Votes:\(post.votes)")
                print("Timestamp:\(post.timestamp)")
                print("------")
            })
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 處理貼文下載與顯示
    @objc fileprivate func loadRecentPost() {
        
        isLoadingPost = true
        
        PostService.shared.getRecentPosts(start: postfeed.first?.timestamp, limit: 10) { (newPosts) in
            if newPosts.count > 0 {
                //加入貼文陣列到陣列的開始處
                self.postfeed.insert(contentsOf: newPosts, at: 0)
            }
            self.isLoadingPost = false
            
            if let _ = self.refreshControl?.isRefreshing {
                //為了讓動畫效果更佳，在結束更新之前延遲0.5秒
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.refreshControl?.endRefreshing()
                    self.displayNewPosts(newPosts: newPosts)
                })
            }else{
                self.displayNewPosts(newPosts: newPosts)
            }
        }
    }
    
    private func displayNewPosts(newPosts posts: [Post]) {
        //確認我們取得新的貼文來顯示
        guard posts.count > 0 else {
            return
        }
        
        //將他們插入表格視圖中來顯示貼文
        var indexPaths: [IndexPath] = []
        self.tableView.beginUpdates()
        for num in 0...(posts.count - 1) {
            let indexPath = IndexPath(row: num, section: 0)
            indexPaths.append(indexPath)
        }
        self.tableView.insertRows(at: indexPaths, with: .fade)
        self.tableView.endUpdates()
    }

    // MARK: - Table view data source
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeedTableViewController: ImagePickerDelegate {
    
    // 使用者按下相片列(stack)按鈕時會呼叫
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        // 這邊不需要實作，維持空白
    }
    
    // 使用者按下Done按鈕時會呼叫
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        // 取得第一張照片
        guard let image = images.first else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        //上傳圖片至雲端
        PostService.shared.uploadImage(image: image) {
            self.dismiss(animated: true, completion: nil)
            self.loadRecentPost()
        }
    }
    
    // 使用者按下Cancel按鈕時會呼叫
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

// 覆寫這些方法所預設的實作 (跳轉到PostCell畫面)
extension FeedTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
        let currentPost = postfeed[indexPath.row]
        cell.configure(post: currentPost)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postfeed.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //在使用者滑到最後兩列時觸發這個載入
        guard !isLoadingPost, postfeed.count - indexPath.row == 2 else {
            return
        }
        
        isLoadingPost = true
        
        guard let lastPostTimestamp = postfeed.last?.timestamp else {
            isLoadingPost = false
            return
        }
        
        PostService.shared.getOldPosts(start: lastPostTimestamp, limit: 3) { (newPosts) in
            
            //加上新的貼文至目前陣列與表格視圖
            var indexPaths:[IndexPath] = []
            self.tableView.beginUpdates()
            
            for newPost in newPosts {
                self.postfeed.append(newPost)
                let indexPath = IndexPath(row: self.postfeed.count - 1, section: 0)
                indexPaths.append(indexPath)
            }
            
            self.tableView.insertRows(at: indexPaths, with: .fade)
            self.tableView.endUpdates()
            
            self.isLoadingPost = false
        }
    }
    
}
