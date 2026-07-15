//
//  CheckoutView.swift
//  HackingWithSwiftUI-CupcakeCorner
//
//  Created by Michael Jones on 22/06/2026.
//

/*
 Challenges
 
 1. Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.

 2. If our call to placeOrder() fails – for example if there is no internet connection – show an informative alert for the user. To test this, try commenting out the request.httpMethod = "POST" line in your code, which should force the request to fail.
 
 3. For a more challenging task, try updating the Order class so it saves data such as the user's delivery address to UserDefaults. This takes a little thinking, because @AppStorage won't work here, and you'll find getters and setters cause problems with Codable support. Can you find a middle ground?
*/

import SwiftUI

struct CheckoutView: View {
    @Bindable var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var errorMessage = ""
    @State private var showingError = false
    
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
                    /// Task is used to create a new unit of asynchronous work. When using Task, you can starting a new concurrent task. This allows you to run code asynchronously without blocking the main thread (which keeps the UI responsive).
                    Task {
                        await placeOrder() /// The 'await' keyword is used to call an asynchronous function 'placeOrder'. This function will run asynchronously within the new task.
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
        .alert("Whoops", isPresented: $showingError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
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
            errorMessage = "Checkout Failed: \(error.localizedDescription)"
            showingError = true
        }
        
    }
}

#Preview {
    CheckoutView(order: Order())
}
