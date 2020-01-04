//
//  ContentView.swift
//  Cupcake Corner
//
//  Created by Davron on 1/4/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        // Step 1. Creaing URL we want to read
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        // Step 2. Wrapping that in a URLRequest, which allows us to configure how the URL should be accessed
        let request = URLRequest(url: url)
        
        // Step 3. Create and start a network task from that URL request.
        URLSession.shared.dataTask(with: request) {data, request, error in
            // Step 4. Handle the result of that networking task
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    // we have good data - go back to the mian thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.results
                    }
                    
                    // everything is good, so we can exit
                    return
                }
            }
            
            // if we are still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
