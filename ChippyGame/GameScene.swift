//
//  GameScene.swift
//  ChippyGame
//
//  Created by AJAY BAJWA on 2019-10-05.
//  Copyright © 2019 AJAY BAJWA. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var player:Player = Player(imageNamed: "player")
    var enemy:SKSpriteNode!
    //var playerBullet: SKSpriteNode!
    var playerBullet:Bullet = Bullet(imageNamed: "player_bullet")
    var enemyBullet:Bullet = Bullet(imageNamed: "enemyBullet")
    //var screenBorder:SKSpriteNode!
    var bulletsArray:[SKSpriteNode] = []
    var enemyBulletsArray:[SKSpriteNode] = []
    var upArrow:SKSpriteNode!
    var downArrow:SKSpriteNode!
    var leftArrow:SKSpriteNode!
    var rightArrow:SKSpriteNode!
    var upLeftArrow:SKSpriteNode!
    var downLeftArrow:SKSpriteNode!
    var upRightArrow:SKSpriteNode!
    var downRightArrow:SKSpriteNode!
    var arrowTouched:String = ""
    var touch:UITouch!
    var mouseX:CGFloat! = 100
    var mouseY:CGFloat! = 100
    var arrowButtonTouched = false
    var shootBullet = false
    var arrowButtonsRect:CGRect!
    
    override func didMove(to view: SKView) {
        // Set the background color of the app
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = SKColor.black;
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        print("screen: \(self.size.width), \(self.size.height)")
        
        self.player = Player(imageNamed: "player")
        self.player.size.width = self.size.width/15
        self.player.size.height = self.size.height/12
        self.player.position = CGPoint(x: self.size.width*0.2, y: self.size.height / 2)
        addChild(self.player)
        
        let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 30, height: 50), cornerRadius: 30)
        
        let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, duration: 5.0)
        let circleAnimation = followCircle.reversed()
        
        
        self.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            self.enemy = node as? SKSpriteNode
            self.enemy.run(SKAction.repeatForever(circleAnimation.reversed()))
        }
        
        self.leftArrow = SKSpriteNode(imageNamed: "left")
        self.leftArrow.size = CGSize(width: self.size.width/25, height: self.size.height/20)
        self.leftArrow.position = CGPoint(x: 100, y: 250)
        addChild(self.leftArrow)
        
        self.downArrow = SKSpriteNode(imageNamed: "down")
        self.downArrow.size = CGSize(width: self.size.height/20 , height: self.size.width/30)
        self.downArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width*1.5, y: self.leftArrow.position.y - self.leftArrow.size.height*1.5)
        addChild(self.downArrow)
        
        self.rightArrow = SKSpriteNode(imageNamed: "right")
        self.rightArrow.size = CGSize(width: self.size.width/25, height: self.size.height/20)
        self.rightArrow.position = CGPoint(x: self.downArrow.position.x + self.leftArrow.size.width*1.5, y: self.leftArrow.position.y)
        print("righ : \(self.rightArrow.position.x)")
        addChild(self.rightArrow)
        
        self.upArrow = SKSpriteNode(imageNamed: "up")
        self.upArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upArrow.position = CGPoint(x: self.downArrow.position.x, y: self.leftArrow.position.y + self.leftArrow.size.height*1.5)
        addChild(self.upArrow)
        
        self.upLeftArrow = SKSpriteNode(imageNamed: "upLeft")
        self.upLeftArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upLeftArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width*0.7, y: self.upArrow.position.y - self.upArrow.size.height*0.7)
        addChild(self.upLeftArrow)
        
        self.downLeftArrow = SKSpriteNode(imageNamed: "downLeft")
        self.downLeftArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.downLeftArrow.position = CGPoint(x: self.upLeftArrow.position.x, y: self.downArrow.position.y + self.downArrow.size.height*0.7)
        addChild(self.downLeftArrow)
        
        self.downRightArrow = SKSpriteNode(imageNamed: "downRight")
        self.downRightArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.downRightArrow.position = CGPoint(x: self.rightArrow.position.x - self.rightArrow.size.width*0.7, y: self.downLeftArrow.position.y)
        addChild(self.downRightArrow)
        
        self.upRightArrow = SKSpriteNode(imageNamed: "upRight")
        self.upRightArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upRightArrow.position = CGPoint(x: self.downRightArrow.position.x, y: self.upLeftArrow.position.y)
        addChild(self.upRightArrow)
        
        self.arrowButtonsRect = CGRect(x: 0, y: 0, width: self.rightArrow.position.x + self.rightArrow.size.width/2, height: self.upArrow.position.y + self.upArrow.size.height/2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.arrowButtonTouched == true {
            self.movePlayer()
        }
        if self.shootBullet == true{
            self.spawnPlayerBullet()
            self.moveBulletToTarget()
        }
        self.spawnEnemyBullet()
        self.removeBullet()
        self.bulletHitsEnemy()
        
    }
    func spawnPlayerBullet() {
        // 1. Make a bullet
        
        if(self.bulletsArray.count <= 1){
            self.playerBullet = Bullet(imageNamed: "player_bullet")
//            self.playerBullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "player_bullet"), size: self.playerBullet.size)
//            self.playerBullet.physicsBody?.affectedByGravity = false
//            self.playerBullet.physicsBody?.categoryBitMask = 1
//            self.playerBullet.physicsBody?.collisionBitMask = 0
            //self.playerBullet.physicsBody?.contactTestBitMask = 2
            self.playerBullet.size.width = self.player.size.width/2
            self.playerBullet.size.height = self.player.size.height/2
            self.playerBullet.position = CGPoint(x: self.player.position.x - 30, y: self.player.position.y)
            addChild(self.playerBullet)
            self.bulletsArray.append(self.playerBullet)
        }
        print("No. of bullets: \(self.bulletsArray.count)")
    }
    func spawnEnemyBullet(){
        
        if (self.enemyBulletsArray.count <= 10){
            // Shoot enemy Bullets in a cicular burst
//            for i in stride(from: 0.1, to: 2*CFloat.pi, by: 0.3){
//                self.enemyBullet = Bullet(imageNamed: "enemyBullet")
//                self.enemyBullet.position = CGPoint(x: 1480, y: 767)
//                self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
//                self.enemyBullet.physicsBody?.categoryBitMask = 3
//                self.enemyBullet.physicsBody?.collisionBitMask = 0
//                addChild(self.enemyBullet)
//                self.enemyBulletsArray.append(self.enemyBullet)
//                let x = 50*cos(i) + 1480
//                let y = 50*sin(i) + 767
//                print(x)
//                print(y)
//                let enemyBulletAction = SKAction.applyImpulse(
//                    CGVector(dx: CDouble(x - 1480), dy: CDouble(y - 767)),duration: 10)
//                self.enemyBullet.run(enemyBulletAction)
//
//            }
            if(self.enemyBulletsArray.count <= 100){
                //for i in stride(from: 0, to: 1, by: 1){
                //move up right
            self.enemyBullet = Bullet(imageNamed: "enemyBullet")
            self.enemyBullet.position = CGPoint(x: 1480, y: 767)
            self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
            self.enemyBullet.physicsBody?.categoryBitMask = 3
            self.enemyBullet.physicsBody?.collisionBitMask = 0
            addChild(self.enemyBullet)
            self.enemyBulletsArray.append(self.enemyBullet)
                
                
    
                let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2000, height: 2000), cornerRadius: 1000)
                let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, duration: 5.0)
                let circleAnimation = followCircle
                self.enemyBullet.run(SKAction.repeatForever(circleAnimation.reversed()))
                
                //}
                //move down left
                self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                self.enemyBullet.position = CGPoint(x: 1480, y: 767)
                self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                self.enemyBullet.physicsBody?.categoryBitMask = 3
                self.enemyBullet.physicsBody?.collisionBitMask = 0
                addChild(self.enemyBullet)
                //self.enemyBulletsArray.append(self.enemyBullet)
                
                let circle2 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: -2000, height: -2000), cornerRadius: 1000)
                
                let followCircle2 = SKAction.follow(circle2.cgPath, asOffset: true, orientToPath: false, duration: 5.0)
                let circleAnimation2 = followCircle2.reversed()
                
                self.enemyBullet.run(SKAction.repeatForever(circleAnimation2.reversed()))
                
                
                
                self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                self.enemyBullet.position = CGPoint(x: 1480, y: 767)
                self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                self.enemyBullet.physicsBody?.categoryBitMask = 3
                self.enemyBullet.physicsBody?.collisionBitMask = 0
                addChild(self.enemyBullet)
                self.enemyBulletsArray.append(self.enemyBullet)
                
                self.enemyBullet.run(SKAction.repeatForever(circleAnimation))
                
                
                
                self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                self.enemyBullet.position = CGPoint(x: 1480, y: 767)
                self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                self.enemyBullet.physicsBody?.categoryBitMask = 3
                self.enemyBullet.physicsBody?.collisionBitMask = 0
                addChild(self.enemyBullet)
                self.enemyBulletsArray.append(self.enemyBullet)
                
            self.enemyBullet.run(SKAction.repeatForever(circleAnimation2))
            }
            
            
//            for i in stride(from: 0.1, to: 2*CFloat.pi, by: 0.3){
//                self.enemyBullet = Bullet(imageNamed: "enemyBullet")
//                self.enemyBullet.position = CGPoint(x: 1480, y: 767)
//                self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
//                self.enemyBullet.physicsBody?.categoryBitMask = 3
//                self.enemyBullet.physicsBody?.collisionBitMask = 0
//                addChild(self.enemyBullet)
//                self.enemyBulletsArray.append(self.enemyBullet)
//                let x = 50*cos(i) + 1480
//                let y = 50*sin(i) + 767
//                print(x)
//                print(y)
//                let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 100), cornerRadius: 100)
//
//                let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, duration: 5.0)
//                let circleAnimation = followCircle.reversed()
//
//                self.enemyBullet.run(SKAction.repeatForever(circleAnimation.reversed()))
//                let enemyBulletAction = SKAction.applyImpulse(
//                    CGVector(dx: CDouble(x - 1480), dy: CDouble(y - 767)),duration: 10)
//                self.enemyBullet.run(enemyBulletAction)
//
//            }
            
        }
    }
    
    func removeEnemyBullets(){
        //Remove enemy bullets after they hit the borders
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
        else if (self.arrowTouched == "upRight")&&(self.player.position.x < self.size.width){
            let playerMove = SKAction.moveBy(x: 30, y: 30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / 4
            //self.player.position.x = self.player.position.x + 10
        }
        else if (self.arrowTouched == "downRight")&&(self.player.position.x < self.size.width)&&(self.player.position.y < self.size.height){
            let playerMove = SKAction.moveBy(x: 30, y: -30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / -4
            //self.player.position.x = self.player.position.x + 10
        }
            
        else if (self.arrowTouched == "downLeft")&&(self.player.position.x > 0)&&(self.player.position.y > 0){
            let playerMove = SKAction.moveBy(x: -30, y: -30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / -1.5
            //self.player.position.x = self.player.position.x + 10
        }
            
        else if (self.arrowTouched == "upLeft")&&(self.player.position.x > 0)&&(self.player.position.y < self.size.height){
            let playerMove = SKAction.moveBy(x: -30, y: 30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / 1.5
            //self.player.position.x = self.player.position.x + 10
        }
        
        // let indefiniteBulletMove = SKAction.repeatForever(moveBullet)
        
        //        else if (self.arrowTouched == "") {
        //            self.player.position = self.player.position
        //        }
        //self.player.texture = SKTexture(imageNamed: "up")
        
    }
    func removeBullet(){
        
        self.playerBullet.name = "playerBullet"
        self.enumerateChildNodes(withName: "playerBullet") {
            node, stop in
            if(self.bulletsArray.count != 0){
                if (node is SKSpriteNode) {
                    let sprite = node as! SKSpriteNode
                    // Check if the node is not in the scene
                    if (sprite.position.x < 100 || sprite.position.x > self.size.width - 100 || sprite.position.y < 100 || sprite.position.y > self.size.height - 100) {
                        // Remove the Sprite first from Parent then, from Array. else it does not completely removes the sprite and creates memory problems.
                        sprite.removeFromParent()
                        self.bulletsArray.removeFirst()
                        //print("no.of bullets(after crossing screen): \(self.bulletsArray.count)")
                    }
                    if sprite.intersects(self.enemy) {
                        //self.enemy.physicsBody = nil
                        sprite.removeFromParent()
                        self.bulletsArray.removeFirst()
                        print("no. of bullets after hitting: \(self.bulletsArray.count)")
                    }
                    
                }
            }
        }
    }
    func moveBulletToTarget() {
        
        let a = (self.mouseX - self.player.position.x);
        let b = (self.mouseY - self.player.position.y);
        //Caculating angle between a and b
        let angle = atan2(b, a)
        let angleDegrees = angle * (180 / CGFloat.pi);
        //print("Angle: \(angleDegrees)")
        // turning the bullet to destination direction
        self.playerBullet.zRotation = angle
        
        var destination1 = CGPoint.zero
        if b > 0 {
            // move bullet to the top of screen
            destination1.y = self.size.height + self.enemy.size.height*2
        } else {
            // move bullet to the bottom of screen
            destination1.y = -self.enemy.size.height*2
        }
        // X position of destination in proportion to the the Y Position
        destination1.x = self.player.position.x +
            ((destination1.y - self.player.position.y) / b * a)
        
        var destination2 = CGPoint.zero
        if a > 0 {
            // move the bullet to the right of screen
            destination2.x = self.size.width + self.enemy.size.width*2
        } else {
            //move the bullet to the left of screen
            destination2.x = -self.enemy.size.width*2
        }
        destination2.y = self.player.position.y +
            ((destination2.x - self.player.position.x) / a * b)
        
        var destination:CGPoint!
        //comparing the absolute Coordinate values of destination
        if abs(destination1.x) < abs(destination2.x) || abs(destination1.y) < abs(destination2.y) {
            destination = destination1
        }
        else {
            destination = destination2
        }
        
        let bulletAction = SKAction.move(to: destination, duration: 0.7)
        self.playerBullet.run(bulletAction)
        
//        let bulletVector = CGVector(dx: destination.x - self.player.position.x, dy: destination.y - self.player.position.y)
//        // Shoot the bullet to destination
//        self.playerBullet.physicsBody?.velocity = bulletVector
    }
    
    
    func bulletHitsEnemy(){
        self.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            self.enemy = node as? SKSpriteNode
            if self.playerBullet.intersects(self.enemy){
                self.enemy.removeFromParent()
                self.removeBullet()
                print("enemy removed")
            }
        }
    }
    
    func checkArrowTouched(){
        
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
        else if self.upRightArrow.contains(touch.location(in: self)) {
            print("UpRight touched")
            self.arrowTouched = "upRight"
        }
        else if self.downRightArrow.contains(touch.location(in: self)) {
            print("downRight touched")
            self.arrowTouched = "downRight"
        }
        else if self.upLeftArrow.contains(touch.location(in: self)) {
            print("upLeft touched")
            self.arrowTouched = "upLeft"
        }
        else if self.downLeftArrow.contains(touch.location(in: self)) {
            print("downLeft touched")
            self.arrowTouched = "downLeft"
        }
    }
    
    override
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        //let touch = touches.first!
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
        
        self.player.size.height = self.player.size.height - self.player.size.height/3
        
        if (self.arrowButtonsRect.contains(touch.location(in: self))){
            self.arrowButtonTouched = true
            self.checkArrowTouched()
        }
        else {
            self.shootBullet = true
            //self.spawnBulletsCallBack()
        }
        
        
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }
        
        print(mousePosition)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        //let touch = touches.first!
        
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
        
        if (self.arrowButtonsRect.contains(touch.location(in: self))){
            self.arrowButtonTouched = true
            self.checkArrowTouched()
        }
        else{
            self.shootBullet = false
            self.spawnPlayerBullet()
            self.moveBulletToTarget()
        }
        
        //self.callback()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.arrowTouched = ""
        self.shootBullet = false
        self.arrowButtonTouched = false
        self.shootBullet = false
        self.player.size.height = self.size.height/12
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
    @objc func spawnBulletsCallBack(){
        self.spawnPlayerBullet()
        self.moveBulletToTarget()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if (self.shootBullet == true){
                self.spawnBulletsCallBack()
            }
        }
    }
    
}

