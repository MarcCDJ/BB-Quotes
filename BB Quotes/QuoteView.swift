//
//  QuoteView.swift
//  BB Quotes
//
//  Created by Marc Cruz on 7/31/23.
//

import SwiftUI

struct QuoteView: View {
    @StateObject private var viewModel = ViewModel(controller: FetchController())
    @State private var showCharacterInfo = false

    var show: String

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if show.contains("Random") {
                    Image("tree")
                        .resizable()
                        .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                } else {
                    Image(show.lowerNoSpaces)
                        .resizable()
                        .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                }

                VStack {
                    VStack {
                        Spacer(minLength: 140)

                        switch viewModel.status {
                        case let .success(data):
                            Text("\"\(data.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .cornerRadius(25)
                                .padding(.horizontal)

                            ZStack(alignment: .bottom) {
                                AsyncImage(url: data.character.images[0]) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                                .cornerRadius(80)
                                .onTapGesture {
                                    showCharacterInfo.toggle()
                                }
                                .sheet(isPresented: $showCharacterInfo) {
                                    CharacterView(show: show, character: data.character)
                                }

                                Text(data.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            .cornerRadius(80)

                        case .fetching:
                            ProgressView()
                        default:
                            EmptyView()
                        }

                        Spacer()
                    }

                    Button {
                        Task {
                            await viewModel.getData(for: show)
                        }
                    } label: {
                        Text(show.contains("Random") ? "Get Random Character" : "Get Random Quote")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("\(show.noSpaces)Button"))
                            .cornerRadius(7)
                            .shadow(color: Color("\(show.noSpaces)Shadow"), radius: 2)
                    }
                    .task {
                        await viewModel.getData(for: show)
                    }

                    Spacer(minLength: 180)
                }
                .frame(width: geo.size.width)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(show: Constants.randomName)
            .preferredColorScheme(.dark)
    }
}
