//
//  ResetPasswordViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 5/1/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    
    @IBAction func resetPassword(sender:UIButton) {
        guard let emailAddress = emailTextField.text, emailAddress != "" else {
            let alertController = UIAlertController(title: "Input Error", message: "Please provite your email address for password reset.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        // 傳送重設密碼的email
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            let title = (error == nil) ? "Password reset Follow-up" : "Password reset Error"
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password." : error?.localizedDescription
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                if error == nil {
                    // 解除鍵盤
                    self.view.endEditing(true)
                    // 返回登入畫面
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
            })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forgot Password"
        emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
