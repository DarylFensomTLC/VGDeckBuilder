//
//  VGAppDelegate.h
//  VGApp
//
//  Created by Daryl Fensom on 01/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VGViewController;
@class Cards;

@interface VGAppDelegate : UIResponder <UIApplicationDelegate>
{
    Cards *mCards;
}

@property (nonatomic, retain) Cards *Cards;

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) VGViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;


@end
