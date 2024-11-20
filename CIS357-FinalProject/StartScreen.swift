//
//  StartScreen.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 11/20/24.
//
import SwiftUI

struct StartScreenView: View {
    @State private var selectedPlayers: String = "1"
    @State private var selectedHoles: String = "9"
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Disc Golf Cards")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            // Player Selection
            VStack {
                Text("Select Players")
                Picker("Players", selection: $selectedPlayers) {
                    ForEach(["1", "2", "3", "4"], id: \.self) { player in
                        Text(player).tag(player)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Hole Selection
            VStack {
                Text("Select Holes")
                Picker("Holes", selection: $selectedHoles) {
                    ForEach(["9", "18"], id: \.self) { hole in
                        Text(hole).tag(hole)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Start Button
            NavigationLink(
                destination: GameScreenView(players: Int(selectedPlayers) ?? 1, holes: Int(selectedHoles) ?? 9),
                label: {
                    Text("Start Game")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .disabled(selectedPlayers.isEmpty || selectedHoles.isEmpty)
            
            Spacer()
        }
        .padding()
    }
}
