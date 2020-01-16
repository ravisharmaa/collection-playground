import Foundation

struct Movie: Codable {
    
    var page: Int
    
    var totalResults: Int
    
    var totalPages: Int
    
    var results: [Result]
    
    enum CodingKeys: String, CodingKey {
    
        case page = "page"
        
        case totalResults = "total_results"
        
        case totalPages = "total_pages"
        
        case results
    }
    
}

struct Result: Codable {
    
    var popularity: Float
    
    var adult:  Bool
    
    var overview: String
    
    var releaseDate: String
    
    var originalLanguage: String
    
    var title: String
    
    var posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        
        case popularity = "popularity"
        
        case adult = "adult"
        
        case overview = "overview"
        
        case releaseDate = "release_date"
        
        case originalLanguage = "original_language"
        
        case title = "title"
        
        case posterPath = "poster_path"
    }
    
}
