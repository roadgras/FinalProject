//
//  DataSaver.swift
//  FinalProject
//
//  Created by li on 2022/12/31.
//

import Foundation
import SwiftUI

class ItunesDataSaver: ObservableObject {
    @AppStorage("items") var itemsData: Data?
    
    @Published var items = [Book]() {
        didSet {
            let encoder = JSONEncoder()
            do {
                itemsData = try encoder.encode(items)
            } catch {
                print(error)
            }
        }
    }
    
    init() {
        if let itemsData {
            let decoder = JSONDecoder()
            do {
                items = try decoder.decode([Book].self, from: itemsData)
            } catch  {
                print(error)
            }
           
        }
    }
    
}
