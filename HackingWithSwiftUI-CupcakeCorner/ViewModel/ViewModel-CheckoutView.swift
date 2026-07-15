//
//  ViewModel-CheckoutView.swift
//  HackingWithSwiftUI-CupcakeCorner
//
//  Created by Michael Jones on 15/07/2026.
//

import Foundation

extension CheckoutView {
    @Observable
    class ViewModel {
        var order: Order
        
        var confirmationMessage: String = ""
        var showingConfirmation: Bool = false
        
        var errorMessage: String = ""
        var showingError: Bool = false
        
        init(order: Order) {
            self.order = order
        }
        
        func placeOrder() async {
            guard let encoded = try? JSONEncoder().encode(order) else {
                print("Failed to encode order")
                return
            }
            
            let url = URL(string: "https://reqres.in/api/cupcakes")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            do {
                let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
                let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
                confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                showingConfirmation = true
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
}
