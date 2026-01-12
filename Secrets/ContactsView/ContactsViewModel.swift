//
//  ContactsViewModel.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import Foundation
import Combine

class ContactsViewModel: ContactsViewModelProtocol {
    @Published var friends: [Friend]
    @Published var encryptedMessage = ""
    
    let cryptoService: CryptoServiceProtocol
    
    init(friends: [Friend], cryptoService: CryptoServiceProtocol) {
        self.friends = friends
        self.cryptoService = cryptoService
    }
    
    func saveFriendTapped(name: String, key: String) {
        let newFriend = Friend(name: name, publicKeyBase64: key)
        friends.append(newFriend)
    }
    
    func encryptMessageTapped(friend: Friend, message: String) {
        if let key = friend.publicKey,
           let encryptedMessage = try? cryptoService.encrypt(message: message, publicKey: key) {
            self.encryptedMessage = encryptedMessage
        }
    }
}
