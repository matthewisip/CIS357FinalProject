//
//  GameScreenView.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 12/1/24.
//

import SwiftUI

struct GameScreenView: View {
    let players: Int
    let holes: Int

    @State private var currentTurn: Int = 1
    @State private var currentHole: Int = 1
    @State private var playerCards: [[String]] = []
    @State private var playedCards: [String] = []
    @State private var isCardPlayed: Bool = false
    @State private var playedCardText: String = ""
    
    let allCards: [String] = (1...54).map { "Card \($0)" } // Simulates a deck of 54 cards
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Hole \(currentHole) of \(holes)")
                .font(.headline)
            
            Text("Player \(currentTurn)'s Turn")
                .font(.title)
            
            Spacer()
            
            // Display Player's Cards
            Text("Your Cards:")
            ScrollView(.horizontal) {
                HStack {
                    ForEach(playerCards[currentTurn - 1], id: \.self) { card in
                        Button(action: {
                            playCard(card)
                        }) {
                            Text(card)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Played Card Popup
            if isCardPlayed {
                Text(playedCardText)
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow.opacity(0.8))
                    .cornerRadius(10)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            isCardPlayed = false
                        }
                    }
            }
            
            Spacer()
            
            // Next Hole or Next Turn
            Button(action: {
                nextTurnOrHole()
            }) {
                Text(currentHole == holes && currentTurn == players ? "End Game" : "Next Turn")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(currentHole == holes && currentTurn == players ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            dealInitialCards()
        }
    }
    
    // Deal initial cards to all players
    private func dealInitialCards() {
        let shuffledDeck = allCards.shuffled()
        playerCards = Array(0..<players).map { _ in Array(shuffledDeck.prefix(5)) }
    }
    
    // Play a card
    private func playCard(_ card: String) {
        if let index = playerCards[currentTurn - 1].firstIndex(of: card) {
            playerCards[currentTurn - 1].remove(at: index)
            playedCardText = "Player \(currentTurn) played \(card)!"
            playedCards.append(card)
            isCardPlayed = true
        }
    }
    
    // Advance to next turn or hole
    private func nextTurnOrHole() {
        if currentTurn < players {
            currentTurn += 1
        } else {
            currentTurn = 1
            if currentHole < holes {
                currentHole += 1
                replenishCards()
            } else {
                // End game
                playedCardText = "Thanks for playing!"
                isCardPlayed = true
            }
        }
    }
    
    // Replenish cards for all players
    private func replenishCards() {
        let shuffledDeck = allCards.shuffled()
        for i in 0..<players {
            if let newCard = shuffledDeck.first(where: { !playerCards[i].contains($0) && !playedCards.contains($0) }) {
                playerCards[i].append(newCard)
            }
        }
    }
}
