//
//  UIViewController+Extension.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/12.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 18)) {
        let toastLabel = UILabel()
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        toastLabel.sizeToFit()
        toastLabel.backgroundColor = .clear
        
        self.view.addSubview(toastLabel)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height / 3),
        ])
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func colorText(text: String) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: (text), attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.orange, .kern: -1.0]) // kern은 자간
        
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: (text as NSString).range(of: text))
        
        return attributedString
        
        // Label.attributedText = colorText(text: coloringText)
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
