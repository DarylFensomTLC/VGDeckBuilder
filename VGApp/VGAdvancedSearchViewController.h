//
//  VGAdvancedSearchViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 09/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGAdvancedSearchViewController;



@protocol VGAdvancedSearchDelegate <NSObject>
-(void) passSearchBack:(VGAdvancedSearchViewController*)controller finishedResults:(NSMutableArray*)results;


@end

@interface VGAdvancedSearchViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>





@property (nonatomic, retain) NSMutableArray * searchResults;
@property (nonatomic, retain) NSMutableArray * cards;
@property (retain, nonatomic) NSArray * sectionTitles;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) Boolean searchByBattleStats;
@property (nonatomic) Boolean searchByGrade;
@property (nonatomic) Boolean searchByClan;


//DataFields
@property (nonatomic, retain) UISlider * gradeSlider;
@property (nonatomic, retain) UITextField * cardNameTextView;
@property (nonatomic, retain) UISlider * powerSlider;
@property (nonatomic, retain) UISlider * shieldSlider;
@property (nonatomic, retain) UITextField * clanTextView;



//Search Criteria
@property NSInteger grade;
@property NSInteger power;
@property NSInteger shield;
@property NSString * clan;

-(void)advancedSearch;

@property (weak, nonatomic) id<VGAdvancedSearchDelegate>delegate;


@end


