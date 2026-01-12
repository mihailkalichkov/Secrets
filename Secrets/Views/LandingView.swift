//
//  LandingView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI

struct LandingView: View {
    private let cryptoService = CryptoService()
    
    var body: some View {
        TabView {
            PersonalKeyView(viewModel: PersonalKeyViewModel(cryptoService: cryptoService))
        }
    }
}
