//
//  ViewModel.swift
//  BB Quotes
//
//  Created by Marc Cruz on 7/31/23.
//

import Foundation

@MainActor
class ViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success(data: (quote: Quote, character: Character))
        case failed(error: Error)
    }
    
    @Published private(set) var status: Status = .notStarted
    
    private let controller: FetchController

    init(controller: FetchController) {
        self.controller = controller
    }
    
    func getCharacterQuote(character: Character) async {
        status = .fetching
        
        do {
            let quote = try await controller.fetchQuote(from: "", author: character.name)
            status = .success(data: (quote, character))
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getData(for show: String) async {
        status = .fetching
        
        var searchShow = show
        print("searchShow is \(searchShow)")
        if show.contains("Random") {
            let randomInt = Int.random(in: 0...1)
            searchShow = randomInt == 0 ? "Breaking Bad" : "Better Call Saul"
        }
        print("searchShow is now \(searchShow)")
        
        do {
            let quote = try await controller.fetchQuote(from: searchShow)
            let character = try await controller.fetchCharacter(quote.character)
            status = .success(data: (quote, character))
        } catch {
            status = .failed(error: error)
        }
    }
}
