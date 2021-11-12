//
//  PopupViewController.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/11.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.backgroundColor = .darkGray
        popUpView.layer.cornerRadius = 15
        
        firstTextLabel.text = "처음 오셨군요! 환영합니다 :)"
        firstTextLabel.font = .boldSystemFont(ofSize: 30)
        firstTextLabel.layer.cornerRadius = 15
        firstTextLabel.numberOfLines = 2
        firstTextLabel.adjustsFontSizeToFitWidth = true
        
        secondTextLabel.text = "당신만의 메모를 작성하고 관리해보세요!"
        secondTextLabel.numberOfLines = 2
        secondTextLabel.font = .boldSystemFont(ofSize: 30)
        secondTextLabel.layer.cornerRadius = 15
        secondTextLabel.adjustsFontSizeToFitWidth = true
        
        okButton.backgroundColor = .orange
        okButton.tintColor = .white
        okButton.layer.cornerRadius = 15
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        // 버튼 타이틀 크기 안 먹음
        okButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
