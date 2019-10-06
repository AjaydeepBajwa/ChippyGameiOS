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
        
        //        while(isTouched == true){
        //            self.movePlayer()
        //        }
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
    //    func buildTower() {
    //        for _ in 0...5 {
    //            self.spawnPlayerBullet()
    //        }
    //    }
    func movePlayer(){
        if ((self.arrowTouched == "up")&&(self.player.position.y < self.size.height)){
            let playerMove = SKAction.moveBy(x: 0, y: 30, duration: 0.01)
//            let playerRotate = SKAction.rotate(toAngle: , duration: 0, shortestUnitArc: false)
//            let playerAnimation = SKAction.sequence([playerMove,playerRotate])
            self.player.run(playerMove)
            //self.player.position.y = self.player.position.y + 5
        }
        else if (self.arrowTouched == "down")&&(self.player.position.y > 0){
            //self.player.position.y = self.player.position.y - 5
            let playerMove = SKAction.moveBy(x: 0, y: -30, duration: 0.01)
            self.player.run(playerMove)
        }
        else if (self.arrowTouched == "left")&&(self.player.position.x > 0 ){
            let playerMove = SKAction.moveBy(x: -30, y: 0, duration: 0.01)
            self.player.run(playerMove)
            //self.player.position.x = self.player.position.x - 10
        }
        else if (self.arrowTouched == "right")&&(self.player.position.x < self.size.width){
            let playerMove = SKAction.moveBy(x: 30, y: 0, duration: 0.01)
            self.player.run(playerMove)
            //self.player.position.x = self.player.position.x + 10
        }
        
        // let indefiniteBulletMove = SKAction.repeatForever(moveBullet)
        
        //        else if (self.arrowTouched == "") {
        //            self.player.position = self.player.position
        //        }
        //self.player.texture = SKTexture(imageNamed: "up")
        
    }
    //var numLoops = 0
    override func update(_ currentTime: TimeInterval) {
        
        //        numLoops = numLoops + 1
        //        if (numLoops % 30 == 0) {
        //            // make a cat
        //            while(isTouched == true){
        //            self.movePlayer()
        //        }
    }
    
    override
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        //let touch = event!.allTouches!.first!
        //self.isTouched = true
        if self.upArrow.contains(touch.location(in: self)) {
            print("up touched")
            self.arrowTouched = "up"
            //self.player.zRotation = .pi / 2
            let facingUp = SKAction.rotate(toAngle: 70, duration: 0)
            self.player.run(facingUp)
            //self.player.position.y = self.player.position.y + 20
        }
        else if self.downArrow.contains(touch.location(in: self)) {
            print("down touched")
            self.arrowTouched = "down"
            let facingDown = SKAction.rotate(toAngle: -70, duration: 0)
            self.player.run(facingDown)
            //self.player.position.y = self.player.position.y - 20
        }
        else if self.leftArrow.contains(touch.location(in: self)) {
            print("left touched")
            self.arrowTouched = "left"
            //self.player.size.height = self.player.size.height - self.player.size.height/3
            let facingLeft = SKAction.rotate(toAngle: 180, duration: 0)
            self.player.run(facingLeft)
            //self.player.position.x = self.player.position.x - 20
        }
        else if self.rightArrow.contains(touch.location(in: self)) {
            print("right touched")
            self.arrowTouched = "right"
           // self.player.size.height = self.player.size.height + self.player.size.height/3
            let facingRight = SKAction.rotate(toAngle: 0, duration: 0)
            self.player.run(facingRight)
            //self.player.position.x = self.player.position.x + 20
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
        self.touch = touches.first!
        //self.isTouched = true
        if self.upArrow.contains(touch.location(in: self)) {
            print("up touched")
            self.arrowTouched = "up"
            let facingUp = SKAction.rotate(toAngle: .pi/2, duration: 0)
            self.player.run(facingUp)
            //self.player.position.y = self.player.position.y + 20
        }
        else if self.downArrow.contains(touch.location(in: self)) {
            print("down touched")
            self.arrowTouched = "down"
            let facingDown = SKAction.rotate(toAngle: .pi / -2, duration: 0)
            self.player.run(facingDown)
            //self.player.position.y = self.player.position.y - 20
        }
        else if self.leftArrow.contains(touch.location(in: self)) {
            print("left touched")
            self.arrowTouched = "left"
            let facingLeft = SKAction.rotate(toAngle: 180, duration: 0)
            self.player.run(facingLeft)
////            let facingLeft = SKAction.scaleX(to: 1, duration: 0)
//            self.player.run(facingLeft)
            //self.player.size.height = self.player.size.height - self.player.size.height/3
            //self.player.position.x = self.player.position.x - 20
        }
        else if self.rightArrow.contains(touch.location(in: self)) {
            print("right touched")
            self.arrowTouched = "right"
            let facingRight = SKAction.rotate(toAngle: 0, duration: 0)
            self.player.run(facingRight)
//            let facingRight = SKAction.scaleX(to: -1, duration: 0)
//            self.player.run(facingRight)
            //self.player.size.height = self.player.size.height + self.player.size.height/3
            //self.player.position.x = self.player.position.x + 20
        }
        self.movePlayer()
        //self.callback()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.arrowTouched = ""
        //self.isTouched = false
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

