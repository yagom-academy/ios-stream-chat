//
//  DateFormatter.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/18.
//

import Foundation

extension DateFormatter {
    
    func convertToStringForChat(date: Date) -> String {
        self.dateFormat = "a hh:mm"
        self.locale = Locale(identifier: "ko_KR")
        
        return self.string(from: date)
    }
}
