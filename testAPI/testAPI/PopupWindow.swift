//
//  PopupWindow.swift
//  abseil
//
//  Created by Dilan Piscatello on 5/3/20.
//

import UIKit

protocol PopUpDelegate {
    func handleDismissal()
}
    
    
    
class PopupWindow: UIView {

    var shouldShowSuccess: Int?{
    didSet{
        guard let success = shouldShowSuccess else {return}
        
        
        if success == 1{
            checkLabel.text = "This crown is earned by Signing Up!"
        }
            else if success == 2 {
                checkLabel.text = "This crown is earned by getting 100 Dopeit points in one Month!"
            }
            else if success == 3 {
                   checkLabel.text = "This crown is earned by getting 1000 Dopeit points in one Month!"
                       }
            else if success == 4 {
                      checkLabel.text = "This crown is earned by winning one month!"
                       }
            else if success == 5 {
                   checkLabel.text = "This crown is earned by playing for four months!"
                       }
            else if success == 6 {
                  checkLabel.text = "This crown is earned by obtaining 100 Dopeit points from one discussion post!"
                       }
        else if success == 7 {
        checkLabel.text = "This crown is earned by playing for six months!"
             }
        else if success == 8 {
        checkLabel.text = "This crown is earned by getting 10 questions from the multiple choice right in one round!"
             }
        else if success == 9 {
        checkLabel.text = "This crown is earned by getting 15 question from the true and false right in one round!"
             }
        else if success == 10 {
        checkLabel.text = "By clicking each individual crown, you can understand how they are awarded!"
             }
        
    }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate: PopUpDelegate?
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    let checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        
        return label
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 22)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        addSubview(checkLabel)
        checkLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -48).isActive = true
        
        checkLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        checkLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        checkLabel.numberOfLines = 0
        checkLabel.textAlignment = .left
        addSubview(notificationLabel)
        notificationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        notificationLabel.topAnchor.constraint(equalTo: checkLabel.bottomAnchor, constant: 0).isActive = true
        
        addSubview(button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    @objc func handleDismissal() {
        delegate?.handleDismissal()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

