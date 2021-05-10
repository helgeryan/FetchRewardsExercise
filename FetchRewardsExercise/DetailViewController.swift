//
//  DetailViewController.swift
//  FetchRewardsExercise
//
//  Created by Ryan Helgeson on 5/9/21.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    private let event: Event
    
    private let eventLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.label.cgColor
        return imageView
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
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
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
        eventLabel.text = event.primaryPerformer
        dateLabel.text = ViewController.dateFormatter.string(from: event.date)
        locationLabel.text = event.location
        guard let url = URL(string: event.imageUrl) else {
            return
        }
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(eventLabel)
        view.addSubview(imageView)
        view.addSubview(divider)
        view.addSubview(dateLabel)
        view.addSubview(locationLabel)
        view.addSubview(likeButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        eventLabel.frame = CGRect(x: view.width / 4, y: view.safeAreaInsets.top + 20, width: view.width / 2, height: view.height / 5)
        
        likeButton.frame = CGRect(x: eventLabel.right + 30, y: eventLabel.top, width: view.right - eventLabel.right - 60, height: view.right - eventLabel.right - 60)
        
        divider.frame = CGRect(x: 10, y: eventLabel.bottom + 20, width: view.width - 20, height: 2)
        
        imageView.frame = CGRect(x: 10, y: divider.bottom + 20, width: view.width - 20 , height: view.height / 3)
        
        dateLabel.frame = CGRect(x: imageView.left, y: imageView.bottom + 10, width: imageView.width, height: 20)
        locationLabel.frame = CGRect(x: imageView.left, y: dateLabel.bottom + 10, width: imageView.width, height: 20)
    }
    
    @objc private func didTapLike() {
        if likeButton.tintColor.accessibilityName == UIColor.label.accessibilityName {
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
            let image = UIImage(systemName: "heart.fill", withConfiguration: config)
            self.likeButton.setImage(image, for: .normal)
            self.likeButton.tintColor = .red
        }
        else {
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
            let image = UIImage(systemName: "heart", withConfiguration: config)
            self.likeButton.setImage(image, for: .normal)
            self.likeButton.tintColor = .label
        }
    }

}
