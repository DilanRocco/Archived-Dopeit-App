//
//  ResetPasswordViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/20/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import FirebaseAuth
class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    let blueColors = UIColor(red: 26.0/255.0, green: 149.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    let whiteColor = UIColor(red: 222.0/255.0, green: 226.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var buttonEmail: UIButton!

    var bottomLine = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        emailTextField.delegate = self
       
        
        //design belowww
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           self.navigationController?.navigationBar.shadowImage = UIImage()
           self.navigationController?.navigationBar.isTranslucent = true
           addBackButton()
           bottomLine.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1.0)
           bottomLine.backgroundColor = blueColors.cgColor
           emailTextField.borderStyle = UITextField.BorderStyle.none
           emailTextField.layer.addSublayer(bottomLine)
          
           emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: self.blueColors])
        buttonEmail.layer.shadowColor = UIColor.gray.cgColor
        buttonEmail.layer.shadowOpacity = 1
        buttonEmail.layer.shadowOffset =  CGSize(width:1,height: 1)
        buttonEmail.layer.shadowRadius = 1
        buttonEmail.layer.shadowPath = UIBezierPath(rect: buttonEmail.bounds).cgPath
        buttonEmail.layer.shouldRasterize = true
        buttonEmail.layer.rasterizationScale = UIScreen.main.scale
        buttonEmail.layer.cornerRadius = 2
        buttonEmail.backgroundColor = whiteColor
        
        
        
        
        // Do any additional setup after loading the view.
       
        
    }

    func addBackButton() {
       
        let backButton = UIButton(type: .custom)
              backButton.setImage(UIImage(named: "arrow.png"), for: .normal) // Image can be downloaded from here below link
              backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
              backButton.tintColor = blueColors
        
              print("force")

              backButton.semanticContentAttribute = .forceRightToLeft
              backButton.translatesAutoresizingMaskIntoConstraints = false
              backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)

              
              let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
              view.bounds = view.bounds.offsetBy(dx: -20, dy: -20)
              view.addSubview(backButton)
              let backButtonView = UIBarButtonItem(customView: view)
            navigationItem.leftBarButtonItem = backButtonView
        
        
    }
    @objc func backAction(_ sender:UIButton) -> Void {
       self.navigationController?.popViewController(animated: true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomLine.backgroundColor = whiteColor.cgColor
        self.emailTextField.layer.addSublayer(bottomLine)
        bottomLine.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 2.0)
        emailTextField.placeholder = ""
        emailTextField.textColor = whiteColor
        
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        bottomLine.backgroundColor = blueColors.cgColor
        self.emailTextField.layer.addSublayer(bottomLine)
        bottomLine.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
        attributes: [NSAttributedString.Key.foregroundColor: blueColors])
        emailTextField.textColor = blueColors
    }
    
    
    
    @IBAction func resetButton(_ sender: Any) {
        guard let email = emailTextField.text, email != "" else{
            self.errorLabel.text = "Please enter an email address for password reset."
            return
        }
        resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            self.errorLabel.text = "A password reset rmail has been sent. Please check your inbox and follow the instructions."
        }) { (errorMessage) in
            self.errorLabel.text = "Error sending the email."
        }
        
    }
    
    func resetPassword(email: String, onSuccess: @escaping()-> Void, onError: @escaping(_ errorMessage: String)->Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
                onSuccess()
            }else{
                onError(error!.localizedDescription)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
