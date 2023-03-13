//
//  MemoryGame.swift
//  StanfordMatchGame
//
//  Created by admin on 11.03.2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private var indexOfTheFaceUpCard: Int?{
        get {cards.indices.filter({cards[$0].isFaceUp}).onlyOne}
            /*
            var faceUpCardIndices = [Int]()
            for index in cards.indices{
                if cards[index].isFaceUp{
                    faceUpCardIndices.append(index)
                }
            }
             */
        set{cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}
            /*
            if index != newValue{
                cards[index].isFaceUp = false
            }else{
                cards[index].isFaceUp = true
            }
                */
        }
    }
    
    
    mutating func choose(_ card: Card){
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
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMached
        {
            if let potenchialMatchIndex = indexOfTheFaceUpCard{
                if cards[chosenIndex].content == cards[potenchialMatchIndex].content {
                    cards[chosenIndex].isMached = true
                    cards[potenchialMatchIndex].isMached = true
                }
                cards[chosenIndex].isFaceUp.toggle()
            }else{
                indexOfTheFaceUpCard = chosenIndex
            }
        }
    }
    
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    struct Card: Identifiable {
        
        var isFaceUp = false
        var isMached = false
        let content: CardContent
        let id: Int
    }
}
extension Array {
    var onlyOne: Element? {
        if self.count == 1 {
            return self.first
        }else{
            return nil
        }
    }
}


