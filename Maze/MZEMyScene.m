//
//  MZEMyScene.m
//  Maze
//
//  Created by Sagar Patel on 7/22/13.
//  Copyright (c) 2013 Sagar Patel. All rights reserved.
//

#import "MZEMyScene.h"
#import "MZESpaceShip.h"

@interface MZEMyScene ()
@property BOOL contentCreated;

@end

@implementation MZEMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];

        self.contentCreated = NO;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if(self.contentCreated == NO)
    {
        self.contentCreated = YES;
        [self createSceneContents];
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor grayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild:[self newHelloNode]];
}

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *hello = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    hello.text = @"hello world";
    hello.fontSize = 40;
    hello.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    hello.name = @"hello";
    return hello;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    SKNode *hello = [self childNodeWithName:@"hello"];
    if(hello)
    {
        hello.name = nil;
        SKAction *moveup = [SKAction moveByX:0 y:100 duration:0.5];
        SKAction *fade = [SKAction fadeOutWithDuration:0.5];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveseq = [SKAction sequence:@[moveup, fade, remove]];
        [hello runAction:moveseq completion:^{
            SKScene *spaceShip = [[MZESpaceShip alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:spaceShip transition:doors];
        }];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
