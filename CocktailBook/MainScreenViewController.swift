import UIKit

// MARK: - RepositoryElement
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



class CocktailListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    var filteredCocktails: [Cocktail] = [] // Array to store filtered cocktails

    enum FilterState {
          case all, alcoholic, nonAlcoholic
      }
      
      var cocktails: [Cocktail] = [] //  array of cocktails
      var currentFilter: FilterState = .all {
          didSet {
              filterCocktails()
              updateNavigationTitle()
              tableView.reloadData()
          }
      }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["All", "Alcoholic", "Non-Alcoholic"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterCocktails), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(CocktailTableViewCell.self, forCellReuseIdentifier: "CocktailTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        // Set initial filter and load data
        currentFilter = .all
        setupUI()
        loadCocktailsData()
        

    }
    func loadCocktailsData() {
           // Load your cocktails data here into 'cocktails' array
           // Once the data is loaded, apply the initial filter
           filterCocktails()
           updateNavigationTitle()
           tableView.reloadData()
       }
       
       func updateNavigationTitle() {
           let title: String
           switch currentFilter {
           case .all:
               title = "All Cocktails"
           case .alcoholic:
               title = "Alcoholic Cocktails"
           case .nonAlcoholic:
               title = "Non-Alcoholic Cocktails"
           }
           navigationItem.title = title
       }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let selectedCocktail = filteredCocktails[indexPath.row]
          let detailsViewController = DetailsViewController()
          detailsViewController.cocktail = selectedCocktail        
        navigationController?.pushViewController(detailsViewController, animated: true)
          tableView.deselectRow(at: indexPath, animated: true)
      }
    
       // Handle filter change (could be from a segment control or any other UI control)
//       @objc func filterSegmentValueChanged(_ sender: UISegmentedControl) {
//           guard let selectedFilter = FilterState(rawValue: sender.selectedSegmentIndex) else { return }
//           currentFilter = selectedFilter
//       }
//
    override func viewWillAppear(_ animated: Bool) {
        
        cocktailsAPI.fetchCocktails { result in
            if case let .success(data) = result {
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        let decoder = JSONDecoder()

                        do {
                            self.cocktails = try decoder.decode([Cocktail].self, from: data)
                            
                            print(self.cocktails)
                            self.filterCocktails()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    private func setupUI() {
            view.addSubview(segmentedControl)
            view.addSubview(tableView)
            
            NSLayoutConstraint.activate([
                segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        

    @objc private func filterCocktails() {
        let selectedIndex = segmentedControl.selectedSegmentIndex

        if selectedIndex == 0 {
            filteredCocktails = cocktails // Show all cocktails
        } else {
            let filter = segmentedControl.titleForSegment(at: selectedIndex)!
            filteredCocktails = cocktails.filter { $0.type.rawValue == filter.lowercased() }
        }
        filteredCocktails.sort { $0.name < $1.name } // Sort filtered cocktails alphabetically by name
        self.cocktailsSort()
        self.updateNavigationTitle()
        tableView.reloadData()
    }
    
    func cocktailsSort() {
        // Sort the cocktails placing favorites at the beginning
           cocktails.sort { (cocktail1, cocktail2) -> Bool in
               let isCocktail1Favorite = FavoriteManager.favorites.contains(cocktail1.id)
               let isCocktail2Favorite = FavoriteManager.favorites.contains(cocktail2.id)
               
               if isCocktail1Favorite && !isCocktail2Favorite {
                   return true
               } else if !isCocktail1Favorite && isCocktail2Favorite {
                   return false
               } else {
                   return cocktail1.name < cocktail2.name
               }
           }
    }
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCocktails.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailTableViewCell", for: indexPath) as? CocktailTableViewCell else {
//              fatalError("Could not dequeue custom cell")
//          }
//
//        let cocktail = filteredCocktails[indexPath.row]
//
//        cell.titleLabel.text = cocktail.name
//        cell.subtitleLabel.text = cocktail.shortDescription
//        return cell
//    }

    // TableView delegate methods...
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailTableViewCell", for: indexPath) as! CocktailTableViewCell
            let cocktail = cocktails[indexPath.row]
            
            // Configure cell UI
            cell.titleLabel.text = cocktail.name
            cell.subtitleLabel.text = cocktail.shortDescription
            cell.favoriteButton.isSelected = FavoriteManager.favorites.contains(cocktail.id)
            
            if cell.favoriteButton.isSelected {
                // Apply different color for favorite cocktails
                cell.titleLabel.textColor = UIColor.red // Change to your desired color
                // Update other UI elements for favorites
            } else {
                // Reset UI for non-favorite cocktails
                cell.titleLabel.textColor = UIColor.black // Change to your default color
                // Update other UI elements for non-favorites
            }
 
            
            return cell
        }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // Function to filter cocktails based on type
    func filterCocktailsByType(type: String) {
        // Filter logic to display based on type (all, alcoholic, non-alcoholic)
        let filteredCocktails = cocktails.filter { $0.type.rawValue == type || type == "all" }
        // Update your table view with the filtered cocktails
        // Example: cocktails = filteredCocktails
        // Then, reload the table view
        tableView.reloadData()
    }
    
    // Other methods for handling interactions, navigation, etc.
}

protocol CocktailTableViewCellDelegate: AnyObject {
    func favoriteButtonTapped(_ cell: CocktailTableViewCell)
}

class CocktailTableViewCell: UITableViewCell {
    weak var delegate: CocktailTableViewCellDelegate?
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "pink")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44), // Adjust the constant as needed
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44), // Adjust the constant as needed
            
            favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.favoriteButtonTapped(self)
    }
    
    func configure(with title: String, subtitle: String, isFavorite: Bool) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        favoriteButton.isSelected = isFavorite
    }
}
