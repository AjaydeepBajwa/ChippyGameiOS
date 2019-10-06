//
//  DirectionArrow.swift
//  ChippyGame
//
//  Created by AJAY BAJWA on 2019-10-06.
//  Copyright © 2019 AJAY BAJWA. All rights reserved.
//

import Foundation
import SpriteKit

// A custom SpriteNode class.
// Used to represent a piece of sushi in the tower.
class DirectionArrow: SKSpriteNode {
    //var bullets:[SKSpriteNode] = []
    var upArrow:SKSpriteNode!
    var downArrow:SKSpriteNode!
    var leftArrow:SKSpriteNode!
    var rightArrow:SKSpriteNode!
    // MARK: Variables
    // --------------------------------
    
    
    // MARK: Constructor - required nonsense
    // --------------------------------
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
//        self.leftArrow = SKSpriteNode(imageNamed: "left")
//        self.leftArrow.size = CGSize(width: self.size.width/15, height: self.size.height/10)
//        self.leftArrow.position = CGPoint(x: 150, y: 300)
//        addChild(self.leftArrow)
//        
//        self.downArrow = SKSpriteNode(imageNamed: "down")
//        self.downArrow.size = CGSize(width: self.size.height/10 , height: self.size.width/15)
//        self.downArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width, y: self.leftArrow.position.y - self.leftArrow.size.height*0.8)
//        addChild(self.downArrow)
//        
//        self.rightArrow = SKSpriteNode(imageNamed: "right")
//        self.rightArrow.size = CGSize(width: self.size.width/15, height: self.size.height/10)
//        self.rightArrow.position = CGPoint(x: self.downArrow.position.x + self.leftArrow.size.width, y: self.leftArrow.position.y)
//        addChild(self.rightArrow)
//        
//        self.upArrow = SKSpriteNode(imageNamed: "up")
//        self.upArrow.size = CGSize(width: self.size.height/10, height: self.size.width/15)
//        self.upArrow.position = CGPoint(x: self.downArrow.position.x, y: self.leftArrow.position.y + self.leftArrow.size.height*0.8)
//        addChild(self.upArrow)
//        
        
    }
    
    // Required nonsense
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // Mark:  Functions
    // --------------------------------
}
