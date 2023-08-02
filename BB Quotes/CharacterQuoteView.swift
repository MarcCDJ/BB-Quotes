//
//  CharacterQuoteView.swift
//  BB Quotes
//
//  Created by Marc Cruz on 8/2/23.
//

import SwiftUI

struct CharacterQuoteView: View {
    @StateObject private var viewModel = ViewModel(controller: FetchController())
    
    let imageURL: URL
    let character: Character
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center) {
                // character image
                VStack {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                }
                .frame(width: geo.size.width / 3.5, height: geo.size.height / 5)
                .cornerRadius(25)
                .padding(.top, 60)
                
                switch viewModel.status {
                case let .success(data):
                    Text("\"\(data.quote.quote)\"")
                        .font(.callout)
                        .padding(.top, 60)
                        .padding(.leading)
                default:
                    EmptyView()
                }
            }
            .task {
                await viewModel.getCharacterQuote(character: character)
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

struct CharacterQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterQuoteView(imageURL: Constants.previewCharacter.images.randomElement()!, character: Constants.previewCharacter)
            .preferredColorScheme(.dark)
    }
}
