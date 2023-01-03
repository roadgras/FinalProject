//
//  BookshelfViewModel.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import Foundation

struct Information: Identifiable {
    let id = UUID()
    var name: String
    var imgUrl: String
}


class BookshelfViewModel: ObservableObject {
    @Published var fetchStatus: FetchStatus = .idle
    @Published var books: [Book] = []
    @Published var inf_list: [Information] = []
    
    @MainActor
    func fetchData() async {
        if fetchStatus == .fetching {
            return
        }
        do {
            fetchStatus = .fetching
            books = try await BookshelfService.requestBookshelfData()
            fetchStatus = .idle
        } catch {
            fetchStatus = .failed
        }
    }
    
}

extension Information {
    static func mock1(id: String) -> Information {
        Information(name: "萬王之王",imgUrl: "https://static.ttkan.co/cover/wanxiangzhiwang-tiancantudou.jpg?w=120&h=160&q=100")
    }
}

extension BookshelfViewModel {
    static func mock() -> BookshelfViewModel {
        let vm = BookshelfViewModel()
        vm.books = [Book.mock(id: "0"), Book.mock(id: "1"), Book.mock(id: "2"), Book.mock(id: "3")]
        vm.inf_list = [Information.mock1(id: "0")]
        return vm
    }
}

class BookshelfService {
    
    static func requestBookshelfData() async throws -> [Book] {
        // The delay is to simulate a network request
        try await Task.sleep(nanoseconds: 500 * 1_000_000)
        
        return try await withCheckedThrowingContinuation { continuation in
            guard let url = Bundle.main.url(forResource: "bookshelf", withExtension: "json"),
                  let response = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                  let data = json["data"] as? [[String: Any]],
                  let booksData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
                return
            }
            
            let books = (try? JSONDecoder().decode([Book].self, from: booksData)) ?? []
            continuation.resume(with: Result.success(books))
        }
    }
}
