//
//  AboutViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/13/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        if (self.view.frame.width == 320){
        erikTalk.font = erikTalk.font.withSize(15)
        dilanTalk.font = dilanTalk.font.withSize(15)
        named.font = named.font.withSize(17)
        namee.font = namee.font.withSize(17)
        }
        if (self.view.frame.width == 375){
            erikTalk.font = erikTalk.font.withSize(17)
 dilanTalk.font = dilanTalk.font.withSize(17)

            //named.font = named.font.withSize(16)
            //namee.font = namee.font.withSize(16)
        }
    }
    @IBOutlet weak var namee: UILabel!
    @IBOutlet weak var named: UILabel!
    @IBOutlet weak var erikTalk: UILabel!
    @IBOutlet weak var dilanTalk: UILabel!
    
    @IBOutlet weak var widthNameE: NSLayoutConstraint!
    @IBOutlet weak var widthNameD: NSLayoutConstraint!
    override func viewDidAppear(_ animated: Bool) {
        

       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lineUnderImage.constant = 190
        self.widthNameD.constant = 125
        self.widthNameE.constant = 83
        UIView.animate(withDuration: 0.75, animations: {
            self.view.layoutIfNeeded()
        })
    }
    @IBOutlet weak var lineUnderImage: NSLayoutConstraint!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
