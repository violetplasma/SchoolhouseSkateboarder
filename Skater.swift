//
//  Skater.swift
//  SchoolhouseSkateboarder
//
//  Created by Mac User on 12/27/18.
//  Copyright © 2018 Mac User. All rights reserved.
//

import SpriteKit

class Skater: SKSpriteNode {
    var velocity = CGPoint.zero
    var minimumY: CGFloat = 0.0
    var jumpSpeed:CGFloat = 20.0
    var isOnGround = true

}
