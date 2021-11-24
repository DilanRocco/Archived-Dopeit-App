//
//  FAQViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/14/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
       
    
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var line: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "fromHomeScreen") == false{
                   okButton.isHidden = true
               }
         self.line.constant = 71
        UIView.animate(withDuration: 0.75, animations: {
                   self.view.layoutIfNeeded()
               })
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    @IBAction func okButtonClick(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC")
        resultViewController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = .push
        transition.subtype = .fromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.show(resultViewController, sender: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "fromHomeScreen")
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
