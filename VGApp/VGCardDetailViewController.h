//
//  VGCardViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 08/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGCard.h"
#import "VGDeck.h"
#import "VGAddCardViewController.h"
#import "MBProgressHUD.h"

@class VGCardDetailViewController;

@protocol VGCardDetailDelegate <NSObject>
-(void) passDeckBack:(VGCardDetailViewController*)controller changedDeck:(VGDeck*)deck;

@end


@interface VGCardDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource,UITabBarDelegate,UIWebViewDelegate,VGAddCardDelegate,MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) VGCard * card;
@property (retain, nonatomic) VGDeck * deck;

@property (strong, nonatomic) NSArray * setArray;

@property NSArray * sectionHeadings;
@property NSArray * cardDetails;
@property NSArray * cardDetailHeadings;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) UIImage * cardImage;

@property int pageState;
@property UIImageView * imageView;
@property UIWebView *   ebayView;

-(void)switchPage:(NSUInteger)pageToChangeTo;
-(void)loadCardImage;


@property (weak, nonatomic) id<VGCardDetailDelegate>delegate;

@end
