//
//  Bookstore.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookstoreListView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @ObservedObject var viewModel: BookstoreListViewModel
    
    var content: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(alignment: .leading) {
            
                    ForEach(viewModel.cards, id: \.title) { card in
                        //SectionHeader(title: card.title)
                        switch viewModel.type.title(){
                        case "分類":
                            //BookGridView(books: card.books)
                            SectionHeader(title: card.title)
                            Book1View(books: card.books)
                        case "排行榜":
                            Book2View(books: card.books)
                        default:
                            //SectionHeader(title: card.title)
                            Book1View(books: card.books)
                        }
                        //BookHorizontalView(books: card.books)
                        Spacer(minLength: Drawing.sectionHeight)
                    }.foregroundColor(ThemeColor.darkGray)
                }
                .padding(EdgeInsets(top: Screen.navigationBarHeight, leading: Screen.safeAreaInsets.left, bottom: Drawing.tabBarHeight + Screen.safeAreaInsets.bottom, trailing: Screen.safeAreaInsets.right))
            }.background(ThemeColor.card)
        }
    }
    
    var body: some View {
        Group {
            if viewModel.fetchStatus == .fetching {
                ProgressView()
            } else {
                if #available(iOS 15.0, *) {
                    content.refreshable {
                        await viewModel.fetchData()
                    }
                } else {
                    content
                }
            }
        }.onAppear {
            if viewModel.cards.isEmpty {
                Task { await viewModel.fetchData() }
            }
        }
    }
    
    struct Book1View: View {
        let books: [Book]
        
        var body: some View {
            LazyVStack {
                ForEach(Array(books.enumerated()),  id: \.element.id) { index, book in
                    if(index%5==0){
                        BookCell2(book: book)
                    }else{
                        BookCell(book: book)
                    }
                }
                
            }.padding(EdgeInsets.init(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
    }
    
    struct Book2View: View {
        let books: [Book]
        
        var body: some View {
            LazyVStack {
                ForEach(Array(books.enumerated()),  id: \.element.id) { index, book in
                    BookCell3(book: book)
                }
                
            }.padding(EdgeInsets.init(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
    }
    
    private struct Drawing {
        static let carouselAspect: CGFloat = 5/3
        static let tabBarHeight = 50.0
        static let sectionHeight = 20.0
    }
}

struct BookstorePage: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State var pageIndex = 0
    let viewModel: BookstoreViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            ForEach(0..<viewModel.list.count, id: \.self) { idx in
                if idx == pageIndex  {
                    BookstoreListView(viewModel: viewModel.list[idx]).tag(idx).tag(idx)
                }
            }
            .frame(maxHeight: CGFloat.infinity)
            
            TopBarView(titles: viewModel.list.map { $0.type.title() }, selection: $pageIndex)
        }.ignoresSafeArea()
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5).frame(width: 3, height: 20).foregroundColor(ThemeColor.secondary)
            Text(title).font(.bold(.title3)())
        }
        .padding(.leading)
    }
}

class Screen {
    static var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    static var navigationBarHeight: CGFloat {
        49.0 + safeAreaInsets.top
    }
    
    static var tabbarHeight: CGFloat {
        50.0 + safeAreaInsets.bottom
    }
    
    static func horizontalSafeAreaInsets(padding: CGFloat = 0) -> EdgeInsets {
        EdgeInsets(top: 0, leading: safeAreaInsets.left + padding, bottom: 0, trailing: safeAreaInsets.right + padding)
    }
}

struct TopBarView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    let titles: [String]
    @Binding var selection: Int
    
    @ViewBuilder
    func itemView(title: String, index: Int) -> some View {
        let isSelected = (index == selection)
        Button {
            selection = index
        } label: {
            VStack(spacing: 5.0) {
                Text(title).font(.title3).foregroundColor(isSelected ? ThemeColor.darkGray : ThemeColor.dimGray)
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 20, height: 4)
                    .foregroundColor(ThemeColor.secondary)
                    .opacity(isSelected ? 1 : 0)
            }.frame(maxWidth:.infinity)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            BlurView(blurEffect: UIBlurEffect(style: .systemThinMaterial)).frame(height: Screen.navigationBarHeight)
            HStack {
                Spacer().frame(maxWidth:.infinity)
                ForEach(0..<titles.count, id: \.self) { idx in
                    itemView(title: titles[idx], index: idx)
                }
                Spacer()
                .frame(maxWidth:.infinity)
            }.padding(.bottom, 5)
        }
    }
}

struct BlurView: UIViewRepresentable {
    let blurEffect: UIBlurEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ nsView: UIVisualEffectView, context: Context) {}
}


struct BookstorePage_Previews: PreviewProvider {
    static var previews: some View {
//        BookstorePage()
            BookstorePage(viewModel: BookstoreViewModel()).preferredColorScheme(.dark)
    }
}
