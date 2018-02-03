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
	
	var guy: SKSpriteNode?
	var guyHex: HexPoint = HexPoint(x: 0, y: 0)
	
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
		
		placeGuy()
		
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
	
	func placeGuy() {
		
		self.guy = SKSpriteNode(imageNamed: "professor0")
		self.guy?.position = mapDisplay.toScreen(hex: guyHex)
		self.guy?.zPosition = GameSceneConstants.ZLevels.focus + 1
		self.guy?.anchorPoint = CGPoint(x: 0, y: 0)
		layerHexGround.addChild(self.guy!)
	}
	
	func animateGuyDown(to hex: HexPoint) {
		
		let textureAtlasWalkDown = SKTextureAtlas(named: "professor_walk_down")
		let walkDownFrames = ["professor18", "professor19", "professor20", "professor21", "professor22", "professor23", "professor24", "professor25", "professor26"].map { textureAtlasWalkDown.textureNamed($0) }
		let walkDown = SKAction.animate(with: walkDownFrames, timePerFrame: 0.2)
		
		let moveDown = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkDown.duration)
		
		let animate = SKAction.group([walkDown, moveDown])
		self.guy?.run(animate, completion: {
			self.guyHex = hex
		})
	}
	
	func animateGuyUp(to hex: HexPoint) {
		
		let textureAtlasWalkUp = SKTextureAtlas(named: "professor_walk_up")
		let walkUpFrames = ["professor0", "professor1", "professor2", "professor3", "professor4", "professor5", "professor6", "professor7", "professor8"].map { textureAtlasWalkUp.textureNamed($0) }
		let walkUp = SKAction.animate(with: walkUpFrames, timePerFrame: 0.2)
		
		let moveUp = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkUp.duration)
		
		let animate = SKAction.group([walkUp, moveUp])
		self.guy?.run(animate, completion: {
			self.guyHex = hex
		})
	}
	
	func animateGuyLeft(to hex: HexPoint) {
		
		let textureAtlasWalkLeft = SKTextureAtlas(named: "professor_walk_left")
		let walkLeftFrames = ["professor9", "professor10", "professor11", "professor12", "professor13", "professor14", "professor15", "professor16", "professor17"].map { textureAtlasWalkLeft.textureNamed($0) }
		let walkLeft = SKAction.animate(with: walkLeftFrames, timePerFrame: 0.2)
		
		let moveLeft = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkLeft.duration)
		
		let animate = SKAction.group([walkLeft, moveLeft])
		self.guy?.run(animate, completion: {
			self.guyHex = hex
		})
	}
	
	func animateGuyRight(to hex: HexPoint) {
		
		let textureAtlasWalkRight = SKTextureAtlas(named: "professor_walk_right")
		let walkRightFrames = ["professor27", "professor28", "professor29", "professor30", "professor31", "professor32", "professor33", "professor34", "professor35"].map { textureAtlasWalkRight.textureNamed($0) }
		let walkRight = SKAction.animate(with: walkRightFrames, timePerFrame: 0.2)
		
		let moveRight = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkRight.duration)
		
		let animate = SKAction.group([walkRight, moveRight])
		self.guy?.run(animate, completion: {
			self.guyHex = hex
		})
	}
	
	func degreesToDirection(degrees: Int) -> HexDirection {
		
		var degrees = degrees
		if (degrees < 0) {
			degrees = degrees + 360
		}
		
		if 30 < degrees && degrees <= 90 {
			return .northeast
		} else if 90 < degrees && degrees <= 150 {
			return .southeast
		} else if 150 < degrees && degrees <= 210 {
			return .south
		} else if 210 < degrees && degrees <= 270 {
			return .southwest
		} else if 270 < degrees && degrees <= 330 {
			return .northwest
		} else {
			return .north
		}
	}
	
	func animateGuy(to hex: HexPoint) {
		
		let direction = degreesToDirection(degrees: self.mapDisplay.angle(from: self.guyHex, towards: hex))

		switch direction {
		case .north:
			self.animateGuyUp(to: hex)
			break
		case .northeast:
			self.animateGuyRight(to: hex)
			break
		case .southeast:
			self.animateGuyRight(to: hex)
			break
		case .south:
			self.animateGuyDown(to: hex)
			break
		case .southwest:
			self.animateGuyLeft(to: hex)
			break
		case .northwest:
			self.animateGuyLeft(to: hex)
			break
		}
	}
	
	func moveFocus(to hex: HexPoint) {
		self.focusSprite?.position = mapDisplay.toScreen(hex: hex)
		
		// TODO: run pathfinder instead
		self.animateGuy(to: hex)
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
