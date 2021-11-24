//
//  EndQuizViewController.swift
//  testAPI
//
//  Created by Dilan Piscatello on 4/13/20.
//  Copyright © 2020 Dilan Piscatello. All rights reserved.
//

import UIKit

class EndQuizViewController: UIViewController {

    @IBOutlet weak var labelExplain: UILabel!
    
    @IBAction func doneButton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "endTrivia")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController;             resultViewController.modalPresentationStyle = .fullScreen
            
              self.show(resultViewController, sender:nil)
        
         //performSegue(withIdentifier: "back", sender: self)
        
    }
    @IBOutlet weak var doneButtonLabel: UIButton!
    
    @IBOutlet weak var PointsThisRoundLabel: UILabel!
    
    @IBOutlet weak var totalPointsLabel: UILabel!
    var index = 0
    var index2 = 0
    var currentPoints = 0
    var totalPoints = 0
    var clock = Timer()
    var clock2 = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        if ((self.view.frame.width == 320) || (self.view.frame.width == 375)){
            labelExplain.font = labelExplain.font.withSize(20)
        }
        self.navigationController?.navigationBar.isHidden = true
       doneButtonLabel.layer.cornerRadius = 30
       doneButtonLabel.layer.masksToBounds = true
       self.tabBarController?.tabBar.layer.isHidden = true
        print(UserDefaults.standard.integer(forKey: "x"))
        print("USer abovess")
        if UserDefaults.standard.integer(forKey: "x") == 1{
        labelExplain.text = "You have used all your chances! \n\nCome Back Tomorrow For More!"
        }
        
        if UserDefaults.standard.integer(forKey: "x") == 2{
        labelExplain.text = "You have answered all the quizs questions for this Month! If not done already, Consider answering the prompt!"
        }
            if UserDefaults.standard.integer(forKey: "x") == 3{
                print("in 3")
        labelExplain.text = "You have answered all the true and false questions for this Month! If not done already, Consider answering the prompt!"
            }
        self.clock = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.countdownDisplayText), userInfo: nil, repeats: true)
          
        self.clock2 = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.countdownDisplayText2), userInfo: nil, repeats: true)
        
        
        
        // Do any additional setup after loading the view.
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
       func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
    }
    

}
    @objc func countdownDisplayText(){
        if index >= currentPoints{
            clock.invalidate()
        }
         
        PointsThisRoundLabel.text = "Points Gained This Round: \(index)"
        index+=1
            
    }
    
        @objc func countdownDisplayText2(){
            if index2 >= totalPoints{
                clock2.invalidate()
            }
                
                totalPointsLabel.text = "Points Gained In Total: \(index2)"
                index2+=1
                
                
        }
}

