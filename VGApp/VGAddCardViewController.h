//
//  VGAddCardViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 12/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGCard.h"
#import "VGDeck.h"
#import "VGSelectSetViewController.h";


@class VGAddCardViewController;

@protocol VGAddCardDelegate <NSObject>
-(void) passDeckBack:(VGAddCardViewController*)controller changedDeck:(VGDeck*)deck;

@end


@interface VGAddCardViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,VGSelectSetDelegate>{
    VGDeck * deck;
    VGCard * card;
}


@property (retain, nonatomic) VGDeck * deck;
@property (retain, nonatomic) VGCard * card;
@property (nonatomic, retain) UISlider * addCardSlider;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSInteger copiesInDeck;
@property NSInteger copiesToAdd;

@property NSInteger healsInDeck;
@property NSInteger triggersInDeck;

@property bool ignoresCardCopyLimit;
@property bool addToExtraDeck;

@property (strong, nonatomic) UIPickerView * pickerView;


@property (weak, nonatomic) id<VGAddCardDelegate>delegate;
@property (strong, nonatomic) NSArray * setArray;
@property int setSelected;

@end
