//
//  GameViewController.swift
//  agents
//
//  Created by Michael Rommel on 18.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let scene = GameScene(size: view.bounds.size)
		scene.viewController = self
		let skView = view as! SKView
		skView.showsFPS = true
		skView.showsNodeCount = true
		skView.ignoresSiblingOrder = true
		scene.scaleMode = .resizeFill
		skView.presentScene(scene)
	}
}

