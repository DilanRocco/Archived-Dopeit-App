//
//  StartQuizsViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 5/1/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit
import Network
class StartQuizsViewController: UIViewController {

    @IBOutlet weak var trueAndFalseView: UIButton!
    @IBOutlet weak var multipleChoiceView: UIButton!
    
    var seeNewPostsButton:NoConnectionHeader!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    var layoutGuide:UILayoutGuide!
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
             if #available(iOS 11.0, *) {
                 layoutGuide = view.safeAreaLayoutGuide
             } else {
                 // Fallback on earlier versions
                 layoutGuide = view.layoutMarginsGuide
             }
        trueAndFalseView.layer.cornerRadius = 10
        multipleChoiceView.layer.cornerRadius = 10
        
        seeNewPostsButton = NoConnectionHeader()
        view.addSubview(seeNewPostsButton)
        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 0)
        seeNewPostsButtonTopAnchor.isActive = true
        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        seeNewPostsButton.isHidden = true;
        // Do any additional setup after loading the view.
    }
   
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
     
    }
    let monitor = NWPathMonitor()
    override func viewWillAppear(_ animated: Bool) {
        seeNewPostsButton.isHidden = true
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
                 if path.status == .satisfied {
                    DispatchQueue.main.async {
                         self.seeNewPostsButton.isHidden = true
                         self.multipleChoiceView.isEnabled = true
                        self.trueAndFalseView.isEnabled = true 
                    }
                     print("We're connected!")
                 
                 } else {
                     print("No connection.")
                    DispatchQueue.main.async {
                    self.trueAndFalseView.isEnabled = false
                    self.multipleChoiceView.isEnabled = false
                    self.seeNewPostsButton.isHidden = false
                    }
                    
                  
                 }

                 print(path.isExpensive)
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
