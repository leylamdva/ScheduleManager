//
//  User.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/22/22.
//

import Foundation


class User: ObservableObject, Codable {
    @Published var email = ""
    @Published var password = ""
    @Published var token = ""
    @Published var location = ""
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(email, forKey: .email)
        try container.encode(token, forKey: .token)
        try container.encode(location, forKey: .location)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        token = try container.decode(String.self, forKey: .token)
        location = try container.decode(String.self, forKey: .location)
    }
    
    init() {}
}

enum CodingKeys: CodingKey {
    case email, token, location
}

struct Status: Codable {
    var status: String
}

struct Token : Codable {
    var token: String
}
