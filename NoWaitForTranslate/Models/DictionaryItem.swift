//
//  DictionaryItem.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 04/08/2021.
//

import Foundation
import RealmSwift

class DictionaryItem: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var language: String = NWFTLanguages.english.rawValue.code
    @Persisted var translationLanguage: String = NWFTLanguages.russian.rawValue.code
    
    @objc override init() {}
    
    init(name: String, language: NWFTLanguages, translationLanguage: NWFTLanguages) {
        self.name = name
        self.language = language.rawValue.code
        self.translationLanguage = translationLanguage.rawValue.code
    }
}

struct DictionaryItemDto {
    
    var _id : ObjectId = ObjectId()
    var name: String = ""
    var language: String = NWFTLanguages.english.rawValue.code
    var translationLanguage: String = NWFTLanguages.russian.rawValue.code
    
    var raw : DictionaryItem?
    
    init(item: DictionaryItem) {
        self._id = item._id
        self.name = item.name
        self.language = item.language
        self.translationLanguage = item.translationLanguage
        self.raw = item
    }
    
    init(name: String, language: NWFTLanguages, translationLanguage: NWFTLanguages) {
        self._id = ObjectId();
        self.name = name
        self.language = language.rawValue.code
        self.translationLanguage = translationLanguage.rawValue.code
    }
    
}
