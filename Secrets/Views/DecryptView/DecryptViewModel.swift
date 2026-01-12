//
//  DecryptViewModel.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import Foundation
import Combine

class DecryptViewModel: DecryptViewModelProtocol {
    @Published var friends: [Friend] = []
    
    @Published var cipherInput: String = ""
    @Published var decryptedMessage: String? = nil
    @Published var authorName: String? = nil
    
    let cryptoService: CryptoServiceProtocol
    let friendsService: any FriendsServiceProtocol
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(friendsService: any FriendsServiceProtocol, cryptoService: CryptoServiceProtocol) {
        self.friendsService = friendsService
        self.cryptoService = cryptoService
        
        friendsService.friendsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.friends, on: self)
            .store(in: &subscribers)
    }
    
    func readMessageTapped() {
        friends.forEach { friend in
            if let key = friend.publicKey,
               let decrypted = try? cryptoService.decrypt(message: cipherInput, friendPublicKey: key) {
                decryptedMessage = decrypted
                authorName = friend.name
                return
            }
        }
    }
}

