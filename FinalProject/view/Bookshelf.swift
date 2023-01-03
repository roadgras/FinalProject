//
//  Bookshelf.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import SwiftUI
import SDWebImageSwiftUI
//import Introspect
//import CoreData

struct BookshelfPage: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var saver: ItunesDataSaver
    @ObservedObject var viewModel: BookshelfViewModel
    @State private var searchText = ""
    

    var listContent: [Book] {
        var books = viewModel.books
        if searchText.isEmpty {
            return books
        }
        else {
            return books.filter {
                $0.name.contains(searchText)
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        //var books = viewModel.books
        //var inf = viewModel.inf_list
        //var inf: [Information] = []
        if viewModel.books.count <= 1 {
             Spacer()
        } else {
            let items = Array(repeating: GridItem(spacing: Drawing.gridSpacing), count: horizontalSizeClass == .compact ? 3 : 6)
            if #available(iOS 15.0, *) {
                NavigationView {
                    ScrollView{
                        LazyVGrid(columns: items, spacing: Drawing.gridRunSpacing) {
                            ForEach(listContent.dropFirst()) { book in
                             BookVItemView(book: book)
                             }
                            /*ForEach(inf){ data in
                                DeferNavigationLink {
                                    BookDetailPage(id: "1")
                                } label: {
                                    VStack{
                                        BookCover(url: data.imgUrl)
                                        Text(data.name).font(.bold(.body)()).lineLimit(1).foregroundColor(ThemeColor.darkGray)
                                        Spacer(minLength: 5)
                                    }
                                }
                            }*/
                            ForEach(saver.items.dropFirst()) { book in
                             BookVItemView(book: book)
                             }.onDelete { indexSet in
                                 saver.items.remove(atOffsets: indexSet)
                             }
                        }.padding(Screen.horizontalSafeAreaInsets(padding: Drawing.gridSpacing))
                    }
                }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                    .navigationTitle("書架")
            }
        }
    }
    
    var body: some View {
        Group {
            if viewModel.fetchStatus == .fetching {
                ProgressView()
            } else {
                content
            }
        }.onAppear {
            if viewModel.books.count == 0 {
                Task { await  viewModel.fetchData() }
            }
        }
    }
    
    private struct Drawing {
        static let navigationItemWidth = 50.0
        static let topViewHeight = 250.0
        static let firstBookWidth = 120.0
        static let gridSpacing = 15.0
        static let gridRunSpacing = 15.0
    }
}

struct BookCover: View {
    let url: String
    var width: Double?
    
    var body: some View {
        let image = WebImage(url: URL(string: url)).placeholder {
            Rectangle().foregroundColor(ThemeColor.lightGray)
        }.resizable().aspectRatio(3/4, contentMode: .fit).clipped()
        if let width = width {
            image.frame(width: width)
        } else {
            image
        }
    }
}

struct BookshelfPage_Previews: PreviewProvider {
    static var previews: some View {
        BookshelfPage(viewModel: BookshelfViewModel.mock()).preferredColorScheme(.light)
            .environmentObject(ItunesDataSaver())
    }
}
