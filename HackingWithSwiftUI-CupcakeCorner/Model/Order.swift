//
//  Order.swift
//  HackingWithSwiftUI-CupcakeCorner
//
//  Created by Michael Jones on 22/06/2026.
//

import Foundation

@Observable
class Order: Codable {
    
    /// CodingKeys is a special enum that is a part of the Codable protocol.
    /// When a class conforms to Codable, Swift can use CodingKeys to know how to encode and decode the properties of the type to and from formats (e.g., JSON).
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _postcode = "postcode"
    }
    
    static let types = ["Vanilla", "Chocolate", "Red Velvet", "Blueberry"]
    
    var type = 0
    var quantity = 3
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    /// The 'didSet' block runs every time the property is set to a new value or the same value as before.
    /// When the name is updated, the new value is saved to UserDefaults using the key "name".
    var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    var streetAddress: String {
        didSet {
            UserDefaults.standard.set(streetAddress, forKey: "streetAddress")
        }
    }
    var city: String {
        didSet {
            UserDefaults.standard.set(city, forKey: "city")
        }
    }
    var postcode: String {
        didSet {
            UserDefaults.standard.set(postcode, forKey: "postcode")
        }
    }
    
    var hasValidAddress: Bool {
        if name.isReallyEmpty || streetAddress.isReallyEmpty || city.isReallyEmpty || postcode.isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // £2 per cake
        var cost = Decimal(quantity) * 2
        
        // Complicated cakes cost more.
        cost += Decimal(type) / 2
        
        // £1 per cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // £0.50 per cake for sprinkles.
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    /// A custom initialiser to setup the Order object when it's first created.
    /// For each property, it tries to load a stored value from UserDefaults using the corresponding key.
    /// If nothing is stored yet, an empty string will be returned.
    init() {
        name = UserDefaults.standard.string(forKey: "name") ?? ""
        streetAddress = UserDefaults.standard.string(forKey: "streetAddress") ?? ""
        city = UserDefaults.standard.string(forKey: "city") ?? ""
        postcode = UserDefaults.standard.string(forKey: "postcode") ?? ""
    }
}
