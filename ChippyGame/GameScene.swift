//
//  GameScene.swift
//  ChippyGame
//
//  Created by AJAY BAJWA on 2019-10-05.
//  Copyright © 2019 AJAY BAJWA. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player:Player = Player(imageNamed: "player")
    //var playerBullet: SKSpriteNode!
    var bulletPiece:Bullet = Bullet(imageNamed: "player_bullet")
    var bulletsArray:[SKSpriteNode] = []
    var upArrow:SKSpriteNode!
    var downArrow:SKSpriteNode!
    var leftArrow:SKSpriteNode!
    var rightArrow:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // Set the background color of the app
        self.backgroundColor = SKColor.black;
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        print("screen: \(self.size.width), \(self.size.height)")
        
        self.player = Player(imageNamed: "player")
        self.player.size.width = self.size.width/13
        self.player.size.height = self.size.height/10
        self.player.position = CGPoint(x: self.size.width - 400, y: self.size.height / 2)
        addChild(self.player)
        
        self.leftArrow = SKSpriteNode(imageNamed: "left")
        self.leftArrow.size = CGSize(width: self.size.width/15, height: self.size.height/10)
        self.leftArrow.position = CGPoint(x: 150, y: 300)
        addChild(self.leftArrow)
        
        self.downArrow = SKSpriteNode(imageNamed: "down")
        self.downArrow.size = CGSize(width: self.size.height/10 , height: self.size.width/15)
        self.downArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width, y: self.leftArrow.position.y - self.leftArrow.size.height*0.8)
        addChild(self.downArrow)
        
        self.rightArrow = SKSpriteNode(imageNamed: "right")
        self.rightArrow.size = CGSize(width: self.size.width/15, height: self.size.height/10)
        self.rightArrow.position = CGPoint(x: self.downArrow.position.x + self.leftArrow.size.width, y: self.leftArrow.position.y)
        addChild(self.rightArrow)
        
        self.upArrow = SKSpriteNode(imageNamed: "up")
        self.upArrow.size = CGSize(width: self.size.height/10, height: self.size.width/15)
        self.upArrow.position = CGPoint(x: self.downArrow.position.x, y: self.leftArrow.position.y + self.leftArrow.size.height*0.8)
        addChild(self.upArrow)
        
        //self.buildTower()
        
        
        
    }
//    func spawnBullet() {
//        // 1. Make a bullet
//
//        let bullet = player.bulletPiece
//        bullet.size.width = self.size.width/2
//        bullet.size.height = self.size.height/2
//
//        if(self.bulletsArray.count == 0){
//            bullet.position = CGPoint(x: self.player.position.x-100, y: self.player.position.y)
//            //addChild(bullet)
//        }
//        else{
//            let previousBullet = self.bulletsArray[self.bulletsArray.count - 1]
//            bullet.position = CGPoint(x: previousBullet.position.x-200, y: self.player.position.y)
//            //addChild(bullet)
//        }
//        addChild(bullet)
//        self.bulletsArray.append(bullet)
//        print("size of bullets: \(self.bulletsArray.count)")
//        print("x of bullet: \(self.bulletsArray[self.bulletsArray.count-1].position.x)" )
//    }
    func spawnPlayerBullet() {
        // 1. Make a bullet
        
        //self.bullet = Bullet(imageNamed: "player_bullet")
        let playerBullet = Bullet(imageNamed: "player_bullet")
        playerBullet.size.width = self.player.size.width/2
        playerBullet.size.height = self.player.size.height/2
        
        if(self.bulletsArray.count == 0){
            playerBullet.position = CGPoint(x: self.player.position.x-100, y: self.player.position.y)
            addChild(playerBullet)
            self.bulletsArray.append(playerBullet)
        }
        else{
            let previousBullet = self.bulletsArray[self.bulletsArray.count - 1]
            playerBullet.position = CGPoint(x: previousBullet.position.x-200, y: self.player.position.y)
            addChild(playerBullet)
            self.bulletsArray.append(playerBullet)
        }
        
        
        print("size of bullets: \(self.bulletsArray.count)")
        print("x of bullet: \(self.bulletsArray[self.bulletsArray.count-1].position.x)" )
    }
//    func buildTower() {
//        for _ in 0...5 {
//            self.spawnPlayerBullet()
//        }
//    }
    
    override
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        let touch = touches.first!
        if player.contains(touch.location(in: self)) {
            print("touched")
        }
        
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }
        
        print(mousePosition)
        
        
        self.spawnPlayerBullet()
    }
    
}

