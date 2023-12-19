import Foundation
// MARK: - Cocktail
struct Cocktail: Codable {
    let id, name: String
    let type: TypeEnum
    let shortDescription, longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
}

enum TypeEnum: String, Codable {
    case alcoholic = "alcoholic"
    case nonAlcoholic = "non-alcoholic"
}

typealias CocktailArray = [Cocktail]
