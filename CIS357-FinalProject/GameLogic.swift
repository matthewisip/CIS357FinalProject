//
//  GameLogic.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 12/1/24.
//

import Foundation

class GameLogic: ObservableObject {
    @Published var players: Int
    @Published var holes: Int
    @Published var currentTurn: Int = 1
    @Published var currentHole: Int = 1
    @Published var playerCards: [[String]] = []
    @Published var playedCards: [String] = []
    @Published var gameOver: Bool = false
    
    private let allCards: [String] = (1...54).map { "Card \($0)" } // Full deck of 54 cards
    
    init(players: Int, holes: Int) {
        self.players = players
        self.holes = holes
        dealInitialCards()
    }
    
    // Deal 5 cards to each player at the start
    private func dealInitialCards() {
        let shuffledDeck = allCards.shuffled()
        playerCards = Array(0..<players).map { _ in Array(shuffledDeck.prefix(5)) }
    }
    
    // Play a card
    func playCard(card: String) -> Bool {
        guard let index = playerCards[currentTurn - 1].firstIndex(of: card) else { return false }
        playerCards[currentTurn - 1].remove(at: index)
        playedCards.append(card)
        return true
    }
    
    // Progress to the next turn or hole
    func nextTurnOrHole() {
        if currentTurn < players {
            currentTurn += 1
        } else {
            currentTurn = 1
            if currentHole < holes {
                currentHole += 1
                replenishCards()
            } else {
                gameOver = true
            }
        }
    }
    
    // Replenish cards for all players at the start of a new hole
    private func replenishCards() {
        let shuffledDeck = allCards.shuffled()
        for i in 0..<players {
            if let newCard = shuffledDeck.first(where: { !playerCards[i].contains($0) && !playedCards.contains($0) }) {
                playerCards[i].append(newCard)
            }
        }
    }
    
    // Reset the game for a new session
    func resetGame() {
        currentTurn = 1
        currentHole = 1
        playedCards.removeAll()
        gameOver = false
        dealInitialCards()
    }
}
