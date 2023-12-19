import Foundation

protocol CocktailsRepository {
    func fetchCocktails(completion: @escaping (Result<[Cocktail], Error>) -> Void)
}

class GetCocktailsUseCase {
    private let repository: CocktailsRepository
    
    init(repository: CocktailsRepository) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        repository.fetchCocktails(completion: completion)
    }
}
