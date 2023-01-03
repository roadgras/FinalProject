//
//  BookstoreViewModel.swift
//  FinalProject
//
//  Created by li on 2022/12/19.
//

import Foundation

class BookstoreViewModel: ObservableObject {
    @Published var pageIndex = 0
    let vm = BookstoreListViewModel(type: .ranking)
    let list: [BookstoreListViewModel];
    
    init() {//, .male, .cartoon
        let tabTypes: [BookstoreListType] = [.Classification, .ranking]
        list = tabTypes.map({ type in BookstoreListViewModel(type: type) })
    }
}

class BookstoreListViewModel: ObservableObject {
    let type: BookstoreListType
    
    @Published var fetchStatus: FetchStatus = .idle
    var menus: [Menu]?
    var cards: [BookCard] = []
    var carousels: [Carousel]?
    
    init(type: BookstoreListType) {
        self.type = type
    }
    
    @MainActor
    func fetchData() async {
        if fetchStatus == .fetching {
            return
        }
        do {
            fetchStatus = .fetching
            
            let result = try await BookstoreService.requestList(type: type)
            carousels = result.carousels
            menus = result.menus
            cards = result.cards
            
            fetchStatus = .idle
        } catch {
            fetchStatus = .failed
        }
    }
    
}

class BookstoreService {
    typealias ListResult = (carousels: [Carousel]?, menus: [Menu]?, cards: [BookCard])
    
    static func requestList(type: BookstoreListType) async throws -> ListResult {
        // The delay is to simulate a network request
        try await Task.sleep(nanoseconds: 500 * 1_000_000)
        
        return try await withCheckedThrowingContinuation { continuation in
            guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "json"),
                  let response = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
                  let data = json["data"] as? [String: Any],
                  let modules = data["module"] as? [[String: Any]] else {
                return
            }
            
            var carousels: [Carousel]?
            var menus: [Menu]?
            var cards:[BookCard] = []
            
            for module in modules {
                let moduleName = module["m_s_name"] as? String
                let content = module["content"] as? [Any] ?? []
                guard let data = try? JSONSerialization.data(withJSONObject: content, options: []) else {
                    continue
                }
                switch moduleName {
                case "top_banner":
                    carousels = try? JSONDecoder().decode([Carousel].self, from: data)
                case "menu":
                    menus = try? JSONDecoder().decode([Menu].self, from: data)
                default:
                    if module["m_s_style"] != nil,
                       let data = try? JSONSerialization.data(withJSONObject: module, options: []),
                       let card = try? JSONDecoder().decode(BookCard.self, from: data) {
                        cards.append(card)
                    }
                }
            }
            
            continuation.resume(with: Result.success((carousels, menus, cards)))
        }
        
        
    }
    
}
