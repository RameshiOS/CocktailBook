import UIKit

class MainScreenViewController: UIViewController  {

    private var presenter: CocktailsPresenter!
    var filteredCocktails: [Cocktail] = [] // Array to store filtered cocktails
      var cocktails: [Cocktail] = [] //  array of cocktails
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
        injectDataFromAPI()
        setupUI()
        navigationItem.title = "All Cocktails"
      //  loadCocktailsData()
        

    }
    
    func injectDataFromAPI() {
        let repository: CocktailsRepository = CocktailInjectRepository() // Replace with your repository instance
              let getCocktailsUseCase = GetCocktailsUseCase(repository: repository)
              presenter = CocktailsPresenter(getCocktailsUseCase: getCocktailsUseCase)
              presenter.delegate = self
              presenter.getCocktails()
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
        tableView.reloadData()
    }
}

extension MainScreenViewController : CocktailsPresenterDelegate {
    
    func presentCocktails(_ cocktails: [Cocktail]) {
        self.cocktails = cocktails
        self.filterCocktails()
    }
    
    func handleFetchingError(_ error: Error) {
        
    }
}

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailTableViewCell", for: indexPath) as? CocktailTableViewCell else {
              fatalError("Could not dequeue custom cell")
          }

        let cocktail = filteredCocktails[indexPath.row]

        cell.titleLabel.text = cocktail.name
        cell.subtitleLabel.text = cocktail.shortDescription
        return cell
    }
    
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedCocktail = filteredCocktails[indexPath.row]
       let detailsViewController = DetailsViewController()
       detailsViewController.cocktail = selectedCocktail
     navigationController?.pushViewController(detailsViewController, animated: true)
       tableView.deselectRow(at: indexPath, animated: true)
   }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
