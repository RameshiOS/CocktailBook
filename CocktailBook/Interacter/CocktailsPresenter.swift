import Foundation

protocol CocktailsPresenterDelegate: AnyObject {
    func presentCocktails(_ cocktails: [Cocktail])
    func handleFetchingError(_ error: Error)
}

class CocktailsPresenter {
    weak var delegate: CocktailsPresenterDelegate?
    private let getCocktailsUseCase: GetCocktailsUseCase
    
    init(getCocktailsUseCase: GetCocktailsUseCase) {
        self.getCocktailsUseCase = getCocktailsUseCase
    }
    
    func getCocktails() {
        getCocktailsUseCase.execute { result in
            switch result {
            case .success(let cocktails):
                self.delegate?.presentCocktails(cocktails)
            case .failure(let error):
                self.delegate?.handleFetchingError(error)
            }
        }
    }
}
