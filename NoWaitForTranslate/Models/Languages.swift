//
//  Languages.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 04/08/2021.
//

import Foundation

struct NWFTLanguage: Equatable {
    var code: String
    var name: String
}

extension NWFTLanguage: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        let splitedValues = stringLiteral.components(separatedBy: "|")
        code = splitedValues[0]
        name = splitedValues[1]
    }
}

enum NWFTLanguages: NWFTLanguage, CaseIterable, Equatable {
    case english = "en|English", dutch = "nl|Dutch", russian = "ru|Russian", spanish = "es|Spanish"
    
    func isEqual(withCode code: String) -> Bool {
        return self.rawValue.code == code;
    }
    
    static func to(byCode code: String) -> NWFTLanguages {
        let elements = allCases.filter {
            $0.rawValue.code == code
        }
        if elements.count == 0 {
            return NWFTLanguages.english
        }
        return elements[0]
    }
    
    func isEqual(withName name: String) -> Bool {
        return self.rawValue.name == name;
    }
}
