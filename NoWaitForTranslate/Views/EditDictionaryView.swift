//
//  DictionaryView.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 03/08/2021.
//

import SwiftUI

struct EditDictionaryView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let isNew: Bool
    let optionalBook: DictionaryItemDto?
    let dataService: DataRepository
    
    @State private var name: String = ""
    @State private var language = NWFTLanguages.english
    @State private var translationLanguage = NWFTLanguages.russian
    
    @State private var isKeyboardPresented = false
    
    private var baseLanguages: [NWFTLanguages] {
        return NWFTLanguages.allCases.filter {
            return $0 != self.translationLanguage
        }
    }
    
    private var translationLanguages: [NWFTLanguages] {
        return NWFTLanguages.allCases.filter {
            return $0 != self.language
        }
    }
    
    private var navigationTitle: String {
        return isNew ? "New" : "Update"
    }
    
    private var buttonName: String {
        return isKeyboardPresented ? "Done" : "Save"
    }
    
    init(withNew isNewValue: Bool, dataService: DataRepository, book optionalBook: DictionaryItemDto? = nil) {
        self.isNew = isNewValue
        self.optionalBook = optionalBook
        self.dataService = dataService
        
        // styles
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textContainerInset =
            UIEdgeInsets(top: 0, left: -5.0, bottom: 0, right: 0)
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            .font : UIFont(name: NWFTFonts.primaryFontName, size: 22)!,
            .foregroundColor: UIColor(NWFTStyleColors.darkColor2),
        ]
        navBarAppearance.barTintColor = UIColor.green
        navBarAppearance.tintColor = UIColor.green
        navBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navBarAppearance.shadowImage = UIImage()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            VStack {
                ZStack(alignment: .leading) {
                    if name.isEmpty {
                        Text("This is your nice dictionary description...")
                            .font(NWFTFonts.secondaryFont(withSize: 20.0))
                            .foregroundColor(NWFTStyleColors.secondBackgroudColor.opacity(0.7))
                            .lineSpacing(5)
                            .frame(height: 100, alignment: .topLeading)
                            .padding([.top, .leading, .trailing], 10.0)
                    }
                    TextEditor(text: $name)
                        .background(NWFTStyleColors.primaryBackgroundColor.opacity(0.0))
                        .font(NWFTFonts.secondaryFont(withSize: 20.0))
                        .lineSpacing(5)
                        .foregroundColor(NWFTStyleColors.secondBackgroudColor)
                        .frame(height: 100, alignment: .topLeading)
                        .padding([.top, .leading, .trailing], 10.0)
                        .onAppear {
                            if let book = self.optionalBook {
                                if !self.isNew {
                                    self.name = book.name
                                }
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                            self.isKeyboardPresented = false
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                            self.isKeyboardPresented = true
                        }
                }
                .frame(height: 100)
                .padding(.top, 10.0)
                
                
                ScrollView {
                    Picker("Language", selection: $language) {
                        ForEach(baseLanguages, id: \.self) {
                            Text("Read \($0.rawValue.name) \(NWFTUtils.flagIcon(withCode: $0.rawValue.code))")
                                .font(NWFTFonts.secondaryFont(withSize: 20.0))
                                .foregroundColor(NWFTStyleColors.secondBackgroudColor)
                                .tag($0)
                        }
                    }
                    .padding(.bottom, 10.0)
                    .background(NWFTStyleColors.primaryBackgroundColor)
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 130)
                    .clipped()
                    .onAppear {
                        if let book = self.optionalBook {
                            if !self.isNew {
                                self.language = NWFTLanguages.to(byCode: book.language)
                            }
                        }
                    }


                    Picker("Translation", selection: $translationLanguage) {
                        ForEach(translationLanguages, id: \.self) {
                            Text("translate to \($0.rawValue.name) \(NWFTUtils.flagIcon(withCode: $0.rawValue.code))")
                                .font(NWFTFonts.secondaryFont(withSize: 20.0))
                                .foregroundColor(NWFTStyleColors.secondBackgroudColor)
                                .tag($0)
                        }
                    }
                    .background(NWFTStyleColors.primaryBackgroundColor)
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 130)
                    .clipped()
                    .onAppear {
                        if let book = self.optionalBook {
                            if !self.isNew {
                                self.translationLanguage = NWFTLanguages.to(byCode: book.translationLanguage)
                            }
                        }
                    }
                    
                    HStack {
                        Text(NWFTUtils.flagIcon(withCode: language.rawValue.code))
                            .font(NWFTFonts.secondaryFont(withSize: 35.0))
                        Image(systemName: "arrow.right")
                            .resizable()
                            .foregroundColor(NWFTStyleColors.darkColor)
                            .frame(width: 30.0, height: 25)
                        Text(NWFTUtils.flagIcon(withCode: translationLanguage.rawValue.code))
                            .font(NWFTFonts.secondaryFont(withSize: 35.0))
                    }
                }
            }
            .padding(.all, 10)
            .background(NWFTStyleColors.primaryBackgroundColor.cornerRadius(13))
            Spacer()
            HStack {
                Button(self.buttonName) {
                    if (isKeyboardPresented) {
                        UIApplication.shared.endEditing()
                        return
                    }
                    
                    if (name.count > 5) {
                        let item = DictionaryItem()
                        item.name = self.name
                        item.language = self.language.rawValue.code
                        item.translationLanguage = self.translationLanguage.rawValue.code
                        if self.dataService.addDictionary(dictionary: item) {
                            print("added!")
                        }
                    }
                }.buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding(10.0)
        .background(NWFTStyleColors.primaryDarkBackgroundColor.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationButtonSmall(title: "Books") {
            self.presentationMode.wrappedValue.dismiss()
        })
        .navigationBarTitle(self.navigationTitle, displayMode: .inline)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EditDictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditDictionaryView(
                withNew: false,
                dataService: DataServiceTest(),
                book: DictionaryItemDto(name: "Test name", language: .dutch, translationLanguage: .english)
            )
        }
    }
}
