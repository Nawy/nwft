//
//  WordItem.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 06/08/2021.
//

import Foundation
import RealmSwift

class WordItem: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _dictionaryId: ObjectId
    @Persisted var name: String = ""
    @Persisted var translation: String = ""
    @Persisted var correct: Int = 0
    @Persisted var wrong: Int = 0
    @Persisted var correctReactionTime: Int = -1
    @Persisted var wrongReactionTime: Int = -1
    
    
    @objc override init() {}
    
    init(name: String, translation: String, dictionaryId: ObjectId) {
        self._dictionaryId = dictionaryId;
        self.name = name
        self.translation = translation
    }
    
    
}
