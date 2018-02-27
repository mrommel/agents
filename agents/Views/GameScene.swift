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
		static let area: CGFloat = 2.0
		static let focus: CGFloat = 3.0
		static let feature: CGFloat = 4.0
		static let staticSprite: CGFloat = 5.0
		static let sprite: CGFloat = 6.0
		static let labels: CGFloat = 50.0
	}
}

protocol AreaDelegate {
	func changed(area: Area?)
}

class Area {
	
	var onPointsChanged: ((_ points: [HexPoint])->())?
	
	var identifier: String
	var points: [HexPoint] {
		didSet {
			onPointsChanged?(points)
		}
	}
	
	init(with identifier: String) {
		self.identifier = identifier
		self.points = []
	}
	
	func add(point: HexPoint) {
		self.points.append(point)
	}
}

class AreaSprites {
	
	private let node: SKNode?
	private let mapDisplay: HexMapDisplay?
	private var sprites: [SKSpriteNode]
	
	init(on node: SKNode?, with mapDisplay: HexMapDisplay?) {
		self.node = node
		self.mapDisplay = mapDisplay
		self.sprites = []
	}
	
	func texture(for point: HexPoint, in points: [HexPoint]) -> String {
		
		var tex = "hex_border_"
		
		if !points.contains(where: { $0 == point.neighbor(in: .north) }) {
			tex += "n_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .northeast) }) {
			tex += "ne_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .southeast) }) {
			tex += "se_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .south) }) {
			tex += "s_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .southwest) }) {
			tex += "sw_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .northwest) }) {
			tex += "nw_"
		}
		
		if tex == "hex_border_" {
			return "hex_border_all"
		}
		
		tex.removeLast()
		return tex
	}
	
	func rebuild(with points: [HexPoint]) {
		
		// remove old sprites
		for sprite in self.sprites {
			sprite.removeFromParent()
		}
		self.sprites.removeAll()
		
		for point in points {
			
			if let position = self.mapDisplay?.toScreen(hex: point) {
			
				// missing:
				// * hex_border_n_ne_s_sw_nw,
				// * hex_border_n_ne_s_nw,
				// * hex_border_n_se_s_sw_nw
				let textureName = self.texture(for: point, in: points)
				let sprite = SKSpriteNode(imageNamed: textureName)
				sprite.position = position
				sprite.zPosition = GameSceneConstants.ZLevels.area
				sprite.anchorPoint = CGPoint(x: 0, y: 0)
				self.node?.addChild(sprite)
			}
		}
	}
}

class GameScene: SKScene {
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var viewController: UIViewController?
	
	let viewHex: SKSpriteNode
	let layerHexGround: SKNode
	let layerHexObjects: SKNode
	var focusSprite: SKSpriteNode?
	
	var engine: GameObjectEngine? = nil
	
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
		placeGameObjects()
		
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
	
	func placeGameObjects() {
		
		self.engine = GameObjectEngine(on: layerHexGround, in: self)
		
		let professor = Professor(with: "professor", at: HexPoint(x: 0, y: 0), mapDisplay: self.mapDisplay)
		self.engine?.add(gameObject: professor)
		
		let egyptLady = EgyptLady(with: "egyptLady", at: HexPoint(x: 1, y: 1), mapDisplay: self.mapDisplay)
		self.engine?.add(gameObject: egyptLady)
		
		let rabbit = Rabbit(with: "rabbit", at: HexPoint(x: 3, y: 2), mapDisplay: self.mapDisplay)
		self.engine?.add(gameObject: rabbit)
		
		let areaSprites = AreaSprites(on: layerHexGround, with: self.mapDisplay)
		
		let area = Area(with: "red")
		area.onPointsChanged = { points in
			print("now we have \(points.count) pts")
			areaSprites.rebuild(with: points)
		}
		area.add(point: HexPoint(x: 0,y: 0))
		area.add(point: HexPoint(x: 1,y: 0))
		area.add(point: HexPoint(x: 0,y: 1))
	}
	
	func placeTileHex(tile: Tile, position: CGPoint) {
		
		// place terrain
		let terrainSprite = SKSpriteNode(imageNamed: tile.terrain.textureNameHex)
		terrainSprite.position = position
		terrainSprite.zPosition = GameSceneConstants.ZLevels.terrain
		terrainSprite.anchorPoint = CGPoint(x: 0, y: 0)
		layerHexGround.addChild(terrainSprite)
		
		tile.terrainSprite = terrainSprite
		
		// place forests etc
		for feature in tile.features {
			let featureSprite = SKSpriteNode(imageNamed: feature.textureNameHex)
			featureSprite.position = position
			featureSprite.zPosition = GameSceneConstants.ZLevels.feature // maybe need to come from feature itself
			featureSprite.anchorPoint = CGPoint(x: 0, y: 0)
			layerHexObjects.addChild(featureSprite)
			
			tile.featureSprites.append(featureSprite)
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
		
		if let currentFocusedObject = self.engine?.focusedObject {
			if currentFocusedObject.state == GameObjectActions.walk {
				
				if let path = self.findPathFrom(from: currentFocusedObject.position, to: hex) {
					currentFocusedObject.walk(on: path)
					return
				}
			}
		}
		
		if let focusedObject = self.engine?.object(at: hex) {
			
			if focusedObject != self.engine?.focusedObject {
				self.engine?.focusedObject = focusedObject
				print("new focused object: \(focusedObject.identifier)")
			} else {
				if let actions = self.engine?.focusedObject?.actions() {
					showActionPicker(for: (self.engine?.focusedObject!)!, with: actions)
				}
			}
		}
	}
	
	func showActionPicker(for gameObject: GameObject, with gameObjectActions: [GameObjectAction]) {
		let alertController = UIAlertController(title: gameObject.identifier, message: "What would you like to do?", preferredStyle: .actionSheet)
		
		for gameObjectAction in gameObjectActions {
			let actionButton = UIAlertAction(title: gameObjectAction.identifier, style: .default, handler: { (action) -> Void in
				gameObject.execute(action: gameObjectAction)
			})
			alertController.addAction(actionButton)
		}
		
		let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
			print("Cancel button tapped")
		})
		alertController.addAction(cancelButton)

		self.viewController?.navigationController!.present(alertController, animated: true, completion: nil)
	}
	
	func showNeighborPicker(of gameObject: GameObject, for gameObjectAction: GameObjectActionWithPoint) {
		let alertController = UIAlertController(title: gameObject.identifier, message: "Where?", preferredStyle: .actionSheet)
		
		for direction in HexDirection.all {
			
			let neighbor = gameObject.position.neighbor(in: direction)
			if gameObject.canApply(action: gameObjectAction, on: neighbor) {
				
				let actionButton = UIAlertAction(title: "\(direction)", style: .default, handler: { (action) -> Void in
					gameObjectAction.point = neighbor
					gameObject.execute(action: gameObjectAction)
				})
				
				if let image = direction.pickerImage {
					actionButton.setValue(image, forKey: "image")
				}
				alertController.addAction(actionButton)
			}
		}

		let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
			print("Cancel button tapped")
		})
		alertController.addAction(cancelButton)
		
		self.viewController?.navigationController!.present(alertController, animated: true, completion: nil)
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
		self.engine?.update(with: currentTime)
	}
}

