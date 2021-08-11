//
//  DictionaryRowView.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 03/08/2021.
//

import SwiftUI

struct DictionaryRowView: View {
    let book: DictionaryItemDto
    let dataService: DataRepository
    
    var body: some View {
        NavigationLink(
            destination: DictionaryView(book: book, dataService: self.dataService)) {
            HStack {
                Text("\(NWFTUtils.flagIcon(withCode: self.book.language))")
                    .font(NWFTFonts.secondaryFont(withSize: 30.0))
                    .foregroundColor(NWFTStyleColors.darkColor)
                    .padding(.trailing)
                Text("\(self.book.name)")
                    .font(NWFTFonts.secondaryFont(withSize: 17.0))
                    .foregroundColor(NWFTStyleColors.darkColor)
            }
            .padding(.vertical, 10.0)
            .background(Color.clear)
        }
        .background(Color.clear)
    }
}

struct DictionaryRowView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryRowView(book: DictionaryItemDto(name: "This is very long name for the testing purposes", language: .dutch, translationLanguage: .russian), dataService: DataServiceTest())
    }
}
