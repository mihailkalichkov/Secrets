//
//  DecryptView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI

@MainActor protocol DecryptViewModelProtocol: ObservableObject {
    var friends: [Friend] { get }
    var cipherInput: String { get set }
    var decryptedMessage: String? { get }
    var authorName: String? { get }
    func readMessageTapped()
}

struct DecryptView<ViewModel: DecryptViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Decryptor")
                .font(.title2)
            
            TextEditor(text: $viewModel.cipherInput)
                .frame(height: 100)
                .border(.gray, width: 1)
                .padding()
                .overlay {
                    Text("Paste text here...").opacity(viewModel.cipherInput.isEmpty ? 0.5 : 0)
                }
            
            Button("Read Message") {
                viewModel.readMessageTapped()
            }
            .buttonStyle(.borderedProminent)
            
            decryptedMessage
        }
    }
    
    @ViewBuilder var decryptedMessage: some View {
        if let message = viewModel.decryptedMessage,
           let author = viewModel.authorName {
            VStack {
                Divider()
                Text("Message from: \(author)")
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                Text(message)
                    .font(.title3)
                    .padding()
                    .background(.green.opacity(0.3))
                    .cornerRadius(10)
            }
            .transition(.scale)
        }
    }
}
