//
//  MainTableViewCell.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    @IBOutlet weak var cntentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fullContentLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cntentLabel.backgroundColor = .darkGray
        dateLabel.backgroundColor = .darkGray
        fullContentLabel.backgroundColor = .darkGray
        topView.backgroundColor = .darkGray
        bottomView.backgroundColor = .darkGray
    
        dateLabel.textColor = .lightGray
        fullContentLabel.textColor = .lightGray
        
        cntentLabel.font = .boldSystemFont(ofSize: 12)
        dateLabel.font = .systemFont(ofSize: 8)
        fullContentLabel.font = .systemFont(ofSize: 8)
        
        // 패딩 추가 필요
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
