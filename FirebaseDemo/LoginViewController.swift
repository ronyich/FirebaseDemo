//
//  LogonViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 14/12/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let user = Auth.auth().currentUser

    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // 登入實作
    @IBAction func login(sender: UIButton) {
        // 輸入驗證
        guard let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                let alertController = UIAlertController(title: "Login Error", message: "Both fields must not be blank", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                return
        }
        // 呼叫Firebase APIs執行登入
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            // Email認證
            guard let currentUser = Auth.auth().currentUser, currentUser.isEmailVerified else {
                let alertController = UIAlertController(title: "Login Error", message: "You haven't confirmed your email address yet. We sent you a confirmation email when you sign up. Please click the verification link in that email. If you need us to send the confirmation email again, please tap Resend Email.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            // 解除鍵盤
            self.view.endEditing(true)
            
            // 呈現主視圖
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                // 把viewController設成根VC
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.title = "Log In"
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = ""
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
