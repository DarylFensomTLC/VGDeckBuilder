//
//  VGCardTabViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 08/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGCard.h"
@interface VGCardTabViewController : UIViewController
<UITabBarControllerDelegate>


@property (strong, nonatomic) VGCard * card;



@property (weak, nonatomic) IBOutlet UIViewController *tabBarController;

@end
