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
    @State private var cardText: String = ""
    @State private var cardDeck: [(name: String, description: String)] = generateDeck()

    @State private var locks: [Bool] = Array(repeating: false, count: 8)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Player \(currentTurn)'s Turn")
                .font(.title)
            
            Text("Hole \(currentHole)")
                .font(.headline)
            
            Spacer()
            
            // Players Lock Status
            HStack {
                ForEach(0..<players, id: \""self) { i in
                    VStack {
                        Text("Player \(i + 1)")
                            .font(.footnote)
                        Circle()
                            .fill(locks[i] ? Color.red : Color.green)
                            .frame(width: 20, height: 20)
                    }
                }
            }

            Text(cardText.isEmpty ? "Draw a card" : cardText)
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Spacer()
            
            Button(action: {
                drawCard()
            }) {
                Text("Draw Card")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(locks[currentTurn - 1])
            
            Button(action: {
                nextTurn()
            }) {
                Text("Next Player")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }

    private func drawCard() {
        guard !cardDeck.isEmpty else {
            cardText = "No more cards in the deck!"
            return
        }

        let randomIndex = Int.random(in: 0..<cardDeck.count)
        let selectedCard = cardDeck[randomIndex]
        cardText = "\(selectedCard.name): \(selectedCard.description)"
        cardDeck.remove(at: randomIndex)
        locks[currentTurn - 1] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            locks[currentTurn - 1] = false
        }
    }

    private func nextTurn() {
        if currentTurn < players {
            currentTurn += 1
        } else {
            currentTurn = 1
            if currentHole < holes {
                currentHole += 1
                cardDeck += generateDeck()
            } else {
                cardText = "Game Over!"
            }
        }
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
            ("Choose Disc", "Choose one of your opponent's discs. That disc must be used on his/her next shot. "),
            ("Fire in the Hole!", "Force an opponent to throw a grenade on the upcoming drive or approach."),
            ("Caddy", "Force an opponent to carry your discs for the upcoming hole."),
            ("nnnnNunan!", "Heckle an opponent during one of his/her shots. Reveal and discard this card after. "),
            ("No Way", "Cancel any card just played. That card goes back into the game deck. Shuffle the deck."),
            ("Really Good Luck", "If you are holding this card at the end of the round, subtract 2 strokes from your final score. If you are playing for skins, add 1 skin instead."),
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
            ("Choose Disc", "Choose one of your opponent's discs. That disc must be used on his/her next shot. "),
            ("Fire in the Hole!", "Force an opponent to throw a grenade on the upcoming drive or approach."),
            ("Caddy", "Force an opponent to carry your discs for the upcoming hole."),
            ("nnnnNunan!", "Heckle an opponent during one of his/her shots. Reveal and discard this card after. "),
            ("No Way", "Cancel any card just played. That card goes back into the game deck. Shuffle the deck."),
            ("Really Good Luck", "If you are holding this card at the end of the round, subtract 2 strokes from your final score. If you are playing for skins, add 1 skin instead.")
        ]
    }
}
