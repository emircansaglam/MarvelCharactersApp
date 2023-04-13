//
//  HomeScreenService.swift
//  MarvelCharactersApp
//
//  Created by Emircan Sağlam on 13.04.2023.
//

import Foundation
import Alamofire
import CryptoKit


class HomeScreenService {
   
    private var baseUrl: String?
    func GetCharacters(endPoint: Int,completion: @escaping ([newResult]?) -> Void) {
        let timestamp = String(Date().timeIntervalSince1970)
        let privateKey = "10691fcec6e1cea6522b6cb485c6ae3b3935f0c6"
        let publicKey = "14a6b7183f4a5b592735fcf6ae293129"
        let hash = Insecure.MD5.hash(data: "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8)!)
        let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
        
        let urlString = "https://gateway.marvel.com/v1/public/characters?limit=5&offset=\(endPoint)&ts=\(timestamp)&apikey=\(publicKey)&hash=\(hashString)"
        
        AF.request(urlString).response { response in
            guard let data = response.data else {
                completion(nil)
                return
            }
            
            do {
                let charactersResponse = try JSONDecoder().decode(newWelcome.self, from: data)
                print(charactersResponse.data?.results)
                completion(charactersResponse.data?.results)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }
    
}

