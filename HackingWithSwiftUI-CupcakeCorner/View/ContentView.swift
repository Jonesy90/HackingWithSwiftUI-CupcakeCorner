//
//  ContentView.swift
//  HackingWithSwiftUI-CupcakeCorner
//
//  Created by Michael Jones on 20/06/2026.
//

import SwiftUI

struct ContentView: View {
//    @State private var order = Order()
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    Picker("Select your cake topping?", selection: $viewModel.order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(viewModel.order.quantity)", value: $viewModel.order.quantity, in: 3...20)
                }
                
                Section() {
                    Toggle("Any Special Requests?", isOn: $viewModel.order.specialRequestEnabled.animation())
                    
                    if viewModel.order.specialRequestEnabled {
                        Toggle("Extra Frosting?", isOn: $viewModel.order.extraFrosting)
                        Toggle("Add Sprinkles?", isOn: $viewModel.order.addSprinkles)
                    }
                }
                
                Section() {
                    NavigationLink("Delivery Details") {
                        AddressView(order: viewModel.order)
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
