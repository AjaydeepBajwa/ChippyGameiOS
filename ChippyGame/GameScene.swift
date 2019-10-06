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
    var arrowTouched:String = ""
    var touch:UITouch!
    var isTouched:Bool = false
    
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
        
        
    }
    func spawnPlayerBullet() {
        // 1. Make a bullet
        
        let playerBullet = Bullet(imageNamed: "player_bullet")
        playerBullet.size.width = self.player.size.width/2
        playerBullet.size.height = self.player.size.height/2
        
        //if(self.bulletsArray.count == 0){
        playerBullet.position = CGPoint(x: self.player.position.x - 30, y: self.player.position.y)
        addChild(playerBullet)
        self.bulletsArray.append(playerBullet)
        //}
        //        else{
        //            let previousBullet = self.bulletsArray[self.bulletsArray.count - 1]
        //            playerBullet.position = CGPoint(x: previousBullet.position.x-200, y: self.player.position.y)
        //            addChild(playerBullet)
        //            self.bulletsArray.append(playerBullet)
        //        }
        let moveBullet = SKAction.moveBy(x: -50, y: 0, duration: 0.05)
        let indefiniteBulletMove = SKAction.repeatForever(moveBullet)
        playerBullet.run(indefiniteBulletMove)
        
        
        
        print("size of bullets: \(self.bulletsArray.count)")
        print("x of bullet: \(self.bulletsArray[self.bulletsArray.count-1].position.x)" )
    }

    func movePlayer(){
        
        if ((self.arrowTouched == "up")&&(self.player.position.y < self.size.height)){
            let playerMove = SKAction.moveBy(x: 0, y: 30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / 2
        }
        else if (self.arrowTouched == "down")&&(self.player.position.y > 0){
            let playerMove = SKAction.moveBy(x: 0, y: -30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / -2
        }
        else if (self.arrowTouched == "left")&&(self.player.position.x > 0 ){
            let playerMove = SKAction.moveBy(x: -30, y: 0, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi
            //self.player.position.x = self.player.position.x - 10
        }
        else if (self.arrowTouched == "right")&&(self.player.position.x < self.size.width){
            let playerMove = SKAction.moveBy(x: 30, y: 0, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = 0
            //self.player.position.x = self.player.position.x + 10
        }
        
        // let indefiniteBulletMove = SKAction.repeatForever(moveBullet)
        
        //        else if (self.arrowTouched == "") {
        //            self.player.position = self.player.position
        //        }
        //self.player.texture = SKTexture(imageNamed: "up")
        
    }

    override
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        //self.touch = touches.first!
        let touch = touches.first!
    
        self.player.size.height = self.player.size.height - self.player.size.height/3
        
        if self.upArrow.contains(touch.location(in: self)) {
            print("up touched")
            self.arrowTouched = "up"
            
            
        }
        else if self.downArrow.contains(touch.location(in: self)) {
            print("down touched")
            self.arrowTouched = "down"

        }
        else if self.leftArrow.contains(touch.location(in: self)) {
            print("left touched")
            self.arrowTouched = "left"
        }
        else if self.rightArrow.contains(touch.location(in: self)) {
            print("right touched")
            self.arrowTouched = "right"
        }
        else{
            self.spawnPlayerBullet()
        }
        
        //self.movePlayer()
        self.callback()
        
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }
        
        print(mousePosition)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.isMultipleTouchEnabled = true
        //self.touch = touches.first!
        let touch = touches.first!
        if self.upArrow.contains(touch.location(in: self)) {
            print("up touched")
            self.arrowTouched = "up"
        }
        else if self.downArrow.contains(touch.location(in: self)) {
            print("down touched")
            self.arrowTouched = "down"
            
        }
        else if self.leftArrow.contains(touch.location(in: self)) {
            print("left touched")
            self.arrowTouched = "left"

        }
        else if self.rightArrow.contains(touch.location(in: self)) {
            print("right touched")
            self.arrowTouched = "right"
            
        }
        self.movePlayer()
        //self.callback()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.arrowTouched = ""
        self.player.size.height = self.size.height/10
        //self.player.texture = SKTexture(imageNamed: "player")
    }
    
    @objc func callback() {
        self.movePlayer()
        // loop in a non blocking way after 0.1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if (self.arrowTouched != "") {
                self.callback()
            }
        }
    }
    
}

