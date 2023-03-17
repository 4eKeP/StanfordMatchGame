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
    mutating func shuffle(){
        cards.shuffle()
    }
    
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    struct Card: Identifiable {
        
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMached = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let id: Int
       
        
        //MARK: - Bonus Time
        // this could give matching bonus points / if the user matches the card
        // before a certain amount of time passes during which the card is face up
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        // how much time left before the bonus opportunity Iuns out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemainig: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBounus: Bool {
            isMached && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMached && bonusTimeRemaining > 0
        }
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
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


