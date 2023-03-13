//
//  StanfordMatchGameApp.swift
//  StanfordMatchGame
//
//  Created by admin on 11.03.2023.
//

import SwiftUI

@main
struct StanfordMatchGameApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
