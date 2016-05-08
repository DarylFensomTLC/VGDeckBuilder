//
//  VGCardTabViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 08/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGCardTabViewController.h"
#import "VGCardDetailViewController.h"

@interface VGCardTabViewController ()

@end

@implementation VGCardTabViewController

@synthesize card = mCard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController   =   [[UITabBarController alloc] init];
    
    self.tabBarController.view.frame = CGRectMake(0,0,320,460);
    
    
	
    
    //Set Up The Children including passing the card.
    
    VGCardDetailViewController *cardDetailViewController = [[VGCardDetailViewController alloc] initWithNibName:@"VGCardDetailViewController" bundle:nil];
    
    cardDetailViewController.card       =   mCard;
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController viewWillAppear:animated];
}

@end
