//
//  SignUpScreenView.swift
//  CIS357-FinalProject
//
//  Created by Kyle J. Fink on 12/1/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpScreenView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isSignedUp: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            // Email Field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Password Field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Confirm Password Field
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            // Sign Up Button
            Button(action: {
                signUpUser()
            }) {
                Text("Sign Up")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            // Navigation Link to Login
            NavigationLink("Already have an account? Log In", destination: LoginScreenView())
                .font(.footnote)
        }
        .padding()
    }
    
    private func signUpUser() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isSignedUp = true
            }
        }
    }
}
