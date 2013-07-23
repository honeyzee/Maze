//
//  MZEViewController.m
//  Maze
//
//  Created by Sagar Patel on 7/22/13.
//  Copyright (c) 2013 Sagar Patel. All rights reserved.
//

#import "MZEViewController.h"
#import "MZEMyScene.h"

@implementation MZEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
//    // Create and configure the scene.
//    SKScene * scene = [MZEMyScene sceneWithSize:skView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    // Present the scene.
//    [skView presentScene:scene];
}

- (void)viewWillAppear:(BOOL)animated
{
    MZEMyScene *maze = [[MZEMyScene alloc] initWithSize:CGSizeMake(320, 480)];
    SKView *sprite = (SKView *)self.view;
    [sprite presentScene:maze];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
