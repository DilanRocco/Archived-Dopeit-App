//
//  QuestionTableViewCell.swift
//  
//
//  Created by Dilan Piscatello on 4/9/20.
//

import UIKit
import Firebase
import FirebaseFirestore
class QuestionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        //fetchQuestion()
        overrideUserInterfaceStyle = .light
        
    }
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var daysRemaining: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var question = ""
    
    func setPost(question:String,DaysRemaning:String,Color:UIColor){
        self.daysRemaining.text = DaysRemaning
        self.daysRemaining.textColor = Color
        self.questionLabel.text = question
        self.questionLabel.textColor = .black
       }
        
        
        
        
    
}
