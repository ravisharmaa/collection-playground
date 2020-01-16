import UIKit

class ViewController: UIViewController {
    
    var results: [Result] = [Result]()
    
    let inset: CGFloat = 5
    
    let minimumItemSpacing: CGFloat = 5
    
    let cellsPerRow: CGFloat = 3
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        definesPresentationContext = true
        
        title = "Movies"
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "movieCell")
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        
        HttpRequest.shared.getResults(from: Constants.url , forText: "a") { (movie: Movie?, error: ErrorType?) in

            if let error = error {
                print(error.localizedDescription)
            }
            guard let movie = movie else { return }
            self.results = movie.results

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.results.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        cell.setFields(resultSet: results[indexPath.item])
        return cell
    }
    
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = ((collectionView.frame.size.width - (2 * inset) - (minimumItemSpacing * (cellsPerRow - 1)))) / cellsPerRow
        
        return CGSize(width: availableWidth, height: availableWidth + 100)
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        HttpRequest.shared.getResults(from: Constants.url, forText: text) { (movie: Movie?, error: ErrorType?) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            guard let movie = movie else { return }
            self.results = movie.results
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
}
