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
		scene.scaleMode = .resizeFill

		if let skView = view as? SKView {
			skView.showsFPS = true
			skView.showsNodeCount = true
			skView.ignoresSiblingOrder = true
			skView.presentScene(scene)
		}
	}
}
