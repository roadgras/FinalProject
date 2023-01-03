//
//  book.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import Foundation
import SwiftUI

struct Book: Identifiable, Codable {
    let id: String
    let name: String
    let imgUrl: String
    let author: String
    let introduction: String?
    let status: String?
    let type: String?
    
    private var recommendCountWrapper: StringBacked<Int>?
    var recommendCount: Int {
        get { recommendCountWrapper?.value ?? 0 }
        set {
            recommendCountWrapper?.value = newValue
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "bid"
        case name = "bookname"
        case imgUrl = "book_cover"
        case author = "author_name"
        case recommendCountWrapper = "recommend_num"
        case introduction = "introduction"
        case status = "stat_name"
        case type = "class_name"
    }
}

struct BookDetail: Identifiable, Codable {
    let id: String
    let name: String
    let imgUrl: String
    let author: String
    let introduction: String?
    let status: String
    let type: String
    
    let lastChapter: Chapter
    let price: Double
    let score: Double
    
    let firstArticleId: Int
    let wordCount: Double
    let tags: [String]
    
    private var chapterCountWrapper: StringBacked<Int>?
    var chapterCountCount: Int {
        get { chapterCountWrapper?.value ?? 0 }
        set { chapterCountWrapper?.value = newValue }
    }
    
    private var commentCountWrapper: StringBacked<Int>?
    var commentCount: Int {
        get { commentCountWrapper?.value ?? 0 }
        set { commentCountWrapper?.value = newValue }
    }
    
    private var recommendCountWrapper: StringBacked<Int>?
    var recommendCount: Int {
        get { recommendCountWrapper?.value ?? 0 }
        set { recommendCountWrapper?.value = newValue }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "bid"
        case name = "bookname"
        case imgUrl = "book_cover"
        case author = "author_name"
        case introduction = "introduction"
        case status = "stat_name"
        case type = "class_name"
        case recommendCountWrapper = "recommend_num"
        case lastChapter = "lastChapter"
        case price = "price"
        case score = "score"
        case firstArticleId = "first_article_id"
        case wordCount = "wordCount"
        case tags = "tag"
        case commentCountWrapper = "comment_count"
        case chapterCountWrapper = "chapterNum"
    }
    
    var statusColor: Color {
        status == "连载" ? ThemeColor.blue : ThemeColor.primary
    }
}

struct Chapter: Identifiable, Codable {
    let id: Int
    let title: String
}

struct BookComment: Identifiable, Codable {
    let id: String
    let nickName: String
    let userPhoto: String
    let text: String
}

// MARK: - Mock

extension BookDetail {
    static func mock() -> BookDetail {
        let url = Bundle.main.url(forResource: "novel_detail", withExtension: "json")!
        let response = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: response, options: []) as? [String: Any]
        let dataMap = json!["data"] as! [String: Any]
        let data = try! JSONSerialization.data(withJSONObject: dataMap, options: [])
        let book = try! JSONDecoder().decode(BookDetail.self, from: data)
        return book
    }
}

extension Book {
    static func mock(id: String) -> Book {
        Book(id: id, name: "萬相之王", imgUrl: "https://static.ttkan.co/cover/wanxiangzhiwang-tiancantudou.jpg?w=120&h=160&q=100", author: "天蠶土豆", introduction: "天地間，有萬相。而我李洛，終將成爲這萬相之王。繼《鬥破蒼穹》《武動乾坤》《大主宰》《元尊》之後，天蠶土豆又一部玄幻力作。", status: "完结", type: "玄幻")
    }
}

extension BookComment {
    static func mock(id: String) -> BookComment {
        BookComment(id: id, nickName: "小明", userPhoto: "https://static.ttkan.co/cover/xiaolifeidaozhiguijianchou-guanhaitingtao.jpg?w=120&h=160&q=100", text: "好看")
    }
}


protocol StringRepresentable: CustomStringConvertible {
    init?(_ string: String)
}

extension Int: StringRepresentable {}

struct StringBacked<Value: StringRepresentable>: Codable {
    var value: Value
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        guard let value = Value(string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Failed to convert an instance of \(Value.self) from '\(string)'"
            )
        }
        
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.description)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
//        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff
        )
    }
}

struct ThemeColor {
    static var primary = Color("primary")
    static var secondary = Color("secondary")
    static var red = Color("red")
    static var orange = Color("orange")
    static var card = Color("card")
    static var paper = Color("paper")
    static var lightGray = Color("light_gray")
    static var darkGray = Color("dark_gray")
    static var dimGray = Color("dim_gray")
    static var gray = Color("gray")
    static var blue = Color("blue")
    static var golden = Color("golden")
}
