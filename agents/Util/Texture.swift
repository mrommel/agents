//
//  Texture.swift
//  agents
//
//  Created by Michael Rommel on 18.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

func textureImageFor(tile: Tile, in direction: Direction, with action: Action) -> String {
	
	switch tile {
	case .Droid:
		switch action {
		case .Idle:
			switch direction {
			case .N:return "droid_n"
			case .NE:return "droid_ne"
			case .E:return "droid_e"
			case .SE:return "droid_se"
			case .S:return "droid_s"
			case .SW:return "droid_sw"
			case .W:return "droid_w"
			case .NW:return "droid_nw"
			}
		case .Move:
			switch direction {
			case .N:return "droid_n"
			case .NE:return "droid_ne"
			case .E:return "droid_e"
			case .SE:return "droid_se"
			case .S:return "droid_s"
			case .SW:return "droid_sw"
			case .W:return "droid_w"
			case .NW:return "droid_nw"
			}
		}
	case .Ground:
		return "ground"
	case .Wall:
		switch direction {
		case .N:return "wall_n"
		case .NE:return "wall_ne"
		case .E:return "wall_e"
		case .SE:return "wall_se"
		case .S:return "wall_s"
		case .SW:return "wall_sw"
		case .W:return "wall_w"
		case .NW:return "wall_nw"
		}
	}
	
}
protocol TextureObject {
	static var sharedInstance: TextureDroid {get}
	var texturesIso:[[SKTexture]?] {get}
	var textures2D:[[SKTexture]?] {get}
}
private let textureDroid = TextureDroid()

class TextureDroid: TextureObject  {
	
	class var sharedInstance: TextureDroid {
		return textureDroid
	}
	
	var texturesIso:[[SKTexture]?]
	var textures2D:[[SKTexture]?]
	
	init() {
		
		texturesIso = [[SKTexture]?](repeating: nil, count: 2)
		textures2D = [[SKTexture]?](repeating: nil, count: 2)
		
		//Idle
		texturesIso[Action.Idle.rawValue] = [
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .N, with: .Idle)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .NE, with: .Idle)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .E, with: .Idle)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .SE, with: .Idle)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .S, with: .Idle)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .SW, with: .Idle)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .W, with: .Idle)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .NW, with: .Idle)),
		]
		
		//Move
		texturesIso[Action.Move.rawValue] = [
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .N, with: .Move)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .NE, with: .Move)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .E, with: .Move)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .SE, with: .Move)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .S, with: .Move)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .SW, with: .Move)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .W, with: .Move)),
			SKTexture(imageNamed: "iso_3d_" + textureImageFor(tile: .Droid, in: .NW, with: .Move)),
		]
		
		//Idle
		textures2D[Action.Idle.rawValue] = [
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .N, with: .Idle)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .NE, with: .Idle)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .E, with: .Idle)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .SE, with: .Idle)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .S, with: .Idle)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .SW, with: .Idle)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .W, with: .Idle)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .NW, with: .Idle)),
		]
		
		//Move
		textures2D[Action.Move.rawValue] = [
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .N, with: .Move)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .NE, with: .Move)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .E, with: .Move)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .SE, with: .Move)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .S, with: .Move)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .SW, with: .Move)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .W, with: .Move)),
			SKTexture(imageNamed: textureImageFor(tile: .Droid, in: .NW, with: .Move)),
		]
	}
}
