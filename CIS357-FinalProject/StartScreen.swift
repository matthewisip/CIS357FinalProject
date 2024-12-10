//
//  StartScreen.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 11/20/24.
//
import SwiftUI

struct StartScreenView: View {
    @State private var selectedPlayers: String = "2"
    @State private var selectedHoles: String = "9"
    @State private var lobbyName: String = ""
    @State private var invitedPlayers: [String] = []
    @State private var maxPlayers: Int = 4
    
    // NavigationStack
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Rip-It-Revenge")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("A Disc Golf Card Game")
                .font(.subheadline)
                .fontWeight(.bold)
            
            Spacer()
            // Lobby Name Field
            TextField("Enter Lobby Name", text: $lobbyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            // Player Selection
            VStack {
                Text("Select Players")
                Picker("Players", selection: $selectedPlayers) {
                    ForEach(["2", "3", "4", "5", "6", "7", "8"], id: \.self) { player in
                        Text(player).tag(player)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedPlayers) { _ in
                        adjustInvitedPlayers()
                }
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
            
            /*Button(action: {
                logout()
            }) {
                Text("Logout")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedPlayers.isEmpty || selectedHoles.isEmpty)*/
            
            Spacer()
        }
        .padding()
    }
    private func addRandomPlayer() {
        let randomPlayer = "Player \(Int.random(in: 1...100))"
        
        if let maxPlayers = Int(selectedPlayers),
           !invitedPlayers.contains(randomPlayer) && invitedPlayers.count < maxPlayers {
            invitedPlayers.append(randomPlayer)
        }
    }
    private func adjustInvitedPlayers() {
        if let maxPlayers = Int(selectedPlayers), invitedPlayers.count > maxPlayers {
            invitedPlayers = Array(invitedPlayers.prefix(maxPlayers))
        }
    }
    // Logout function to navigate back to the login screen
    private func logout() {
        // Clear any data or reset state if necessary
        invitedPlayers.removeAll()  // Example, clear invited players
        
        // Navigate back to the login screen by resetting the navigation path
        // Reset the navigation path to go directly to the login screen
        navigationPath.removeLast(navigationPath.count)
    }
}
