//
//  StartScreen.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 11/20/24.
//
import SwiftUI

struct StartScreenView: View {
    @State private var selectedPlayers: Int = 1
    @State private var selectedHoles: Int = 9
    @State private var isReady: Bool = false

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
                    ForEach(1...8, id: \""self) { player in
                        Text("\(player)").tag(player)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            // Hole Selection
            VStack {
                Text("Select Holes")
                Picker("Holes", selection: $selectedHoles) {
                    ForEach([9, 18], id: \""self) { hole in
                        Text("\(hole)").tag(hole)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Button(action: {
                isReady = true
            }) {
                Text("Ready")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedPlayers == 0 || selectedHoles == 0)
            .sheet(isPresented: $isReady) {
                GameScreenView(players: selectedPlayers, holes: selectedHoles)
            }
            
            Spacer()
        }
        .padding()
    }
}