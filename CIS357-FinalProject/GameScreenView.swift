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
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Player \(currentTurn)'s Turn")
                .font(.title)
            
            Text("Hole \(currentHole)")
                .font(.headline)
            
            Spacer()
            
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
        cardText = "Random Card: \(Int.random(in: 1...100))" // Replace with actual card logic
    }
    
    private func nextTurn() {
        if currentTurn < players {
            currentTurn += 1
        } else {
            currentTurn = 1
            if currentHole < holes {
                currentHole += 1
            } else {
                // End of the game logic
                cardText = "Game Over!"
            }
        }
    }
}
