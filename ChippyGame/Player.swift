//
//  Player.swift
//  ChippyGame
//
//  Created by AJAY BAJWA on 2019-10-05.
//  Copyright © 2019 AJAY BAJWA. All rights reserved.
//

import Foundation
import SpriteKit

// custom SpriteNode class.
class Player: SKSpriteNode {
    var bulletPiece: SKSpriteNode!
    //var bullets:[SKSpriteNode] = []
    
    // MARK: Variables
    // --------------------------------
    
    
    // MARK: Constructor - required nonsense
    // --------------------------------
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    
        
    }
    
    // Required nonsense
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // Mark:  Functions
    // --------------------------------
}
