//
//  LandingView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI

struct LandingView: View {
    private let cryptoService = CryptoService()
    // persist friends. Right now they erase on every startup
    private var friends = [Friend]()
    
    var body: some View {
        TabView {
            PersonalKeyView(viewModel: PersonalKeyViewModel(cryptoService: cryptoService))
                .tabItem { Label("My Key", systemImage: "key") }
            
            ContactsView(viewModel: ContactsViewModel(friends: friends,
                                                      cryptoService: cryptoService))
                .tabItem { Label("Contacts", systemImage: "person.2") }
        }
    }
}
