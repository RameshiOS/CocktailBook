import Foundation
import UIKit

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
