
import Foundation

struct newWelcome: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: newData?
}

// MARK: - newData
struct newData: Codable {
    let offset, limit, total, count: Int?
    let results: [newResult]?
}

// MARK: - newResult
struct newResult: Codable {
    let id: Int?
    let name, description: String?
    let modified: String?
    let thumbnail: newThumbnail?
    let resourceURI: String?
    let comics, series: newComics?
    let stories: newStories?
    let events: newComics?
    let urls: [newURL]?
}

// MARK: - newComics
struct newComics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [newComicsItem]?
    let returned: Int?
}

// MARK: - newComicsItem
struct newComicsItem: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - newStories
struct newStories: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [newStoriesItem]?
    let returned: Int?
}

// MARK: - newStoriesItem
struct newStoriesItem: Codable {
    let resourceURI: String?
    let name: String?
    let type: newItemType?
}

enum newItemType: String, Codable {
    case cover = "cover"
    case empty = ""
    case interiorStory = "interiorStory"
}

// MARK: - newThumbnail
struct newThumbnail: Codable {
    let path: String?
    let thumbnailExtension: newExtension?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum newExtension: String, Codable {
    case gif = "gif"
    case jpg = "jpg"
}

// MARK: - newURL
struct newURL: Codable {
    let type: newURLType?
    let url: String?
}

enum newURLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}
