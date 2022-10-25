//
//  LoginViewController.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/21/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginPressed(_ sender: Any) {
//        setLoggingIn(true)
        var udacity = UdacityUserPass(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        OTMClient.login(udacity: udacity, completion: handleLoginResponse(success:error:))
                    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//      This func was previously named handleSessionResponse
    func handleLoginResponse(success: Bool, error: Error?) {
//        setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
//            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
