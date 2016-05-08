//
//  VGCardsViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 01/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGAdvancedSearchViewController.h"
#import "VGDeck.h"
#import "VGCardDetailViewController.h"
#import "VGCardCell.h"
#import "VGImageToGrab.h"

@class VGCardsViewController;

@protocol VGCardsViewDelegate<NSObject>


-(void) passDeckBack:(VGCardsViewController*)controller changedDeck:(VGDeck*)deck;
    

@end

@interface VGCardsViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,VGAdvancedSearchDelegate,VGCardDetailDelegate>
{
    NSMutableArray * searchResults;
    NSOperationQueue * mQueue;
}

@property (atomic, strong) NSMutableArray * searchResults;
@property (atomic, retain) NSMutableArray *cards;

@property (atomic, retain) VGDeck *deck;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property Boolean isAdvancedSearchTableShowing;

@property (weak, nonatomic) UITableView *advancedSearchTableView;

- (IBAction)testButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray * visibleCells;


-(void)searchForCardsContaining:(NSString*)searchString;
-(void)AdvancedSearchButtonPressed;

@property (weak, nonatomic) id<VGCardsViewDelegate>delegate;

@end
