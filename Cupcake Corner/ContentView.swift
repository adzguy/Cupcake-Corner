//
//  ContentView.swift
//  Cupcake Corner
//
//  Created by Davron on 1/4/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var email = ""
    
    var disabledForm: Bool {
        username.count < 5 || email.count < 5 
        
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            Section{
                Button("Create Account") {
                    print("Creating account...")
                }
            }
        .disabled(disabledForm)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
