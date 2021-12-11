//
//  GeoJsonShape.swift
//  travana
//
//  Created by Domen Kralj on 11/12/2021.
//  Copyright © 2021 Domen Kralj. All rights reserved.
//

import Foundation

/*
struct GeoJsonShape: Decodable {
    
    public var type: String
    public var coordinatesLine: [[Double]]?
    public var coordinatesMulti: [[[Double]]]?

    private enum CodingKeys : String, CodingKey {
        case type = "type", coordinatesLine, coordinatesMulti
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        switch type {
        case GeoJsonShapeType.GeoLine:
            coordinatesLine = try values.decode([[Double]].self, forKey: GeoJsonShape.CodingKeys(rawValue: "coordinates")!)
        case GeoJsonShapeType.GeoMultiLine:
            coordinatesMulti = try values.decode([[[Double]]].self, forKey: .coordinatesLine)
        default:
            coordinatesLine = nil
            coordinatesMulti = nil
        }
    }
}

struct GeoJsonShapeType {
    public static let GeoLine = "LineString"
    public static let GeoMultiLine = "MultiLineString"
}
*/

enum GeoJsonShapeTypeEnum: Codable {
    case line([[Double]])
    case multiLine([[[Double]]])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .line(container.decode([[Double]].self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .multiLine(container.decode([[[Double]]].self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(GeoJsonShapeTypeEnum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }
    
    func value() -> Any {
      switch self {
        case .line(let value):
          return value
        case .multiLine(let value):
          return value
      }
    }
}

struct GeoJsonShape: Decodable {
    
    public var type: String
    public var coordinates: GeoJsonShapeTypeEnum
    
    private enum CodingKeys : String, CodingKey {
        case type = "type", coordinates
    }
}

struct GeoJsonShapeType {
    public static let GeoLine = "LineString"
    public static let GeoMultiLine = "MultiLineString"
}
