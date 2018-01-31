//
//  GameViewController.swift
//  IsoGame
//
//  Created by Dave Longbottom on 16/01/2015.
//  Copyright (c) 2015 Big Sprite Games. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
	
	//1
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//2
	let view2D: SKSpriteNode
	let layer2DHighlight: SKNode
	
	let viewHex: SKSpriteNode
	let layerHexGround: SKNode
	let layerHexObjects: SKNode
	
	let mapDisplay = HexMapDisplay()
	let map = TileHexMap(width: 15, height: 15, initialValue: Tile(withTerrain: .ocean))
	
	let nthFrame = 6
	var nthFrameCount = 0
	
	var cam: SKCameraNode!
	
	//4
	override init(size: CGSize) {
		
		view2D = SKSpriteNode()
		layer2DHighlight = SKNode()
		
		viewHex = SKSpriteNode()
		layerHexGround = SKNode()
		layerHexObjects = SKNode()
		
		// map
		map.set(tile: Tile(withTerrain: .grass), at: HexPoint(x: 5, y: 4))
		
		super.init(size: size)
		self.anchorPoint = CGPoint(x:0.5, y:0.2)
	}
	
	//5
	override func didMove(to view: SKView) {
		
		let deviceScale = self.size.width/667

		view2D.position = CGPoint(x: -self.size.width * 0.48, y: self.size.height * 0.43)
		let view2DScale = CGFloat(0.4)
		view2D.xScale = deviceScale * view2DScale
		view2D.yScale = deviceScale * view2DScale
		addChild(view2D)
		layer2DHighlight.zPosition = 999
		view2D.addChild(layer2DHighlight)
		
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
	}
	
	func placeTileHex(tile: Tile, position: CGPoint) {
		
		// place terrain
		let tileSprite = SKSpriteNode(imageNamed: tile.terrain.textureNameHex)
		tileSprite.position = position		
		tileSprite.anchorPoint = CGPoint(x:0, y:0)
		layerHexGround.addChild(tileSprite)
		
		// place forests etc
		//layerHexObjects.addChild(tileSprite)
	}
	
	func placeAllTilesHex() {
		
		for i in 0..<map.tiles.columns {
			for j in 0..<map.tiles.rows {
				let tile = map.tiles[i, j]
				let pt = HexPoint(x: i, y: j)
				let screenPoint = mapDisplay.toScreen(hex: pt)
				
				placeTileHex(tile: tile, position: screenPoint)
			}
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
	
	func highlightPath2D(path: [HexPoint]) {
		
		//clear previous path
		layer2DHighlight.removeAllChildren()
		
		/*for i in 0..<path.count {
			let highlightTile = SKSpriteNode(imageNamed: Terrain.grass.textureName)
			highlightTile.position = pointTileIndexToPoint2D(point: path[i])
			highlightTile.anchorPoint = CGPoint(x: 0, y: 0)
			
			highlightTile.color = SKColor(red: 1.0, green: 0, blue: 0, alpha: 0.25+((CGFloat(i)/CGFloat(path.count))*0.25))
			highlightTile.colorBlendFactor = 1.0
			
			layer2DHighlight.addChild(highlightTile)
		}*/
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		//////////////////////////////////////////////////////////
		// Original code that we still need
		//////////////////////////////////////////////////////////
		
		let touch = touches.first!
		let touchLocation = touch.location(in: viewHex)
		
	}
	
	// moving the map around
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		for touch in touches {
			let location = touch.location(in: self.layerHexGround)
			let previousLocation = touch.previousLocation(in: self.layerHexGround)
			let deltaX = (location.x) - (previousLocation.x)
			let deltaY = (location.y) - (previousLocation.y)
			
			print("moved: \(deltaX), \(deltaY)")
			self.cam.position.x -= deltaX * 0.5
			self.cam.position.y -= deltaY * 0.5
		}
	}
	
	override func update(_ currentTime: CFTimeInterval) {
		
		/*hero.tileSpriteIso.position = point2DToIso(p: hero.tileSprite2D.position)
		
		nthFrameCount += 1
		
		if (nthFrameCount == nthFrame) {
			nthFrameCount = 0
			updateOnNthFrame()
		}*/
	}
	func updateOnNthFrame() {
		
		//sortDepth()
	}
}
