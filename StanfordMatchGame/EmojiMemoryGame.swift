//
//  EmojiMemoryGame.swift
//  StanfordMatchGame
//
//  Created by admin on 11.03.2023.
//

import SwiftUI

/*
func makeCardContent(index: Int)-> String{
    return "🥲"
}
 */

class EmojiMemoryGame: ObservableObject {
    static let emojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍️", "🛺", "🚃", "✈️", "🚁", "⛵️", "🚲", "🛴", "🚘"]
    static func createMemoryGame()-> MemoryGame<String>{
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    //MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card){
       // objectWillChange.send()
        model.choose(card)
    }
}

