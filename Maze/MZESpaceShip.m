//
//  MZESpaceShip.m
//  Maze
//
//  Created by Sagar Patel on 7/22/13.
//  Copyright (c) 2013 Sagar Patel. All rights reserved.
//

#import "MZESpaceShip.h"
@interface MZESpaceShip ()
@property BOOL contentCreated;

@end
@implementation MZESpaceShip
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if(self)
    {
        self.backgroundColor = [SKColor darkGrayColor];
        self.scaleMode = SKSceneScaleModeAspectFit;
        //self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGPointMake(0, 0);
    }
    return self;
}
- (void)didMoveToView:(SKView *)view
{
    if(!_contentCreated)
    {
        [self createSceneContents];
        _contentCreated = YES;
    }
}
- (void)createSceneContents
{
    SKSpriteNode *spaceShip = [self newSpaceShip];
    spaceShip.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:spaceShip];
    
    SKAction *makeRocks = [SKAction sequence:@[[SKAction performSelector:@selector(addRock) onTarget:self], [SKAction waitForDuration:0.5 withRange:0.15]]];
    [self runAction:[SKAction repeatAction:makeRocks count:100]];
}
- (SKSpriteNode *)newSpaceShip
{
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    SKAction *hover = [SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction moveByX:100 y:50 duration:1.0], [SKAction waitForDuration:1.0],[SKAction moveByX:-100 y:-50 duration:1]]];
    //[hull runAction:[SKAction repeatAction:hover count:3]];
    hull.name = @"ship";
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.affectedByGravity = NO;
    hull.physicsBody.allowsRotation = NO;
    hull.physicsBody.dynamic = NO;
    hull.physicsBody.categoryBitMask = 0x1 << 1;
    hull.physicsBody.collisionBitMask = 0x1 << 0;
    hull.physicsBody.contactTestBitMask = 0x1 << 0;

    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-28, 6.0);
    [hull addChild:light1];

    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(28, 6.0);
    [hull addChild:light2];
    return hull;
}
- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8, 8)];
    SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.25], [SKAction fadeInWithDuration:0.25]]];
    [light runAction:[SKAction repeatActionForever:blink]];
    return light;
}
static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}
- (void)addRock
{
    CGFloat height, width;
    if (rand() % 2 == 0)
    {
        height = 10;
        width = 8;
    }
    else
    {
        width = 10;
        height = 8;
    }
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(width, height)];
    rock.position = CGPointMake(skRand(0, self.size.width), skRand(0, self.size.height - 50));
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
//    rock.physicsBody.affectedByGravity = NO;
    rock.physicsBody.categoryBitMask = 0x1 << 0;
    rock.physicsBody.collisionBitMask = 0x1 << 0 | 0x1 << 1;
    rock.physicsBody.contactTestBitMask = 0x1 << 0 | 0x1 << 1;
    [self addChild:rock];
}
- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.y < 0)
        {
            [node removeFromParent];
            return;
        }
        CGPoint ship = [self childNodeWithName:@"ship"].position;
        CGPoint point = CGPointMake(ABS(node.position.x - ship.x), ABS(node.position.y - ship.y));
        CGFloat fac = 0.005;
        if(node.position.x < ship.x)
            point.x = point.x * fac;
        else
            point.x = point.x * -1.0 * fac;
        
        if(node.position.y < ship.y)
            point.y = point.y * fac;
        else
            point.y = point.y * -1 * fac;
        
        [node.physicsBody applyForce:point atPoint:node.position];
    }];
}
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *rock, *ship;
    if([contact.bodyA.node.name isEqual:contact.bodyB.node.name])
        return;
    if(contact.bodyA.node.name == nil || contact.bodyB.node.name == nil)
        return;
    
    if([contact.bodyA.node.name  isEqual: @"rock"])
    {
        rock = contact.bodyA;
        ship = contact.bodyB;
    }
    else if([contact.bodyA.node.name  isEqual: @"ship"])
    {
        rock = contact.bodyB;
        ship = contact.bodyA;
    }
    [rock.node removeFromParent];
    [ship.node runAction:[SKAction fadeAlphaBy:-0.05 duration:0.1]];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGPoint ship = [self childNodeWithName:@"ship"].position;
    point.x = point.x - ship.x;
    point.y = point.y - ship.y;
    [[self childNodeWithName:@"ship"].physicsBody applyForce:point atPoint:ship];
}
@end
