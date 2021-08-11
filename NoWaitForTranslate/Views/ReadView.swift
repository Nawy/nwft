//
//  ReadView.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 07/08/2021.
//

import SwiftUI

struct ReadView: View {
    
    @State private var listenLabelSize: CGFloat = 1.0
    @State private var recognizedText = ""
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: <#T##String?#>, ascending: <#T##Bool#>)])
    private let listenService = NativeListenService()
    private let speechService = NativeSpeechService()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let book: DictionaryItemDto
    let dataService: DataRepository
    
    @State private var isRecording = false
    
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
        VStack(spacing: 10.0) {
            HStack {
                Text(book.name)
                    .font(NWFTFonts.primaryFont(withSize: 22.0))
                    .foregroundColor(NWFTStyleColors.darkColor2)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 10.0)
            }
            
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
                .frame(maxWidth: .infinity)
                
                if self.isRecording {

                    HStack(alignment: .center) {
                        Image(systemName: "mic.fill")
                            .resizable()
                            .foregroundColor(NWFTStyleColors.darkColor)
                            .frame(width: 20, height: 28, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Say a word")
                            .font(NWFTFonts.secondaryFont(withSize: 20))
                            .foregroundColor(NWFTStyleColors.darkColor)
                    }
                    .padding(.all, 20.0)
                    .scaleEffect(listenLabelSize)
                    .onAppear {
                        DispatchQueue.main.async {
                            withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                                self.listenLabelSize = 1.2
                            }
                        }
                    }
                } else {
                    HStack(alignment: .center) {
                        Image(systemName: "mic.fill")
                            .resizable()
                            .foregroundColor(NWFTStyleColors.darkColor)
                            .frame(width: 20, height: 28, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Press button to speak")
                            .font(NWFTFonts.secondaryFont(withSize: 20))
                            .foregroundColor(NWFTStyleColors.darkColor)
                    }
                    .padding(.all, 20.0)
                }

                HStack {
                    Text(recognizedText)
                        .font(NWFTFonts.secondaryFont(withSize: 20))
                        .foregroundColor(NWFTStyleColors.secondBackgroudColor)
                        .padding(.all, 15.0)
                    if !recognizedText.isEmpty {
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(NWFTStyleColors.darkColor)
                            .scaleEffect(1.1)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    self.speechService.say(recognizedText)
                                }
                            }
                    }
                }
                Image(systemName: "arrow.down.square.fill")
                    .foregroundColor(NWFTStyleColors.darkColor)
                
                Text("Translated")
                    .font(NWFTFonts.secondaryFont(withSize: 20))
                    .foregroundColor(NWFTStyleColors.secondBackgroudColor)
                    .padding(.all, 15.0)
            }
            .padding(.all, 10)
            .background(NWFTStyleColors.primaryBackgroundColor.cornerRadius(13))
            
            Spacer()

            HStack {
                Button(self.getRecordingButtinName()) {
                    if self.isRecording {
                        self.listenService.stop()
                        self.isRecording.toggle()
                    } else {
                        self.isRecording.toggle()
                        self.listenService.listen { (speechText, isFinal) in
                            guard let text = speechText, !text.isEmpty else {
                                print("text is empty")
                                return
                            }
                            DispatchQueue.main.async {
                                withAnimation {
                                    self.recognizedText = text
                                    if isFinal && !text.isEmpty {
                                        self.speechService.say(text)
                                    }
                                }
                            }
                        }
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .onAppear {
                    listenService.checkPermissions()
                }
            }
        }
        .padding(10.0)
        .background(NWFTStyleColors.primaryDarkBackgroundColor.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationButtonSmall(title: "Book") {
            self.presentationMode.wrappedValue.dismiss()
        })
        .navigationBarTitle(
            "",
            displayMode: .inline
        )
    
    }
    
    func getRecordingButtinName() -> String {
        if self.isRecording {
            return "Stop"
        } else {
            return "Speak"
        }
    }
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReadView(book: DictionaryItemDto(name: "Test name", language: .english, translationLanguage: .dutch), dataService: DataServiceTest())
        }
    }
}
