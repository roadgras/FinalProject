//
//   BookDetail.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import SwiftUI
import UIKit

struct BookDetailPage: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var saver: ItunesDataSaver
    @ObservedObject var vm: BookDetailViewModel
    @ObservedObject var bookshelfVM = BookshelfViewModel()
    @State var isSummaryUnfold: Bool = false
    @State var isReading = false
    init(id: String) {
        vm = BookDetailViewModel(bookId: id)
    }
    private var book: BookDetail {
        vm.book!
    }
    
    @ViewBuilder
    var summary: some View {
        if book.introduction != nil {
            ZStack(alignment: .bottomTrailing) {
                HStack {
                    Text("天地間，有萬相。而我李洛，終將成爲這萬相之王。繼《鬥破蒼穹》《武動乾坤》《大主宰》《元尊》之後，天蠶土豆又一部玄幻力作。\n\n離別的時候很快就到了。\n老宅庭院中。\n李洛望着面前的蔡薇，顏靈卿，袁青，雷彰等洛嵐府高層，此時的他們都是神情有些黯淡，因爲他們知道，今天就是李洛離開的時候，而此次一去，想要再見，怕就是得數年之後了。\n ∂∂∂洛嵐府剛剛失去了姜青娥這根頂樑柱，如果李洛也離去，那麼洛嵐府無疑是徹底的失去了精氣神。\n這對洛嵐府的士氣打擊是極大的。\n...\n").font(.subheadline).lineLimit(isSummaryUnfold ? nil : Drawing.summaryLineLimit).padding(.horizontal)
                    Spacer()
                }.padding(.vertical)
                Image( "detail_up").rotationEffect(Angle(degrees: isSummaryUnfold ? 0 : 180)).padding()
            }.onTapGesture {
                withAnimation {
                    isSummaryUnfold = !isSummaryUnfold
                }
            }
        }
    }
    
    var latestChapter: some View {
        HStack {
            Image("detail_latest")
            Text("最新")
            Text("第733章 離開大夏").foregroundColor(ThemeColor.dimGray)
            Spacer()
            Text(book.status).foregroundColor(book.statusColor)
            Image("arrow_right")
        }.font(.subheadline).padding(Drawing.cellPadding)
    }
    
    var chapter: some View {
        HStack {
            Image("detail_chapter")
            Text("目錄")
            Text("共733章").foregroundColor(ThemeColor.dimGray)
            Spacer()
            Image("arrow_right")
        }.font(.subheadline).padding(Drawing.cellPadding)
    }
    
    var tags: some View {
        HStack {
            Text("玄幻").font(.subheadline).foregroundColor(Drawing.tagColors[1]).padding(Drawing.tagPadding).border(Drawing.tagColors[1].opacity(Drawing.tagBorderOpacity))
        }.padding(Drawing.cellPadding)
    }
    
    @ViewBuilder
    var commentsView: some View {
        if let comments = vm.comments {
            HStack {
                Image("home_tip")
                Text("評價")
                Spacer()
                Image("detail_write_comment")
                Text("寫書評").foregroundColor(ThemeColor.primary).font(.subheadline)
            }.padding(Drawing.sectionPadding)
            Divider()
            ForEach(comments) { comment in
                CommentCell(comment: comment)
            }
            Divider()
            Text("查看全部評論（99條）").foregroundColor(ThemeColor.dimGray).font(.subheadline).padding(Drawing.cellPadding).frame( maxWidth: .infinity, alignment: .center)
            Rectangle().foregroundColor(ThemeColor.paper)
        }
    }
    
    @ViewBuilder
    var recommentView: some View {
        if let books = vm.recommendBooks {
            HStack {
                Image("home_tip")
                Text("推薦書本")
            }.padding(Drawing.sectionPadding)
            
            let items = Array(repeating: GridItem(), count: horizontalSizeClass == .compact ? 4 : 8)
            LazyVGrid(columns: items) {
                ForEach(books) { book in
                    BookVItemView(book: book)
                }
            }.padding([.leading, .bottom, .trailing])
        }
    }
    
    var toolBar: some View {
        ZStack(alignment: .top) {
            BlurView(blurEffect: UIBlurEffect(style: .systemThinMaterial)).frame(height: Drawing.toolBarHeight + Screen.safeAreaInsets.bottom)
            VStack(spacing: 0) {
                Divider()
                HStack(alignment: .center) {
                    Button {
                        let alert = UIAlertController(title: "提示", message: "已添加到書架", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                            print("確定")
                        }))
                        alert.show()
                        /*saver.items.append(Book.mock(id: "0"))*/
                    } label: {
                        Text("加書架").frame(maxWidth: .infinity)
                    }
                    Button {
                        isReading = true
                    } label: {
                        Text("開始閱讀").frame(maxWidth: .infinity,maxHeight: Drawing.toolBarButtonHeight).foregroundColor(ThemeColor.card).background(ThemeColor.primary).cornerRadius(Drawing.toolBarButtonCornerRadius)
                    }

                    Button {} label: {
                        if #available(iOS 16.0, *) {
                            ShareLink(item: "Peter好帥"){
                                Text("分享").frame(maxWidth: .infinity)
                            }
                        }
                        //Text("分享").frame(maxWidth: .infinity)
                    }
                }.padding(.top, Drawing.toolBarPaddingTop)
            }
        }
    }
    
    var content: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    Group {
                        BookDetailHeader(book: book)
                        summary
                        Divider().padding(.leading, Drawing.cellDividerLeading)
                        latestChapter
                        Divider().padding(.leading, Drawing.cellDividerLeading)
                        chapter
                        Divider().padding(.leading, Drawing.cellDividerLeading)
                        tags
                        Rectangle().foregroundColor(ThemeColor.paper)
                    }
                    commentsView
                    recommentView
                }.padding(.bottom, Screen.safeAreaInsets.bottom + Drawing.toolBarHeight)
            }.padding(Screen.horizontalSafeAreaInsets())
            toolBar
        }.background(ThemeColor.card).ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(vm.book?.name ?? "")
        .fullScreenCover(isPresented: $isReading) {
            ReaderPage(vm: ReaderViewModel(bookId: book.id))
        }
    }
    
    var body: some View {
        Group {
            if vm.fetchStatus == .fetching {
                ProgressView()
            } else {
                content
            }
        }.navigationBarBackButtonHidden(true).navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image("pub_back_gray").renderingMode(.template).foregroundColor(ThemeColor.darkGray)
        }))
    }
    
    private struct Drawing {
        static let cellPadding = EdgeInsets(top: 13, leading: 15, bottom: 13, trailing: 15)
        static let tagColors = [Color(hex: "F9A19F"), Color(hex: "59DDB9"), Color(hex: "7EB3E7")]
        static let cellDividerLeading = 20.0
        static let toolBarHeight = 50.0
        static let summaryLineLimit = 3
        static let tagPadding = EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        static let tagBorderOpacity = 0.3
        static let sectionPadding = EdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 15)
        static let toolBarButtonHeight = 40.0
        static let toolBarButtonCornerRadius = 4.0
        static let toolBarPaddingTop = 5.0
    }
}

extension UIAlertController {
    func show() {
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(self, animated: true)
        }
    }
}

struct BookDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailPage(id: "0").preferredColorScheme(.dark)
    }
}
