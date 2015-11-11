//
//  RepositoriesFilter.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/18/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation

enum RepoFilterType {
    case Date, Name
}

struct RepositoriesFilter: Hashable, CustomStringConvertible {
    var name: String
    var type: RepoFilterType // TODO: Enum? Different types of filters?
    var qualifier: String // created:<2011-01-01
    
    
    init(name: String, type: RepoFilterType, qualifier: String) {
        self.name = name
        self.type = type
        self.qualifier = qualifier
    }
    
    var hashValue: Int {
        return qualifier.hashValue
    }
    
    var description: String {
        return "\(name) \(type) \(qualifier)"
    }
}

func ==(lhs:RepositoriesFilter, rhs:RepositoriesFilter) -> Bool {
    return lhs.name == rhs.name && lhs.qualifier == rhs.qualifier
}