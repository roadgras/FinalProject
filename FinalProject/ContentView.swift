//
//  ContentView.swift
//  FinalProject
//
//  Created by li on 2022/12/10.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @State private var tabBarIndex = 1
    @State private var searchText = ""
    @State private var bookshelfVM = BookshelfViewModel()
    @State private var bookstoreVM = BookstoreViewModel()
    var body: some View {
            NavigationView() {
                TabView(selection: $tabBarIndex) {
                    
                    BookshelfPage(viewModel: bookshelfVM)
                        .tabItem {Label("書架", systemImage: "books.vertical")}
                        .tag(0)
                    BookstorePage(viewModel: bookstoreVM)
                        .tabItem {Label("找書", systemImage: "network") }
                        .tag(1)
                    MePage()
                        .tabItem {Label("個人", systemImage: "bookmark.fill") }
                        .tag(2)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
