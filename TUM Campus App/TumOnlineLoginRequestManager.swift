//
//  TumOnlineLoginRequestManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Sweeft
import SWXMLHash
import Foundation
import Security

class TumOnlineLoginRequestManager {
    
    enum State {
        case creatingToken(lrzID: String)
        case waiting(lrzID: String, token: String)
        case loggedIn(lrzID: String, token: String)
    }
    
    let config: Config

    var state: State? {
        switch PersistentUser.value {
        case .requestingToken(let lrzID):
            return .creatingToken(lrzID: lrzID)
        case .some(let lrzID, let token, state: .awaitingConfirmation):
            return .waiting(lrzID: lrzID, token: token)
        case .some(let lrzID, token: let token, state: .loggedIn):
            return .loggedIn(lrzID: lrzID, token: token)
        default:
            return nil
        }
    }
    
    var token: String? {
        
        switch state {
        case .some(.waiting(_, let token)):
            return token
        case .some(.loggedIn(_, let token)):
            return token
        default:
            return nil
        }
    }
    
    var lrzID : String? {
        
        switch state {
        case .some(.creatingToken(let lrzID)):
            return lrzID
        case .some(.waiting(let lrzID, _)):
            return lrzID
        case .some(.loggedIn(let lrzID, _)):
            return lrzID
        default:
            return nil
        }
    }
    
    init(config: Config) {
        self.config = config
    }
    
    private func confirm(token: String) -> Response<Bool> {
        return config.tumOnline.doRepresentedRequest(to: .tokenConfirmation,
                                                     queries: ["pToken" : token]).map { (xml: XMLIndexer) in
                                                        
            return xml["confirmed"].element?.text == "true"
        }.onSuccess { success in
            if success {
                try? self.uploadSecret(token: token)
                self.loginSuccesful()
            } else {
                self.logOut()
            }
        }
    }
    
    private func uploadSecret(token: String) throws -> Response<Bool> {
        let tag = "de.tum.campusapp.keys.secret".data(using: .utf8)!
        let attributes: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeRSA, kSecAttrKeySizeInBits as String: 1024, kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: true, kSecAttrApplicationTag as String: tag]]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            return .errored(with: .cannotPerformRequest)
        }
        
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            return .errored(with: .cannotPerformRequest)
        }
        
        guard let data: Data = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? else {
            return .errored(with: .cannotPerformRequest)
        }
        
        let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA1
        
        let date = Date().description
        let salt = Int.random(in: Int.min...Int.max).description
        let device = UIDevice.current.description
        
        let message = "\(date)\(salt)\(device)"
        
        guard let signature = SecKeyCreateSignature(privateKey, algorithm, message.data! as CFData, &error) as Data? else {
            return .errored(with: .cannotPerformRequest)
        }
        
        let result: Promise<Bool, APIError> = config.tumOnline.doRepresentedRequest(to: .secretUpload, queries: ["pToken" : token, "pSecret" : data.base64EncodedString()]).map { (xml: XMLIndexer) in
            return xml["confirmed"].element?.text == "true"
        }
        let jsonBody = ["signature": signature.base64EncodedString(), "date": date, "rand": salt, "device": device, "publicKey": data.base64EncodedString()].json
        
        let result2: Promise<Bool, APIError> = config.tumCabe.doJSONRequest(with: .post, to: .registerDevice, arguments: [ : ], body: jsonBody).map { (json: JSON) in
                return true
        }
        
        return result
    }
    
    private func start(id: String) -> Response<Bool> {
        let tokenName = "TCA - \(UIDevice.current.name)"
        return config.tumOnline.doRepresentedRequest(to: .tokenRequest,
                                                     queries: [
                                                        "pUsername" : id,
                                                        "pTokenName" : tokenName,
                                                     ]).flatMap { (xml: XMLIndexer) in
            
                guard let token = xml["token"].element?.text else {
                    return .successful(with: false)
                }
                self.loginStarted(with: token)
                return self.confirm(token: token)
        }
    }
    
    func fetch() -> Response<Bool> {
        return state.map { state in
            switch state {
            case .creatingToken(let id):
                return self.start(id: id)
            case .waiting(_, let token):
                return self.confirm(token: token)
            case .loggedIn(_, let token):
                return self.confirm(token: token)
            }
        } ?? .errored(with: .cannotPerformRequest)
    }
    
    func loginStarted(with token: String) {
        guard case .some(.creatingToken(let lrzID)) = self.state else {
            return
        }
        PersistentUser.value = .some(lrzID: lrzID, token: token, state: .awaitingConfirmation)
    }
    
    func loginSuccesful() {
        guard case .some(.waiting(let lrzID, let token)) = self.state else {
            return
        }
        PersistentUser.value = .some(lrzID: lrzID, token: token, state: .loggedIn)
        config.tumOnline.user = PersistentUser.value.user
    }
    
    func logOut() {
        config.clearCache()
        PersistentUser.reset()
        config.tumOnline.user = nil
        Usage.value = false
    }
    
}
