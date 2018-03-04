//
//  River.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation
//import JSONCodable

// taken from here: https://en.wikipedia.org/wiki/List_of_rivers_by_length
let riverNames = ["Amazon", "Nile", "Yangtze", "Mississippi", "Yenisei", "Huang He", "Ob", "Río de la Plata", "Congo", "Amur", "Lena", "Mekong", "Mackenzie", "Niger", "Murray", "Tocantins", "Volga", "Euphrates", "Madeira", "Purús", "Yukon", "Indus", "São Francisco", "Syr Darya", "Salween", "Saint Lawrence", "Rio Grande", "Lower Tunguska", "Brahmaputra", "Donau"]

class River /*: JSONCodable*/ {
    
    var name: String = ""
    var points: [RiverPoint] = []
    
    init(with name: String, and points: [HexPointWithCorner]) {
        
        self.name = name
        self.points = []
        self.translate(points: points)
    }

    /*public required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.name = try decoder.decode("name")
        self.points = try decoder.decode("points")
    }*/
    
    /**
        translate the list of points into river flows
     */
    func translate(points: [HexPointWithCorner]) {
        
        var prev = points.first
        for point in points.suffix(from: 1) {
            
            self.points.append(self.riverPoint(from: prev!, to: point))
            
            prev = point
        }
    }
    
    func riverPoint(from: HexPointWithCorner, to: HexPointWithCorner) -> RiverPoint {
        
        if from.point == to.point {
            if from.corner == .northeast && to.corner == .east {
                return RiverPoint(with: from.point, and: .southEast)
            } else if from.corner == .east && to.corner == .northeast {
                return RiverPoint(with: from.point, and: .northWest)
            }
            
            if from.corner == .east && to.corner == .southeast {
                return RiverPoint(with: from.point, and: .southWest)
            } else if from.corner == .southeast && to.corner == .east {
                return RiverPoint(with: from.point, and: .northEast)
            }
            
            if from.corner == .northeast && to.corner == .northwest {
                return RiverPoint(with: from.point, and: .west)
            } else if from.corner == .northwest && to.corner == .northeast {
                return RiverPoint(with: from.point, and: .east)
            }
            
            // we need to move to the northWest neighboring tile
            let northWestNeighbor = from.point.neighbor(in: .northwest)
            if from.corner == .northwest && to.corner == .west {
                return RiverPoint(with: northWestNeighbor, and: .southWest)
            } else if from.corner == .west && to.corner == .northwest {
                return RiverPoint(with: northWestNeighbor, and: .northEast)
            }
            
            // we need to move to the south neighboring tile
            let southNeighbor = from.point.neighbor(in: .south)
            if from.corner == .southwest && to.corner == .southeast {
                return RiverPoint(with: southNeighbor, and: .east)
            } else if from.corner == .southeast && to.corner == .southwest {
                return RiverPoint(with: southNeighbor, and: .west)
            }
            
            // we need to move to the southWest neighboring tile
            let southWestNeighbor = from.point.neighbor(in: .southwest)
            if from.corner == .west && to.corner == .southwest {
                return RiverPoint(with: southWestNeighbor, and: .southEast)
            } else if from.corner == .southwest && to.corner == .west {
                return RiverPoint(with: southWestNeighbor, and: .northWest)
            }
        } else {
            let dir = from.point.direction(towards: to.point)
            
            switch dir! {
            case .northeast:
                // GridPointWithCorner(11,6 / east), to: GridPointWithCorner(12,6 / southEast)
                // GridPointWithCorner(17,10 / east), to: GridPointWithCorner(18,10 / southEast)
                if from.corner == .east && to.corner == .southeast {
                    let southEastNeighbor = from.point.neighbor(in: .southeast)
                    return RiverPoint(with: southEastNeighbor, and: .east)
                }
                break
            case .southeast:
                // GridPointWithCorner(1,12 / southEast), to: GridPointWithCorner(2,13 / southWest)
                if from.corner == .southeast && to.corner == .southwest {
                    let southNeighbor = from.point.neighbor(in: .south)
                    return RiverPoint(with: southNeighbor, and: .southEast)
                }
                break
			case .south:
                // GridPointWithCorner(11,0 / southWest), to: GridPointWithCorner(11,1 / west)
                if from.corner == .southwest && to.corner == .west {
					let southWestNeighbor = from.point.neighbor(in: .southwest)
                    return RiverPoint(with: southWestNeighbor, and: .southWest)
                }
                break
            case .southwest:
                // GridPointWithCorner(19,1 / west), to: GridPointWithCorner(18,2 / northWest)
                if from.corner == .west && to.corner == .northwest {
                    return RiverPoint(with: to.point, and: .west)
                }
                break
            case .northwest:
                // GridPointWithCorner(6,6 / northWest), to: GridPointWithCorner(5,5 / northEast)
                if from.corner == .northwest && to.corner == .northeast {
                    return RiverPoint(with: to.point, and: .northWest)
                }
                break
            case .north:
                // GridPointWithCorner(5,13 / northEast), to: GridPointWithCorner(5,12 / east)
                if from.corner == .northeast && to.corner == .east {
                    return RiverPoint(with: to.point, and: .northEast)
                }
                break
            }
        }
        
        assert(false, "Condition from: \(from), to: \(to) not handled")
    }
}
