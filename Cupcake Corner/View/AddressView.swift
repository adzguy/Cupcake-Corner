//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by Davron on 1/5/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    
    @ObservedObject var order: Order

    var body: some View {
        
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    Picker("Select State", selection: $order.state) {
                        ForEach(0..<Order.states.count, id: \.self){
                            Text(Order.states[$0])
                        }
                    }
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }
                
                Section {
                    NavigationLink(destination: CheckoutView(order: order)) {
                        Text("Checkout")
                    }
                    .disabled(order.hasValidAddress == false)
                }
            }
            .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
