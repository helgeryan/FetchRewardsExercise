//
//  Response.swift
//  FetchRewardsExercise
//
//  Created by Ryan Helgeson on 5/9/21.
//

import Foundation

struct Response: Decodable {
    
    var items : [String]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.items = try container.decode([String].self, forKey: .items)
    }
    
}
