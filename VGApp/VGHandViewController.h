//
//  VGHandViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 17/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGDeck.h"
#import "VGCard.h"

@interface VGHandViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>



@property (nonatomic, retain) VGDeck * deck;
@property (nonatomic, retain) NSArray * sectionTitles;
@property (nonatomic, retain) NSMutableArray * hand;
@property (nonatomic, retain) NSMutableArray * localDeck;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray * potentialVanguardArray;

@property (nonatomic, retain) VGCard * vanguard;

@property int selectedVanguard;

@end
