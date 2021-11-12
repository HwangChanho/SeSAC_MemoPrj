//
//  MemoViewController.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/08.
//

import UIKit

class MemoViewController: UIViewController {
    
    static let identifier = "MemoViewController"
    
    var CompleteActionHandler: (() -> ())?
    
    @IBOutlet weak var textView: UITextView!
    
    var memo: MemoList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.backgroundColor = .black
        textView.textColor = .white
        
        if memo != nil {
            textView.text = "\(memo!.title)\n\(memo!.content ?? "")"
        }
        
        setUpBarButtons()
        
        textView.becomeFirstResponder()
    }
    
    func setUpBarButtons() {
        // var leftBarButtonItems: [UIBarButtonItem]? { get set }
        // right Bar Button
        let firstBarItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonPressed(_:)))
        let secondBarItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonPressed(_:)))
        
        var rightBarButtons: [UIBarButtonItem] = []
        
        rightBarButtons.append(firstBarItem)
        rightBarButtons.append(secondBarItem)
        
        self.navigationItem.rightBarButtonItems = rightBarButtons
        
        // left Bar Button
        
        let nameOfButton = "메모"
        
        self.navigationItem.backButtonTitle = nameOfButton
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: nameOfButton, style: .plain, target: self, action: #selector(backButtonPressed))
        /*
                if #available(iOS 14.0, *) {
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: nameOfButton, image: UIImage(systemName: "chevron.compact.left"), primaryAction: UIAction(handler: { _ in self.navigationController?.popViewController(animated: true)
                    }), menu: nil)
                } else {
        
                }
        */
        
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonPressed(_ sender: UIButton) {
        if let value = memo {
            if let text  = textView.text {
                var title: String = ""
                
                for char in text {
                    title.append(char)
                    if char == "\n" {
                        break
                    }
                }

                let content = text.substring(from: title.count, to: text.count)
                
                writeContentToRealm(index: value.id, title: title, content: content)
            }
        } else {
            if let text  = textView.text {
                var title: String = ""
                
                for char in text {
                    title.append(char)
                    if char == "\n" {
                        break
                    }
                }

                let content = text.substring(from: title.count, to: text.count)
                
                addDataToRealm(id: getAllMemoCountFromUserMemo() + 1, title: title, date: Date(), fixed: false, content: content)
            }
        }
        CompleteActionHandler?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonPressed(_ sender: UIButton) {
        let textToShare: String = textView.text

        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)

        // 2. 기본으로 제공되는 서비스 중 사용하지 않을 UIActivityType 제거(선택 사항)
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]

        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.showToast(message: "공유 성공")
           }  else  {
                self.showToast(message: "공유 실패")
           }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}

