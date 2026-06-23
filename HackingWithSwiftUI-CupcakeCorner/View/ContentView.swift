//
//  ContentView.swift
//  HackingWithSwiftUI-CupcakeCorner
//
//  Created by Michael Jones on 20/06/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    Picker("Select your cake topping?", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section() {
                    Toggle("Any Special Requests?", isOn: $order.specialRequestEnabled.animation())
                    
                    if order.specialRequestEnabled {
                        Toggle("Extra Frosting?", isOn: $order.extraFrosting)
                        Toggle("Add Sprinkles?", isOn: $order.addSprinkles)
                    }
                }
                
                Section() {
                    NavigationLink("Delivery Details") {
                        AddressView(order: order)
                    }
                }

            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
