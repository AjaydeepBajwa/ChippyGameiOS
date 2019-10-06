//
//  Enemy.swift
//  ChippyGame
//
//  Created by AJAY BAJWA on 2019-10-05.
//  Copyright © 2019 AJAY BAJWA. All rights reserved.
//

import Foundation
import SpriteKit

// A custom SpriteNode class.
// Used to represent a piece of sushi in the tower.
class Enemy: SKSpriteNode {
    var bulletPiece: SKSpriteNode!
    //var bullets:[SKSpriteNode] = []
    
    // MARK: Variables
    // --------------------------------
    
    
    // MARK: Constructor - required nonsense
    // --------------------------------
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        //self.texture = SKTexture(imageNamed: "roll")
        //        self.bullet = SKSpriteNode(imageNamed:"player")
        //        self.bullet.position.y = 500
        //        self.bullet.position.x = 800
        //        addChild(self.bullet)
        
        //self.spawnBullet()
        
        
        
        
    }
    
    // Required nonsense
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

