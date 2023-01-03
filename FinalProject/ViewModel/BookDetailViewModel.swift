//
//  BookDetailViewModel.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import Foundation

enum ServiceError: Error {
    case jsonDecodeFailure
}

class BookDetailViewModel: ObservableObject {
    @Published var fetchStatus: FetchStatus = .fetching
    
    let bookId: String
    var book: BookDetail?
    var comments: [BookComment]?
    var recommendBooks: [Book]?
    
    init(bookId: String) {
        self.bookId = bookId
        Task { await fetchData() }
    }
    
    @MainActor
    func fetchData() async {
        do {
            fetchStatus = .fetching
            
            book = try await BookDetailService.requestDetail()
            comments = try await BookDetailService.requestComments()
            recommendBooks = try await BookDetailService.requestRecommendBooks()
            
            fetchStatus = .idle
        } catch {
            fetchStatus = .failed
        }
    }
    
    func requestDetail(completion: (()->Void)? = nil) {
        guard let url = Bundle.main.url(forResource: "novel_detail", withExtension: "json"),
              let response = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
              let dataMap = json["data"] as? [String: Any],
              let data = try? JSONSerialization.data(withJSONObject: dataMap, options: []) else {
            return
        }
        book = try? JSONDecoder().decode(BookDetail.self, from: data)
        completion?()
    }
    
    func requestComments(completion: (()->Void)? = nil) {
        guard let url = Bundle.main.url(forResource: "novel_comment", withExtension: "json"),
              let response = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
              let dataMap = json["data"] as? [[String: Any]],
              let data = try? JSONSerialization.data(withJSONObject: dataMap, options: []) else {
            return
        }
        comments = try! JSONDecoder().decode([BookComment].self, from: data)
        completion?()
    }
    
    func requestrecommendBooks(completion: (()->Void)? = nil) {
        guard let url = Bundle.main.url(forResource: "novel_recommend", withExtension: "json"),
              let response = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
              let dataMap = json["data"] as? [[String: Any]],
              let data = try? JSONSerialization.data(withJSONObject: dataMap, options: []) else {
            return
        }
        recommendBooks = try! JSONDecoder().decode([Book].self, from: data)
        completion?()
    }
}

class BookDetailService {
    
    static func requestDetail() async throws -> BookDetail {
        try await Task.sleep(nanoseconds: 300 * 1_000_000)
        return try await withCheckedThrowingContinuation { continuation in
            guard let url = Bundle.main.url(forResource: "novel_detail", withExtension: "json"),
                  let response = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                  let dataMap = json["data"] as? [String: Any],
                  let data = try? JSONSerialization.data(withJSONObject: dataMap, options: []) else {
                return
            }
            if let book = try? JSONDecoder().decode(BookDetail.self, from: data) {
                continuation.resume(with: Result.success(book))
            } else {
                continuation.resume(throwing: ServiceError.jsonDecodeFailure)
            }
        }
    }
    
    static func requestComments() async throws -> [BookComment] {
        try await Task.sleep(nanoseconds: 300 * 1_000_000)
        return try await withCheckedThrowingContinuation { continuation in
            guard let url = Bundle.main.url(forResource: "novel_comment", withExtension: "json"),
                  let response = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                  let dataMap = json["data"] as? [[String: Any]],
                  let data = try? JSONSerialization.data(withJSONObject: dataMap, options: []) else {
                return
            }
            if let comments = try? JSONDecoder().decode([BookComment].self, from: data) {
                continuation.resume(with: Result.success(comments))
            } else {
                continuation.resume(throwing: ServiceError.jsonDecodeFailure)
            }
        }
    }
    
    static func requestRecommendBooks() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 300 * 1_000_000)
        return try await withCheckedThrowingContinuation { continuation in
            guard let url = Bundle.main.url(forResource: "novel_recommend", withExtension: "json"),
                  let response = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                  let dataMap = json["data"] as? [[String: Any]],
                  let data = try? JSONSerialization.data(withJSONObject: dataMap, options: []) else {
                return
            }
            
            if let recommendBooks = try? JSONDecoder().decode([Book].self, from: data) {
                continuation.resume(with: Result.success(recommendBooks))
            } else {
                continuation.resume(throwing: ServiceError.jsonDecodeFailure)
            }
        }
    }
}
