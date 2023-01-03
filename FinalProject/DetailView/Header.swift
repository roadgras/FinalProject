//
//  Header.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookDetailHeader: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    var book: BookDetail
    
    var stars: some View {
        ForEach(0..<Int(ceil(book.score)), id: \.self) { score in
            if Int(book.score) > score {
                Image("detail_star")
            } else {
                Image("detail_star_half")
            }
        }
    }
    
    var info: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("萬相之王")
            Text("\(book.wordCount.toStringAsFixed(2))萬字")
            HStack {
                Text("評分：\(book.score.toStringAsFixed(1))分")
                stars
            }
        }.font(.subheadline)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            HStack {
                BookCover(url: "https://static.ttkan.co/cover/wanxiangzhiwang-tiancantudou.jpg?w=120&h=160&q=100", width: 80)
                info
            }.padding().padding(.top, Screen.safeAreaInsets.top + 44)
        }
    }
}

extension Double {
    public func toStringAsFixed(_ fractionDigits: Int) -> String {
        let format = String(format: "%%0.%df", fractionDigits)
        return String(format: format, self)
    }
}

struct BookDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailHeader(book: BookDetail.mock()).previewLayout(.fixed(width: 375, height: 400))
    }
}
