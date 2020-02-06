//
//  CheckoutView.swift
//  Cupcake Corner
//
//  Created by Davron on 1/5/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingNetworkError = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image(decorative: "cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order"){
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Checkout", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingNetworkError) {
            Alert(title: Text("No internet connection"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {

        // 1. Convert our current order object into some JSON data that can be sent
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        // 2. Prepare a URLRequest to send our encoded data as JSON
        //  https://reqres.in – it lets us send any data we want, and will automatically send it back. no need oun server
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        // 3. Run that request and process the response
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.confirmationMessage = "\(error?.localizedDescription.lowercased() ?? "Unknown error")."
                self.showingNetworkError = true
                self.showingConfirmation = false
                //print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            let decoder = JSONDecoder()
            
            if let decodedOrder = try? decoder.decode(Order.self, from: data){
                self.showingConfirmation = true
                self.confirmationMessage = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingNetworkError = false
            }
            else {
                print("Invalid response from server")
            }
            
        }.resume()
    
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
