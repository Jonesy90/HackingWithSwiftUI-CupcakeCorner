//
//  CheckoutView.swift
//  HackingWithSwiftUI-CupcakeCorner
//
//  Created by Michael Jones on 22/06/2026.
//

import SwiftUI

struct CheckoutView: View {
    @Bindable var order: Order
    @State private var viewModel: ViewModel
    
    init(order: Order) {
        self.order = order
        _viewModel = State(initialValue: ViewModel(order: order))
    }
    
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
                
                Text("Your total cost is: \(viewModel.order.cost, format: .currency(code: "GBP"))")
                    .font(.title)
                
                Button("Place Order") {
                    /// Task is used to create a new unit of asynchronous work. When using Task, you can starting a new concurrent task. This allows you to run code asynchronously without blocking the main thread (which keeps the UI responsive).
                    Task {
                        await viewModel.placeOrder() /// The 'await' keyword is used to call an asynchronous function 'placeOrder'. This function will run asynchronously within the new task.
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank You!", isPresented: $viewModel.showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(viewModel.confirmationMessage)
        }
        .alert("Whoops", isPresented: $viewModel.showingError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
