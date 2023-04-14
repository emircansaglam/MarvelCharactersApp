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
    private var allCharacters: [newResult] = []
    var didUpdate: (() -> Void)?
    var endpoint = 0
    var isLoading = false
    
    func fetchCharacters() {
        endpoint = 0
        service.GetCharacters(endPoint: endpoint) { [weak self] characters in
            self?.characters = characters
            self?.allCharacters = characters ?? []
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
            self.allCharacters.append(contentsOf: characters ?? [])
            self.didUpdate?()
            self.isLoading = false
        }
    }
    
    func filteredCharacters(for searchText: String) -> [newResult]? {
        guard !searchText.isEmpty else {
            // Search text is empty, return the original unfiltered character array
            return characters
        }
        return characters?.filter({ character in
            return character.name?.range(of: searchText, options: [.caseInsensitive]) != nil
        })
    }
}
