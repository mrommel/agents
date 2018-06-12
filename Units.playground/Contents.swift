//: Playground - noun: a place where people can play

import UIKit

let distance = Measurement(value: 106.4, unit: UnitLength.kilometers)

let distanceInMeters = distance.converted(to: .meters)
// → 106400 m
let distanceInMiles = distance.converted(to: .miles)
// → 66.1140591795394 mi
let distanceInFurlongs = distance.converted(to: .furlongs)
// → 528.911158832419 fur

extension UnitLength {
	static var leagues: UnitLength {
		// 1 league = 5556 meters
		return UnitLength(symbol: "leagues",
						  converter: UnitConverterLinear(coefficient: 5556))
	}
}

let distanceInLeagues = distance.converted(to: .leagues)
// → 19.150467962563 leagues

let doubleDistance = distance * 2
// → 212.8 km
let distance2 = distance + Measurement(value: 5, unit: UnitLength.kilometers)
// → 111.4 km
let distance3 = distance + Measurement(value: 10, unit: UnitLength.miles)
// → 122493.4 m

let formatter = MeasurementFormatter()
let 🇩🇪 = Locale(identifier: "de_DE")
formatter.locale = 🇩🇪
formatter.string(from: distance) // "106,4 km"

let 🇺🇸 = Locale(identifier: "en_US")
formatter.locale = 🇺🇸
formatter.string(from: distance) // "66.114 mi"

let 🇨🇳 = Locale(identifier: "zh_Hans_CN")
formatter.locale = 🇨🇳
formatter.string(from: distance) // "106.4公里"
