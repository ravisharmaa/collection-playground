import UIKit

class MovieCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(imageView)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        
        contentView.addSubview(nameLabel)
        
        nameLabel.textAlignment = .center
        
        nameLabel.numberOfLines = 2
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
       
        
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        
    }
    
    func setFields(resultSet: Result) {
        
        guard let posterPath = resultSet.posterPath else {
            
            self.imageView.image = #imageLiteral(resourceName: "movie-placeholder")
            return
        }
        
        
        HttpRequest.shared.fetchAvatarFrom(Constants.imageUrl + posterPath) { (image) in
            self.imageView.image = image
        }
        
        self.nameLabel.text = resultSet.title
    }
    
    
    
    
}
