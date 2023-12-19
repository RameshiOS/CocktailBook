import Foundation


class CocktailInjectRepository: CocktailsRepository {
    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    var cocktails: [Cocktail] = []
    
    func fetchCocktails(completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        cocktailsAPI.fetchCocktails { result in
            if case let .success(data) = result {
                if String(data: data, encoding: .utf8) != nil {
                    DispatchQueue.main.async {
                        let decoder = JSONDecoder()
                        
                        do {
                            
                            self.cocktails = try decoder.decode([Cocktail].self, from: data)
                            
                            print(self.cocktails)
                            completion(.success(self.cocktails))
//                            self.filterCocktails()
                        } catch {
                            print(error.localizedDescription)
                            let error = NSError(domain: "com.error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch cocktails"])
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
}
