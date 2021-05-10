//
//  EventTableViewCell.swift
//  FetchRewardsExercise
//
//  Created by Ryan Helgeson on 5/9/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    static let identifier = "EventTableViewCell"

    private let eventLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.label.cgColor
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "cpu", withConfiguration: config)
        imageView.image = image
        return imageView
    }()
   
    public let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "heart.fill", withConfiguration: config)
        imageView.image = image
        imageView.tintColor = .red
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        addSubview(eventLabel)
        addSubview(dateLabel)
        addSubview(locationLabel)
        addSubview(eventImageView)
        addSubview(likeImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        eventImageView.frame = CGRect(x: 30, y: 30, width: contentView.width / 5, height: contentView.width / 5)
        likeImageView.frame = CGRect(x: eventImageView.left - 10, y: eventImageView.top - 10, width: 20, height: 20)
        
        eventLabel.frame = CGRect(x: eventImageView.right + 40, y: 10, width: contentView.right - eventImageView.right - 60, height: eventImageView.height - 20)
        locationLabel.frame = CGRect(x: eventImageView.right + 40, y: eventLabel.bottom + 10, width: contentView.right - eventImageView.right - 60, height: 20)
        dateLabel.frame = CGRect(x: eventImageView.right + 40, y: locationLabel.bottom + 10, width: contentView.right - eventImageView.right - 60, height: 40)
    }
    
    public func configure(with event: Event) {
        eventLabel.text = event.primaryPerformer
        locationLabel.text = event.location
        dateLabel.text = ViewController.dateFormatter.string(from: event.date)
        
        guard let url = URL(string: event.imageUrl) else {
            return
        }
        eventImageView.sd_setImage(with: url, completed: nil)
    }
    
}
