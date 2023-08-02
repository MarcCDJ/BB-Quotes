//
//  FetchController.swift
//  BB Quotes
//
//  Created by Marc Cruz on 7/30/23.
//

import Foundation

struct FetchController {
    enum NetworkError: Error {
        case badURL, badResponse
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    // https://breaking-bad-api-six.vercel.app/api/quotes/random?production=Breaking+Bad    // random quote by show
    // https://breaking-bad-api-six.vercel.app/api/quotes/random?author=Skyler+White        // random quote by character
    func fetchQuote(from show: String = "", author: String = "") async throws ->  Quote {
        let quoteURL = baseURL.appending(path: "quotes/random")
        var quoteComponents = URLComponents(url: quoteURL, resolvingAgainstBaseURL: true)
        let quoteQueryItem = !author.isEmpty
            ? URLQueryItem(name: "author", value: author)
            : URLQueryItem(name: "production", value: show.replaceSpaceWithPlus)
        
        quoteComponents?.queryItems = [quoteQueryItem]
        guard let fetchURL = quoteComponents?.url else {
            throw NetworkError.badURL
        }
        print("fetching quote: \(fetchURL)")
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        return quote
    }
    
    // https://breaking-bad-api-six.vercel.app/api/characters?name=Walter+White
    func fetchCharacter(_ name: String) async throws -> Character {
        let characterURL = baseURL.appending(path: "characters")
        var characterComponents = URLComponents(url: characterURL, resolvingAgainstBaseURL: true)
        let characterQueryItem = URLQueryItem(name: "name", value: name.replaceSpaceWithPlus)
        characterComponents?.queryItems = [characterQueryItem]
        
        guard let fetchURL = characterComponents?.url else {
            throw NetworkError.badURL
        }
        print("fetching character: \(fetchURL)")
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let characters = try decoder.decode([Character].self, from: data)
        
        return characters[0]
    }
}
