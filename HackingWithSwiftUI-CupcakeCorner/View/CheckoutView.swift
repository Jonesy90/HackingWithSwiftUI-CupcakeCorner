//
//  CheckoutView.swift
//  HackingWithSwiftUI-CupcakeCorner
//
//  Created by Michael Jones on 22/06/2026.
//

import SwiftUI

struct CheckoutView: View {
    @Bindable var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                /// AsyncImage is a SwiftUI view that asynchronously loads and displays an image from a URL.
                /// This is useful for loading images from the web without blocking the UI.
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is: \(order.cost, format: .currency(code: "GBP"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank You!", isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    private func placeOrder() async {
        /// Tries to convert the order object into JSON.
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url) /// This is used to configure how you want to communicated with the web server (e.g., HTTP).
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") /// Sets the HTTP Header of the request. This tells the server that the body of the HTTP request is formatted as JSON.
        request.httpMethod = "POST" /// Sets the HTTP method of the request to POST (a post request is typically used to send data to a server).
        
        /// This block of code attempts to send the order to the server.
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded) /// Asynchronously uploads the data to the server using the given request.
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data) /// Decoding the servers response of the Order type.
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            print("Checkout Failed: \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    CheckoutView(order: Order())
}
