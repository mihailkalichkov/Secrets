//
//  PersonalKeyViewModel.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import Foundation
import Combine

class PersonalKeyViewModel: PersonalKeyViewModelProtocol {
    @Published var personalKey: String
    
    let cryptoService: CryptoServiceProtocol
    
    init(cryptoService: CryptoServiceProtocol) {
        self.cryptoService = cryptoService
        self.personalKey = cryptoService.exportPublicKey()
    }
}
