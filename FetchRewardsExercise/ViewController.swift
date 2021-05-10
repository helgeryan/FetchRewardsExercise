//
//  ViewController.swift
//  FetchRewardsExercise
//
//  Created by Ryan Helgeson on 5/9/21.
//

import UIKit
import SGAPI

class ViewController: UIViewController {
    
    let events = SGEventSet.eventsSet()
    
    var tableEvents: [Event] = []
    
    // Initialize search bar
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search events.. "
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Add search bar to the navigation bar
        navigationController?.navigationBar.topItem?.titleView = searchBar
        view.addSubview(tableView)
        
        
        // Register EventTableViewCell in the TableView
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        
        // Assign delegates to the ViewController
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        guard let events = events else {
            print("Failed")
            return
        }
        
        // Events closure for onPageLoaded
        events.onPageLoaded = { [weak self] results in
            for i in 0..<results.count {
                let event = results.object(at: i) as! SGEvent
                NSLog("%@", event.title())
                let newEvent = Event(imageUrl: event.primaryPerformer.imageURL,
                                     primaryPerformer: event.title(),
                                     location: event.venue.displayLocation,
                                     date: event.localDate)
                self?.tableEvents.append(newEvent)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.width,
                                 height: view.height - searchBar.height)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let model = tableEvents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as! EventTableViewCell
        
        // To show that the likeImageView exists. Wasn't able to finish the full capability of the
        // like button from the exercise. 
        if indexPath.row % 2 == 0 {
            cell.likeImageView.isHidden = false
        }
        
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = tableEvents[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        
        // Initialize DetailViewController and push it
        let vc = DetailViewController(event: model)
        navigationController?.pushViewController(vc, animated: false)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

// MARK: - UISearchBarDelegate Methods

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let events = events else {
            print("Failed")
            return
        }
        
        // Clear the existing events
        tableEvents = []
        
        // Get new query
        events.query?.search = searchBar.text

        // Fetch the page
        events.fetchNextPage()

        // Resign First Repsonder
        searchBar.resignFirstResponder()
    }
}

