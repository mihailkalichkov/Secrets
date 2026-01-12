//
//  ContactsViewModel.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import Foundation
import Combine

class ContactsViewModel: ContactsViewModelProtocol {
    @Published var friends: [Friend] = []
    @Published var encryptedMessage = ""
    
    let cryptoService: any CryptoServiceProtocol
    let friendsService: any FriendsServiceProtocol
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(friendsService: any FriendsServiceProtocol, cryptoService: any CryptoServiceProtocol) {
        self.friendsService = friendsService
        self.cryptoService = cryptoService
        
        friendsService.friendsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.friends, on: self)
            .store(in: &subscribers)
    }
    
    func saveFriendTapped(name: String, key: String) {
        let newFriend = Friend(name: name, publicKeyBase64: key)
        friendsService.addFriend(newFriend)
    }
    
    func encryptMessageTapped(friend: Friend, message: String) {
        if let key = friend.publicKey,
           let encryptedMessage = try? cryptoService.encrypt(message: message, publicKey: key) {
            self.encryptedMessage = encryptedMessage
        }
    }
}
