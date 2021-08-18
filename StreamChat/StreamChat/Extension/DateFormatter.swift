//
//  DateFormatter.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/18.
//

import Foundation

extension DateFormatter {
    
    func convertToStringForChat(date: Date) -> String {
        self.dateFormat = DateConstant.kakaoDateFormat
        self.locale = Locale(identifier: currentLocaleIdentifier())
        
        return self.string(from: date)
    }
    
    private func currentLocaleIdentifier() -> String {
        if let localeID = Locale.preferredLanguages.first,
           let languageCode = Locale(identifier: localeID).languageCode,
           let regionCode = Locale.current.regionCode {
            return "\(languageCode)_\(regionCode)"
        } else {
            return Locale.current.identifier
        }
    }
}
