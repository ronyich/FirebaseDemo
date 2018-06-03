//
//  ProfileViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 6/1/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBAction func logout(sender:UIButton) {
        // 下面這個判斷功能是在使用者登出Google帳號後，再次登入會需要重新驗證資料
        // providerData屬性用來判斷目前的登入方法，如果登入方法是Google，就呼叫GIDSignIn的signOut()方法讓使用者登出
        if let providerData = Auth.auth().currentUser?.providerData {
            let userInfo = providerData[0]
            switch userInfo.providerID {
            case "google.com": GIDSignIn.sharedInstance().signOut()
            default: break
            }
        }
        
        do{
            try Auth.auth().signOut()
        }catch{
            let alertController = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        //呈現歡迎視圖
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Profile"
        
        // 將使用者名稱顯示在MyProfile頁面
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
