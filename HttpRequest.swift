import UIKit

struct HttpRequest {
    
    static let shared = HttpRequest()

    private init() {}
    
    func getResults <T: Decodable> (from url: String, forText: String, completion: @escaping(T?, ErrorType?)->()) {
        let apiUrl = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(forText)&api_key=8d181bcb5e80a929053da01f6921e4a9")
        
        guard let urlI = apiUrl else {
            completion(nil, .error)
            return
        }
        
        URLSession.shared.dataTask(with: urlI) { (data, response, error) in
            
            if let _ = error {
                completion(nil, .error)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(nil, .error)
            }
            
            guard let jsonData = data else {
                completion(nil, .error)
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: jsonData)
                completion(responseObject, nil)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    func fetchAvatarFrom(_ url: String, completion: @escaping(UIImage?) -> ()) {
      
        CacheManager.shared.getFromCacheFor(key: url) { (image) in
            
            guard let image = image else {
                completion(nil)
                return
            }

            completion(image as? UIImage)
        }
        
        let cacheKey: NSString = NSString(string: url)
        
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            
            let data = try? Data(contentsOf: url)
            
            guard let imageData = data else { return }
            
            DispatchQueue.main.async {
                
                guard let image = UIImage(data: imageData) else { return }
                
                CacheManager.shared.setInCache(image: image, key: cacheKey)
                
                completion(image)
            }
            
        }
    }
}
