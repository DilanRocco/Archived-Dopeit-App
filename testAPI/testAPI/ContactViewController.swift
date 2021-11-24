//
//  ContactViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/22/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var line: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        self.line.constant = 131
        UIView.animate(withDuration: 0.75, animations: {
            self.view.layoutIfNeeded()
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        
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
