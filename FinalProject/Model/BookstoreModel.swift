//
//  BookstoreModel.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import Foundation

enum FetchStatus {
    case idle
    case fetching
    case failed
}

enum BookstoreListType: String {
    case Classification = "Classification"
    //case male = "home_male"
    case ranking = "ranking"
    //case cartoon = "home_cartoon"
    
    func title() -> String {
        switch self {
        case .Classification:
            return "分類"
        /*case .male:
            return "男生"*/
        case .ranking:
            return "排行榜"
        /*case .cartoon:
            return "漫畫"*/
        }
    }
}

struct Menu: Codable {
    let title: String
    let imageName: String
    
    enum CodingKeys: String, CodingKey {
        case title = "toTitle"
        case imageName = "icon"
    }
}

enum BookCardStyle: Int, Codable {
    case unknow
    case grid
    case hybird
    case cell
}

struct BookCard: Codable {
    let title: String
    let style: BookCardStyle
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case title = "m_s_name"
        case style = "m_s_style"
        case books = "content"
    }
}

struct Carousel: Codable {
    let imageUrl: String
    let linkUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case linkUrl = "link_url"
    }
}

extension Int {
    public var countDescription: String {
        self > 10000 ? String(format: "%.2f萬", Double(self) / 10000.0) : "\(self)"
    }
}
