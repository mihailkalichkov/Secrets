//
//  Friend.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import Foundation
import CryptoKit

struct Friend: Identifiable, Codable {
    var id = UUID()
    let name: String
    let publicKeyBase64: String
    
    var publicKey: P256.KeyAgreement.PublicKey? {
        // handle errors
        guard let data = Data(base64Encoded: publicKeyBase64) else { return nil }
        return try? P256.KeyAgreement.PublicKey(rawRepresentation: data)
    }
}
