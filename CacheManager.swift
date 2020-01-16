import UIKit

struct CacheManager {
    
    static let shared = CacheManager()
    
    private init() {}
    
    static let cache: NSCache = NSCache<AnyObject, AnyObject>()
    
    
    func getFromCacheFor(key: String, completion: @escaping(AnyObject?)->()) {
        
        let identifierString = NSString(string: key)
        
        guard let image = CacheManager.cache.object(forKey: identifierString) else {
            completion(nil)
            return
        }
        
        completion(image as? UIImage)
        
    }
    
    func setInCache(image: UIImage, key: NSString) {
        CacheManager.cache.setObject(image as AnyObject, forKey: key as AnyObject)
    }
}
