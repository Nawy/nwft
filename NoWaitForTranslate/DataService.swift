//
//  DataService.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 06/08/2021.
//

import Foundation
import RealmSwift

protocol DataRepository {
    func isCreated() -> Bool
    func addDictionary(dictionary: DictionaryItem) -> Bool
    func removeDictionary(dictionary: DictionaryItem) -> Bool
    func getDictionaries(resetCache isResetCache: Bool) -> [DictionaryItem]
    // words
    func addWord(word: WordItem) -> WordItem?
    func getWords(dictionaryId: ObjectId, resetCache isResetCache: Bool) -> [WordItem]
    
}

class DataService: DataRepository {
    
    private var realm : Realm?
    
    // cache
    private var dictionaries: [DictionaryItem]?
    private var wordsCache: [ObjectId:[WordItem]] = [:]
    private var maxCachedDictionaries = 3
    
    init(filename: String) {

        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(filename).realm")
        
        do {
            self.realm = try Realm(configuration: config)
        } catch {
            print("Can't create realm!")
            self.realm = nil
        }
    }
    
    func isCreated() -> Bool {
        return realm != nil
    }
    
    func addDictionary(dictionary: DictionaryItem) -> Bool {
        if let realm = self.realm {
            do {
                try realm.write {
                    realm.add(dictionary)
                }
                if var notNullDictionary = dictionaries {
                    notNullDictionary.append(dictionary)
                    self.dictionaries = notNullDictionary
                }
                return true
            } catch {
                print("Can't save realm!")
            }
        }
        return false
    }
    
    func removeDictionary(dictionary: DictionaryItem) -> Bool {
        if let realm = self.realm {
            do {
                try realm.write {
                    realm.delete(dictionary)
                }
                // update dictionary cache without quering database
                if let notNullDictionaries = dictionaries {
                    self.dictionaries = notNullDictionaries.filter { !$0.isInvalidated }
                }
                // if everything went fine
                return true
            } catch {
                print("Can't remove dictionary!")
            }
        }
        return false
    }
    
    func getDictionaries(resetCache isResetCache: Bool = false) -> [DictionaryItem] {
        // caching results
        if isResetCache || dictionaries == nil {
            if let realm = self.realm {
                dictionaries = realm.objects(DictionaryItem.self).flatMap { [$0] }
            }
        }
        
        // check for not null
        if let nonNullDictionaries = self.dictionaries {
            return nonNullDictionaries
        } else {
            return []
        }
    }
    
    func addWord(word: WordItem) -> WordItem? {
        if let realm = self.realm {
            do {
                try realm.write {
                    realm.add(word)
                }
                return word
            } catch {
                print("Can't save a word!")
            }
        }
        return nil
    }
    func getWords(dictionaryId: ObjectId, resetCache isResetCache: Bool = false) -> [WordItem] {
        let words = wordsCache[dictionaryId]
        if let notNullWords = words {
            if !isResetCache {
                return notNullWords
            }
        }
        
        if let realm = self.realm {
            let predicate = NSPredicate(format: "_dictionaryId = %@", dictionaryId)
            let requestedWords: [WordItem] = realm.objects(WordItem.self)
                .filter(predicate)
                .flatMap{[$0]}
            
            self.wordsCache[dictionaryId] = requestedWords
            self.cleanUpCache()
            return requestedWords
        }
        return []
    }
    
    func cleanUpCache() {
        if (self.wordsCache.count > maxCachedDictionaries) {
            let result = self.wordsCache.popFirst()
            if let notNullResult = result {
                print("Cache cleaned up for \(notNullResult.key)")
            }
        }
    }
}

class DataServiceTest: DataRepository {
    func getWords(dictionaryId: ObjectId, resetCache isResetCache: Bool) -> [WordItem] {
        return [
            WordItem(name: "apple", translation: "яблоко", dictionaryId: ObjectId()),
            WordItem(name: "cat", translation: "кошка", dictionaryId: ObjectId()),
            WordItem(name: "participate", translation: "участвовать", dictionaryId: ObjectId()),
            WordItem(name: "intricate", translation: "запутанный", dictionaryId: ObjectId())
        ]
    }
    
    func addWord(word: WordItem) -> WordItem? {
        return word
    }
    
    func isCreated() -> Bool {
        return true
    }
    
    func addDictionary(dictionary: DictionaryItem) -> Bool {
        return true
    }
    
    func removeDictionary(dictionary: DictionaryItem) -> Bool {
        return true
    }
    
    func getDictionaries(resetCache isResetCache: Bool) -> [DictionaryItem] {
        return [
            DictionaryItem(name: "Klara and The Sun", language: .english, translationLanguage: .russian),
            DictionaryItem(name: "Extreme Ownership", language: .english, translationLanguage: .russian),
            DictionaryItem(name: "Additional books translation", language: .english, translationLanguage: .russian),
            DictionaryItem(name: "My environmental dutch dictionary", language: .dutch, translationLanguage: .russian)
        ]
    }
    
    
}
