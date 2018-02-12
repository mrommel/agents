//
//  GameViewController.swift
//  IsoGame
//
//  Created by Dave Longbottom on 16/01/2015.
//  Copyright (c) 2015 Big Sprite Games. All rights reserved.
//

import UIKit
import SpriteKit

struct GameSceneConstants {
	
	struct ZLevels {
		static let terrain: CGFloat = 1.0
		static let focus: CGFloat = 2.0
		static let feature: CGFloat = 3.0
		static let sprite: CGFloat = 5.0
		static let labels: CGFloat = 50.0
	}
}

class GameScene: SKScene {
	
	//1
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let viewHex: SKSpriteNode
	let layerHexGround: SKNode
	let layerHexObjects: SKNode
	var focusSprite: SKSpriteNode?
	
	//var guy: SKSpriteNode?
	//var guyHex: HexPoint = HexPoint(x: 0, y: 0)
	var professor: Professor?
	var egyptLady: EgyptLady?
	
	let mapDisplay = HexMapDisplay()
	let map = TileHexMap(width: 15, height: 15, initialValue: Tile(withTerrain: .ocean))
	
	var cam: SKCameraNode!
	
	// debug
	let positionLabel = SKLabelNode(fontNamed: "Chalkduster")
	
	//4
	override init(size: CGSize) {
		
		viewHex = SKSpriteNode()
		layerHexGround = SKNode()
		layerHexObjects = SKNode()
		
		super.init(size: size)
		self.anchorPoint = CGPoint(x:0.5, y:0.2)
		
		// manipulate map
		initializeMap()
	}
	
	//5
	override func didMove(to view: SKView) {
		
		let deviceScale = self.size.width/667
		
		viewHex.position = CGPoint(x: self.size.width * 0, y: self.size.height * 0.25)
		viewHex.xScale = deviceScale
		viewHex.yScale = deviceScale
		viewHex.addChild(layerHexGround)
		viewHex.addChild(layerHexObjects)
		addChild(viewHex)
		
		self.cam = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
		self.cam.xScale = 0.25
		self.cam.yScale = 0.25 //the scale sets the zoom level of the camera on the given position
		
		self.camera = cam //set the scene's camera to reference cam
		self.addChild(cam) //make the cam a childElement of the scene itself.
		
		// position the camera on the gamescene.
		self.cam.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		
		placeAllTilesHex()
		placeFocusHex()
		
		placeProfessor()
		placeEgyptLady()
		
		// debug
		self.positionLabel.text = String("0, 0")
		self.positionLabel.fontSize = 10
		self.positionLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		self.positionLabel.zPosition = GameSceneConstants.ZLevels.labels
		
		self.cam.addChild(self.positionLabel)
	}
	
	func initializeMap() {
		
		// need to set different tile per position (constructor sets one tile only)
		for i in 0..<map.tiles.columns {
			for j in 0..<map.tiles.rows {
				
				let pt = HexPoint(x: i, y: j)
				
				if Int.random(min: 0, max: 5) < 3 {
					
					if Int.random(min: 0, max: 5) < 3 {
						map.set(tile: Tile(withTerrain: .grass), at: pt)
					} else {
						map.set(tile: Tile(withTerrain: .plain), at: pt)
					}
					
					if Int.random(min: 0, max: 5) < 1 {
						map.set(feature: .forest_mixed, at: pt)
					} else if Int.random(min: 0, max: 5) < 1 {
						map.set(feature: .forest_pine, at: pt)
					}
				} else {
					map.set(tile: Tile(withTerrain: .ocean), at: pt)
				}
			}
		}
		
		let finder = ContinentFinder(width: map.tiles.columns, height: map.tiles.rows)
		finder.execute(on: map)
	}
	
	func placeProfessor() {
		self.professor = Professor(at: HexPoint(x: 0, y: 0), mapDisplay: self.mapDisplay)
		layerHexGround.addChild((self.professor?.sprite)!)
	}
	
	func placeEgyptLady() {
		self.egyptLady = EgyptLady(at: HexPoint(x: 1, y: 1), mapDisplay: self.mapDisplay)
		layerHexGround.addChild((self.egyptLady?.sprite)!)
	}
	
	func placeTileHex(tile: Tile, position: CGPoint) {
		
		// place terrain
		let tileSprite = SKSpriteNode(imageNamed: tile.terrain.textureNameHex)
		tileSprite.position = position
		tileSprite.zPosition = GameSceneConstants.ZLevels.terrain
		tileSprite.anchorPoint = CGPoint(x:0, y:0)
		layerHexGround.addChild(tileSprite)
		
		// place forests etc
		for feature in tile.features {
			let featureSprite = SKSpriteNode(imageNamed: feature.textureNameHex)
			featureSprite.position = position
			featureSprite.zPosition = GameSceneConstants.ZLevels.feature // maybe need to come from feature itself
			featureSprite.anchorPoint = CGPoint(x:0, y:0)
			layerHexObjects.addChild(featureSprite)
		}
	}
	
	func placeAllTilesHex() {
		
		for i in 0..<map.tiles.columns {
			for j in 0..<map.tiles.rows {
				let tile = map.tiles[i, j]
				let screenPoint = mapDisplay.toScreen(hex: HexPoint(x: i, y: j))
				
				placeTileHex(tile: tile, position: screenPoint)
			}
		}
	}
	
	func placeFocusHex() {
		
		self.focusSprite = SKSpriteNode(imageNamed: "hex_cursor@2x")
		self.focusSprite?.position = mapDisplay.toScreen(hex: HexPoint(x: 0, y: 0))
		self.focusSprite?.zPosition = GameSceneConstants.ZLevels.focus
		self.focusSprite?.anchorPoint = CGPoint(x: 0, y: 0)
		layerHexGround.addChild(self.focusSprite!)
	}
	
	func moveFocus(to hex: HexPoint) {
		
		self.focusSprite?.position = mapDisplay.toScreen(hex: hex)
		
		/*if let path = self.findPathFrom(from: (self.professor?.position)!, to: hex) {
			self.professor?.animate(on: path)
		}*/
		if let path = self.findPathFrom(from: (self.egyptLady?.position)!, to: hex) {
			self.egyptLady?.animate(on: path)
		}
	}
	
	func findPathFrom(from: HexPoint, to: HexPoint) -> [HexPoint]? {
 
		if self.map.valid(point: to) {
			let pathFinder = AStarPathfinder()
			pathFinder.dataSource = map
			return pathFinder.shortestPath(fromTileCoord: from, toTileCoord: to)
		} else {
			return nil
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		let touch = touches.first!
		var touchLocation = touch.location(in: self.layerHexGround)
		
		// FIXME: hm, not sure why this is needed
		touchLocation.x -= 20
		touchLocation.y -= 15
		
		let position = HexPoint(cube: mapDisplay.toHexCube(screen: touchLocation))
		
		if let continent = map.tile(at: position)?.continent {
			self.positionLabel.text = "\(position) => \(continent.name)"
		} else {
			self.positionLabel.text = "\(position) => no continent"
		}
		
		self.moveFocus(to: position)
	}
	
	// moving the map around
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		for touch in touches {
			let location = touch.location(in: self.layerHexGround)
			let previousLocation = touch.previousLocation(in: self.layerHexGround)
			
			let deltaX = (location.x) - (previousLocation.x)
			let deltaY = (location.y) - (previousLocation.y)
			
			self.cam.position.x -= deltaX * 0.5
			self.cam.position.y -= deltaY * 0.5
		}
	}
	
	override func update(_ currentTime: CFTimeInterval) {

	}
}

