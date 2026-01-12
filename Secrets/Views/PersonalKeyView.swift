//
//  PersonalKeyView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI

struct PersonalKeyView: View {
    @State private var myKey = CryptoService.shared.exportPublicKey()
    
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
                UIPasteboard.general.string = myKey
            }
            
            if showCode {
                Text(myKey)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
