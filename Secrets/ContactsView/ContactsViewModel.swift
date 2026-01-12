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
    
    init(friends: [Friend]) {
        self.friends = friends
    }
    
    func saveFriendTapped(name: String, key: String) {
        let newFriend = Friend(name: name, publicKeyBase64: key)
        friends.append(newFriend)
    }
}
