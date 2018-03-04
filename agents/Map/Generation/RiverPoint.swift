//
//  RiverPoint.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 16.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
//import JSONCodable

class RiverPoint/*: JSONCodable*/ {
    
    var point: HexPoint
	var flowDirection: FlowDirection
    
    public init(with point: HexPoint, and flowDirection: FlowDirection) {
        
        self.point = point
        self.flowDirection = flowDirection
    }
    
    /*public required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.point = try decoder.decode("point")
        self.flowDirection = FlowDirection.enumFrom(string: object["flowDirection"] as! String)
    }
    
    public func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(self.point, key: "point")
            try encoder.encode(self.flowDirection.stringValue, key: "flowDirection")
        })
    }*/
}
