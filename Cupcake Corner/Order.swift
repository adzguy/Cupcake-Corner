//
//  Order.swift
//  Cupcake Corner
//
//  Created by Davron on 1/5/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import Foundation

class Order: ObservableObject {
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSpinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSpinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += Double(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += 1
        }
        
        // $0.50/cake for sprinkles
        if addSpinkles {
            cost += 0.5
        }
        
        return cost
    }

}