//
//  LandingView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI

struct LandingView: View {
    private let cryptoService = CryptoService()
    private let friendsService = FriendsService()
    
    var body: some View {
        TabView {
            PersonalKeyView(viewModel: PersonalKeyViewModel(cryptoService: cryptoService))
                .tabItem { Label("My Key", systemImage: "key") }
            
            ContactsView(viewModel: ContactsViewModel(friendsService: friendsService,
                                                      cryptoService: cryptoService))
                .tabItem { Label("Contacts", systemImage: "person.2") }
            
            DecryptView(viewModel: DecryptViewModel(friendsService: friendsService,
                                                    cryptoService: cryptoService))
                .tabItem { Label("Read", systemImage: "lock.open")  }
        }
    }
}
