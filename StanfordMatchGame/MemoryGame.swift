//
//  MemoryGame.swift
//  StanfordMatchGame
//
//  Created by admin on 11.03.2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private var indexOfTheFaceUpCard: Int?
    mutating func choose(_ card: Card){
     //   if let chosenIndex = index(of: card){
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMached
        {
            if let potenchialMatchIndex = indexOfTheFaceUpCard{
                if cards[chosenIndex].content == cards[potenchialMatchIndex].content {
                    cards[chosenIndex].isMached = true
                    cards[potenchialMatchIndex].isMached = true
                }
                indexOfTheFaceUpCard = nil
            }else{
                for index in cards.indices{
                    cards[index].isFaceUp = false
                }
                indexOfTheFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    /*
    func index(of card: Card) -> Int? {
        for index in 0..<cards.count {
            if cards[index].id == card .id {
                return index
            }
        }
        return nil
    }
     */
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = Array<Card>()
        //add numberOfPairsOfCards * 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    struct Card: Identifiable {
        
        var isFaceUp: Bool = false 
        var isMached: Bool = false
        var content: CardContent
        var id: Int
    }
}


