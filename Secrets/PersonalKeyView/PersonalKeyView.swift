//
//  PersonalKeyView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI

@MainActor protocol PersonalKeyViewModelProtocol: ObservableObject {
    var personalKey: String { get }
}

struct PersonalKeyView<ViewModel: PersonalKeyViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @State private var showCode = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("My Public key")
                .font(.title)
            
            Text("QR code here")
            
            Text("Scan QR code to share your code with a friend")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Button("Copy Key to Clipboard") {
                showCode = true
                UIPasteboard.general.string = viewModel.personalKey
            }
            
            if showCode {
                Text(viewModel.personalKey)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 24)
            }
        }
    }
}
