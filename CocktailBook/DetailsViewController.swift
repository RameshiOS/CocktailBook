//
//  DetailsViewController.swift
//  CocktailBook
//
//  Created by Ramesh Guddala on 19/12/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var cocktail: Cocktail?
    var isFavorite: Bool = false
    
    let cocktailNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "clock")
        return imageView
    }()
    
    let preparationTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let cocktailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // Set a placeholder image or default image
        imageView.image = UIImage(named: "placeholderImage")
        return imageView
    }()
    
    let longDescriptionLabel: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        return textView
    }()
    
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let scrollView: UIScrollView = {
          let scrollView = UIScrollView()
          scrollView.translatesAutoresizingMaskIntoConstraints = false
          return scrollView
      }()
    
    let contentView: UIView = {
           let contentView = UIView()
           contentView.translatesAutoresizingMaskIntoConstraints = false
           return contentView
       }()
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupScrollView()
        setupUI()
        updateUI()
        setupFavoriteButton()
    }
       
       let favoriteButton: UIBarButtonItem = {
           let button = UIBarButtonItem()
           button.image = UIImage(systemName: "heart")
           button.style = .plain
           return button
       }()
       
    func setupNavigationBar() {
        navigationItem.title = cocktail?.name ?? "Cocktail Details"
        navigationItem.rightBarButtonItem = favoriteButton
    }
    func setupFavoriteButton() {
           navigationItem.rightBarButtonItem = favoriteButton
           favoriteButton.target = self
           favoriteButton.action = #selector(favoriteButtonTapped)
           updateFavoriteButtonImage()
       }
       
    func updateFavoriteButtonImage() {
           if isFavorite {
               favoriteButton.image = UIImage(systemName: "heart.fill")
           } else {
               favoriteButton.image = UIImage(systemName: "heart")
           }
       }
       
       @objc func favoriteButtonTapped() {
           isFavorite.toggle()
           updateFavoriteButtonImage()
           
           // Handle favorite action here...
           // You might want to add logic to store favorites persistently
       }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupUI() {
        contentView.addSubview(cocktailNameLabel)
        contentView.addSubview(clockImageView)
        contentView.addSubview(preparationTimeLabel)
        contentView.addSubview(cocktailImageView)
        contentView.addSubview(longDescriptionLabel)
        contentView.addSubview(ingredientsLabel)
        longDescriptionLabel.text = cocktail?.longDescription

        // Add constraints for UI elements
        
        // Cocktail Name Label Constraints
        cocktailNameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        cocktailNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        cocktailNameLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cocktailNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cocktailNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        // Clock Image View Constraints
        clockImageView.topAnchor.constraint(equalTo: cocktailNameLabel.bottomAnchor, constant: 10).isActive = true
        clockImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        clockImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        clockImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Preparation Time Label Constraints
        preparationTimeLabel.topAnchor.constraint(equalTo: cocktailNameLabel.bottomAnchor, constant: 10).isActive = true
        preparationTimeLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 10).isActive = true
        preparationTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        preparationTimeLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        preparationTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        // Cocktail Image View Constraints
        cocktailImageView.topAnchor.constraint(equalTo: preparationTimeLabel.bottomAnchor, constant: 20).isActive = true
        cocktailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
       cocktailImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Long Description Label Constraints
        longDescriptionLabel.topAnchor.constraint(equalTo: cocktailImageView.bottomAnchor, constant: 10).isActive = true
        longDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        longDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        longDescriptionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true

        // Ingredients Label Constraints
        ingredientsLabel.topAnchor.constraint(equalTo: longDescriptionLabel.bottomAnchor, constant: 20).isActive = true
        ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        ingredientsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        ingredientsLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true

        
       
    }
    
    func updateUI() {
        if let cocktail = cocktail {
            cocktailNameLabel.text = cocktail.name
            
                preparationTimeLabel.text = "\(cocktail.preparationMinutes) minutes"
            
            // Load image based on imageName from the cocktail model
                cocktailImageView.image = UIImage(named: cocktail.imageName)
            
            longDescriptionLabel.text = cocktail.longDescription
            
            let ingredientsText = cocktail.ingredients.map { "• \($0)" }.joined(separator: "\n")
            ingredientsLabel.text = "Ingredients:\n\(ingredientsText)"
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
struct FavoriteManager {
    static var favorites: [String] {
        get {
            // Retrieve favorites from UserDefaults or any other storage mechanism
            return UserDefaults.standard.stringArray(forKey: "FavoriteCocktails") ?? []
        }
        set {
            // Save favorites to UserDefaults or any other storage mechanism
            UserDefaults.standard.set(newValue, forKey: "FavoriteCocktails")
        }
    }

    static func addFavorite(cocktailID: String) {
        var favorites = self.favorites
        if !favorites.contains(cocktailID) {
            favorites.append(cocktailID)
            self.favorites = favorites
        }
    }

    static func removeFavorite(cocktailID: String) {
        var favorites = self.favorites
        if let index = favorites.firstIndex(of: cocktailID) {
            favorites.remove(at: index)
            self.favorites = favorites
        }
    }
}
