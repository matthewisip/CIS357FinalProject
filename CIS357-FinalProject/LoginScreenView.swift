//
//  LoginScreenView.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 12/1/24.
//
import SwiftUI
import Firebase

struct LoginScreenView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        if isLoggedIn {
            StartScreenView() // Navigate to Lobby after login
        } else {
            VStack(spacing: 16) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Email Field
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                // Login Button
                Button(action: {
                    loginUser()
                }) {
                    Text("Login")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // Navigation Link to Sign-Up
                NavigationLink("Don't have an account? Sign Up", destination: SignUpScreenView())
                    .font(.footnote)
            }
            .padding()
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isLoggedIn = true
            }
        }
    }
}