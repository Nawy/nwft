//
//  DictionariesListView.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 04/08/2021.
//

import SwiftUI

struct DictionariesListView: View {
    
    private var dataService: DataRepository
    
    @State private var showDeleteAction = false
    @State private var books: [DictionaryItemDto] = []
    
    func reload() {
        books = self.dataService.getDictionaries(resetCache: false).map{
            DictionaryItemDto(item: $0)
        }
    }

    init(dataService: DataRepository) {
        self.dataService = dataService
        
        UIListContentView.appearance().backgroundColor = .clear
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            .font : UIFont(name: NWFTFonts.primaryFontName, size: 22)!,
            .foregroundColor: UIColor(NWFTStyleColors.darkColor2)
        ]
        navBarAppearance.barTintColor = UIColor.green
        navBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navBarAppearance.shadowImage = UIImage()
        
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectedBackgroundView = {
                    let view = UIView()
                    view.backgroundColor = UIColor(NWFTStyleColors.primaryDarkBackgroundColor)
                    view.layer.cornerRadius = 10;
                    return view
                }()
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 5.0) {
                List {
                    ForEach(books, id: \._id) { book in
                        DictionaryRowView(book: book, dataService: self.dataService)
                            .listRowBackground(NWFTStyleColors.primaryBackgroundColor)
                            .background(Color.clear)
                            .listRowInsets(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    }
                    .background(Color.clear)
                }.onAppear {
                    self.reload()
                }
                .listStyle(PlainListStyle())
                .padding(.all, 10)
                .background(NWFTStyleColors.primaryBackgroundColor.cornerRadius(13))
                .lineSpacing(7.0)
                
                NavigationLink(
                    destination: EditDictionaryView(withNew: true, dataService: self.dataService)) {
                    NavigationButton(title: "Create")
                }
            }
            .padding(10.0)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
            .background(NWFTStyleColors.primaryDarkBackgroundColor.ignoresSafeArea())
            .navigationBarTitle("Books", displayMode: .inline)
            
        }
    }
}

struct DictionariesListView_Previews: PreviewProvider {
    static var previews: some View {
        DictionariesListView(dataService: DataServiceTest())
    }
}
