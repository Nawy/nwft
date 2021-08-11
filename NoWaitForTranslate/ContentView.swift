//
//  ContentView.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 31/07/2021.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    private let dataService: DataService
    init() {
        dataService = DataService(filename: "nwft")
//        if dataService.isCreated() {
//            let item = DictionaryItem()
//            item.name = "The first object inside the database, isn't it cool?"
//            item.language = NWFTLanguages.english.rawValue.code
//            item.translationLanguage = NWFTLanguages.russian.rawValue.code
//            if dataService.addDictionary(dictionary: item) {
//                print("value was added!")
//            }
//        }
    }

    var body: some View {
        DictionariesListView(dataService: dataService)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
