//
//  String+Extension.swift
//  SeSAC_MemoPrj
//
//  Created by ChanhoHwang on 2021/11/10.
//

import Foundation

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to)
        
        return String(self[startIndex ..< endIndex])
    }
}
