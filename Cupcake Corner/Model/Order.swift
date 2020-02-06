//
//  Order.swift
//  Cupcake Corner
//
//  Created by Davron on 1/5/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import Foundation

class Order: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, state, city, zip
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    @Published var type = 0
    static let states = [ "AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    @Published var state = 0    
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if (name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty) {
            return false
        }
        
        if name.trimmingCharacters(in: .whitespaces).count == 0 ||
            streetAddress.trimmingCharacters(in: .whitespaces).count == 0 ||
            city.trimmingCharacters(in: .whitespaces).count == 0 ||
            zip.trimmingCharacters(in: .whitespaces).count == 0 {
            return false
        }
        
        if (Int(zip) == nil) || zip.count < 5 || zip.count > 5{
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
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity)/2
        }
        
        return cost
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        state = try container.decode(Int.self, forKey: .state)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    init() {}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(state, forKey: .state)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }

}
