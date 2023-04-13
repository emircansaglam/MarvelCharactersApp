//
//  HomeScreenViewModel.swift
//  MarvelCharactersApp
//
//  Created by Emircan Sağlam on 13.04.2023.
//

import Foundation

class HomeScreenViewModel {
    let service = HomeScreenService()
    var characters: [newResult]?
    var didUpdate: (() -> Void)?
    var endpoint = 0
    var isLoading = false
    
    func fetchCharacters() {
        endpoint = 0
        service.GetCharacters(endPoint: endpoint) { [weak self] characters in
            self?.characters = characters
            self?.didUpdate?()
        }
    }
    
    func loadMoreCharacters() {
        guard !isLoading else { return }
        isLoading = true
        
        endpoint += 1
        service.GetCharacters(endPoint: endpoint) { [weak self] characters in
            guard let self = self else { return }
            self.characters?.append(contentsOf: characters!)
            self.didUpdate?()
            self.isLoading = false
        }
    }
}
