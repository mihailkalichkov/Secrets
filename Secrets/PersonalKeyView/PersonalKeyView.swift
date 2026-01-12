//
//  PersonalKeyView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

@MainActor protocol PersonalKeyViewModelProtocol: ObservableObject {
    var personalKey: String { get }
}

struct PersonalKeyView<ViewModel: PersonalKeyViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @State private var showCode = false
    
    private let filter = CIFilter.qrCodeGenerator()
    private let context = CIContext()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("My Public key")
                .font(.title)
            
            qrCode
            
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
    
    @ViewBuilder var qrCode: some View {
        generateQRCode(from: viewModel.personalKey)
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
        
        Text("Scan QR code to share your code with a friend")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    private func generateQRCode(from string: String) -> Image {
        filter.message = Data(string.utf8)
        
        guard let outputImage = filter.outputImage,
              let cgImg = context.createCGImage(outputImage, from: outputImage.extent)
        else {
            return Image(systemName: "xmark.circe")
        }
        
        return Image(cgImg, scale: 1, label: Text("Test"))
    }
}
