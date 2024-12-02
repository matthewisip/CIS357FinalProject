//
//  LobbyScreenView.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 12/1/24.
//

import SwiftUI

struct LobbyScreenView: View {
    @State private var lobbyName: String = ""
    @State private var invitedPlayers: [String] = []
    @State private var selectedHoles: Int = 9
    @State private var maxPlayers: Int = 4
    @State private var isGameReady: Bool = false
    @State private var showGameScreen: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Lobby Setup")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            // Lobby Name Field
            TextField("Enter Lobby Name", text: $lobbyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Invite Players Section
            VStack(alignment: .leading) {
                Text("Invite Players:")
                ScrollView {
                    ForEach(invitedPlayers, id: \.self) { player in
                        Text(player)
                    }
                }
                .frame(height: 100)
                
                Button(action: {
                    addRandomPlayer()
                }) {
                    Text("Invite Random Player")
                        .font(.footnote)
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            // Game Settings
            VStack {
                // Number of Holes
                Picker("Holes", selection: $selectedHoles) {
                    Text("9").tag(9)
                    Text("18").tag(18)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Max Players
                Stepper("Max Players: \(maxPlayers)", value: $maxPlayers, in: 1...8)
            }
            
            // Ready Button
            Button(action: {
                isGameReady = true
                showGameScreen = true
            }) {
                Text("Ready")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isGameReady ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(lobbyName.isEmpty || invitedPlayers.isEmpty)
            
            Spacer()
        }
        .padding()
        .background(
            NavigationLink(
                destination: GameScreenView(players: maxPlayers, holes: selectedHoles),
                isActive: $showGameScreen,
                label: { EmptyView() }
            )
        )
    }
    
    private func addRandomPlayer() {
        let randomPlayer = "Player \(Int.random(in: 1...100))"
        if !invitedPlayers.contains(randomPlayer) && invitedPlayers.count < maxPlayers {
            invitedPlayers.append(randomPlayer)
        }
    }
}
