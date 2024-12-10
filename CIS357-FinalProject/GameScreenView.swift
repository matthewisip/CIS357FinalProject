//
//  GameScreenView.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 11/20/24.
//
import SwiftUI

struct GameScreenView: View {
    let players: Int
    let holes: Int
    
    @State private var currentTurn: Int = 1
    @State private var currentHole: Int = 1
    @State private var playerCards: [[(name: String, description: String)]] = []
    @State private var playedCards: [(name: String, description: String)] = []
    @State private var cardText: String = "No cards have been played yet."
    @State private var isGameOver: Bool = false // New state to track game over
    
    let allCards: [(name: String, description: String)] = generateDeck()
    
    @Environment(\.presentationMode) var presentationMode // For returning to the start screen
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Player \(currentTurn)'s Turn")
                .font(.title)
            
            Text("Hole \(currentHole)")
                .font(.headline)
            
            Spacer()
            
            // Played Card Notification Text Box
            VStack(alignment: .leading) {
                Text("Last Played Card:")
                    .font(.headline)
                Text(cardText)
                    .font(.subheadline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(10)
            }
            .padding(.vertical)
            
            // Display Player's Cards
            Text("Your Cards:")
            ScrollView(.vertical) {
                VStack {
                    if playerCards.indices.contains(currentTurn - 1) {
                        ForEach(playerCards[currentTurn - 1], id: \.name) { card in
                            Button(action: {
                                playCard(card)
                            }) {
                                VStack(alignment: .leading) {
                                    Text(card.name)
                                        .font(.headline)
                                    Text(card.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    } else {
                        Text("No cards available").italic()
                    }
                }
            }
            
            if !isGameOver {
                Button(action: {
                    replenishCards(for: currentTurn - 1)
                }) {
                    Text("Draw Card")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            
            Button(action: {
                if isGameOver {
                    // Return to lobby screen
                    presentationMode.wrappedValue.dismiss()
                } else {
                    nextTurnOrHole()
                }
            }) {
                Text(isGameOver ? "Back to Lobby" : "Next Player") // Change button text
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isGameOver ? Color.red : Color.blue) // Change button color
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            dealInitialCards()
        }
    }
    
    private func dealInitialCards() {
        var shuffledDeck = allCards.shuffled()
        playerCards = []

        for _ in 0..<players {
            let playerHand = Array(shuffledDeck.prefix(5)) // Deal 5 cards to each player
            playerCards.append(playerHand)
            shuffledDeck.removeFirst(5) // Remove dealt cards from the deck
        }
    }
    
    private func playCard(_ card: (name: String, description: String)) {
        // Ensure the current player's cards exist
        guard playerCards.indices.contains(currentTurn - 1) else {
            cardText = "Error: Player \(currentTurn) has no cards."
            return
        }
        
        // Find the index of the card to be played
        if let index = playerCards[currentTurn - 1].firstIndex(where: { $0.name == card.name }) {
            playerCards[currentTurn - 1].remove(at: index)
            cardText = "Player \(currentTurn) played \(card.name): \(card.description)"
            playedCards.append(card)
            nextTurnOrHole()
        } else {
            // Handle case where the card isn't found
            cardText = "Error: Card not found in Player \(currentTurn)'s hand."
        }
    }
    private func nextTurnOrHole() {
        if currentTurn < players {
            // Move to the next player's turn
            currentTurn += 1
        } else {
            // All players have played; move to the next hole
            currentTurn = 1
            if currentHole < holes {
                currentHole += 1
            } else {
                // End game if all holes are played
                isGameOver = true // Set game over state
                clearAllCards()
            }
        }
        // Replenish cards for the current player at the start of their turn
        replenishCards(for: currentTurn - 1)
    }
    
    private func replenishCards(for playerIndex: Int) {
        guard playerCards.indices.contains(playerIndex) else {
            // Ensure the player index is within bounds
            print("Error: Invalid player index \(playerIndex).")
            return
        }

        var shuffledDeck = allCards.shuffled()
        
        // Try to find a new card that is not in the player's hand or played cards
        if let newCard = shuffledDeck.first(where: { card in
            !playerCards[playerIndex].contains(where: { $0.name == card.name }) &&
            !playedCards.contains(where: { $0.name == card.name })
        }) {
            playerCards[playerIndex].append(newCard)
            shuffledDeck.removeAll(where: { $0.name == newCard.name }) // Remove the drawn card from the deck
        } else {
            print("No valid cards available to replenish for Player \(playerIndex + 1).")
        }
    }
    
    private func clearAllCards() {
        playerCards.removeAll()
        playedCards.removeAll()
        cardText = "Thanks for playing!"
    }
    
    private static func generateDeck() -> [(name: String, description: String)] {
        return [
            ("Mulligan", "Take another shot without penalty."),
            ("Skip a Hole", "Skip this hole without penalty."),
            ("Double Points", "Earn double points on this hole."),
            ("Switch Discs", "Switch discs with another player for this hole."),
            ("Obstruction", "Choose an opponent to play their next shot with an obstruction."),
            ("No Chains", "Opponent's disc must land in the basket without hitting chains."),
            ("Extra Turn", "Take an additional turn."),
            ("Steal Points", "Steal 2 points from an opponent."),
            ("Force Rethrow", "Choose an opponent to rethrow their last shot."),
            ("Move a Disc", "Move an opponent's disc 3 feet from its current spot."),
            ("Tomahawk", "Force an opponent to throw a tomahawk on the upcoming drive or approach."),
            ("Roll It!", "Force an opponent to throw a roller on the upcoming drive or approach."),
            ("Choose Disc", "Choose one of your opponent's discs. That disc must be used on their next shot."),
            ("Fire in the Hole!", "Force an opponent to throw a grenade on the upcoming drive or approach."),
            ("Caddy", "Force an opponent to carry your discs for the upcoming hole."),
            ("Heckle", "Heckle an opponent during one of their shots."),
            ("Cancel Card", "Cancel any card just played."),
            ("Mulligan", "Take another shot without penalty."),
            ("Skip a Hole", "Skip this hole without penalty."),
            ("Double Points", "Earn double points on this hole."),
            ("Switch Discs", "Switch discs with another player for this hole."),
            ("Obstruction", "Choose an opponent to play their next shot with an obstruction."),
            ("No Chains", "Opponent's disc must land in the basket without hitting chains."),
            ("Extra Turn", "Take an additional turn."),
            ("Steal Points", "Steal 2 points from an opponent."),
            ("Force Rethrow", "Choose an opponent to rethrow their last shot."),
            ("Move a Disc", "Move an opponent's disc 3 feet from its current spot."),
            ("Tomahawk", "Force an opponent to throw a tomahawk on the upcoming drive or approach."),
            ("Roll It!", "Force an opponent to throw a roller on the upcoming drive or approach."),
            ("Choose Disc", "Choose one of your opponent's discs. That disc must be used on their next shot."),
            ("Fire in the Hole!", "Force an opponent to throw a grenade on the upcoming drive or approach."),
            ("Caddy", "Force an opponent to carry your discs for the upcoming hole."),
            ("Heckle", "Heckle an opponent during one of their shots."),
            ("Cancel Card", "Cancel any card just played."),
            ("Mulligan", "Take another shot without penalty."),
            ("Skip a Hole", "Skip this hole without penalty."),
            ("Double Points", "Earn double points on this hole."),
            ("Switch Discs", "Switch discs with another player for this hole."),
            ("Obstruction", "Choose an opponent to play their next shot with an obstruction."),
            ("No Chains", "Opponent's disc must land in the basket without hitting chains."),
            ("Extra Turn", "Take an additional turn."),
            ("Steal Points", "Steal 2 points from an opponent."),
            ("Force Rethrow", "Choose an opponent to rethrow their last shot."),
            ("Move a Disc", "Move an opponent's disc 3 feet from its current spot."),
            ("Tomahawk", "Force an opponent to throw a tomahawk on the upcoming drive or approach."),
            ("Roll It!", "Force an opponent to throw a roller on the upcoming drive or approach."),
            ("Choose Disc", "Choose one of your opponent's discs. That disc must be used on their next shot."),
            ("Fire in the Hole!", "Force an opponent to throw a grenade on the upcoming drive or approach."),
            ("Caddy", "Force an opponent to carry your discs for the upcoming hole."),
            ("Heckle", "Heckle an opponent during one of their shots."),
            ("Cancel Card", "Cancel any card just played.")
        ]
    }
}
