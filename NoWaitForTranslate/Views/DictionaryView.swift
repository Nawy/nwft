//
//  DictionaryView.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 06/08/2021.
//

import SwiftUI

struct DictionaryView: View {
    @State private var showDeleteAction = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let book: DictionaryItemDto
    let dataService: DataRepository
    
    func removeCurrentBook() -> Bool {
        if let raw = self.book.raw {
            if self.dataService.removeDictionary(dictionary: raw) {
                return true;
            }
        }
        return false
    }
    
    init(book: DictionaryItemDto, dataService: DataRepository) {
        self.book = book
        self.dataService = dataService
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            .font : UIFont(name: NWFTFonts.primaryFontName, size: 22)!,
            .foregroundColor: UIColor(NWFTStyleColors.darkColor2),
        ]
        navBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navBarAppearance.shadowImage = UIImage()
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10.0) {
            Text(book.name)
                .font(NWFTFonts.primaryFont(withSize: 22.0))
                .foregroundColor(NWFTStyleColors.darkColor2)
                .multilineTextAlignment(.trailing)
                .padding(.trailing, 10.0)
            VStack {
                HStack(alignment: .center, spacing: 10.0)  {
                    Text(NWFTUtils.flagIcon(withCode: book.language))
                        .font(NWFTFonts.secondaryFont(withSize: 35.0))
                    Image(systemName: "arrow.right")
                        .resizable()
                        .foregroundColor(NWFTStyleColors.darkColor)
                        .frame(width: 30.0, height: 25)
                    Text(NWFTUtils.flagIcon(withCode: book.translationLanguage))
                        .font(NWFTFonts.secondaryFont(withSize: 35.0))
                }
                Text("Additional information here")
                    .font(NWFTFonts.secondaryFont(withSize: 20.0))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .foregroundColor(NWFTStyleColors.darkColor)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .leading, .trailing], 10.0)
                
                VStack(alignment: .center) {
                    Button("Delete dictionary") {
                        self.showDeleteAction = true
                    }
                    .buttonStyle(DeleteButtonStyle())
                    .frame(maxWidth:200, alignment: .center)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                .padding(.top, 20.0)
                .actionSheet(isPresented: $showDeleteAction) {
                    ActionSheet(
                        title: Text("Removing..."),
                        message: Text("Delete '\(book.name)'?"),
                        buttons: [
                            .cancel { print(self.$showDeleteAction) },
                            .destructive(Text("Delete")) {
                                // remove and dismiss current window
                                if removeCurrentBook() {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        ]
                    )
                }
            }
            .padding(.all, 10)
            .background(NWFTStyleColors.primaryBackgroundColor.cornerRadius(13))

            Spacer()

            HStack {
                Button("Play") {
                    
                }.buttonStyle(PrimaryButtonStyle())
                NavigationLink(
                    destination: ReadView(book: self.book, dataService: self.dataService)) {
                    NavigationButton(title: "Read")
                }
            }
        }
        .padding(10.0)
        .background(NWFTStyleColors.primaryDarkBackgroundColor.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationButtonSmall(title: "Books") {
            self.presentationMode.wrappedValue.dismiss()
        })
        .navigationBarTitle(
            "",
            displayMode: .inline
        )
    
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DictionaryView(book: DictionaryItemDto(name: "Test name", language: .dutch, translationLanguage: .english), dataService: DataServiceTest())
        }
    }
}
