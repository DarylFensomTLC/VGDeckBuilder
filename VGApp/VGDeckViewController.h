//
//  VGDeckViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 11/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "VGDeck.h"
#import "VGCardsViewController.h"
#import "VGCardCell.h"
#import "VGImageToGrab.h" 
#import "VGVanguardSelectorActionSheetDelegate.h"

@class VGDeckViewController;

@protocol VGDeckViewDelegate<NSObject>

-(void) passDeckBack:(VGDeckViewController*)controller changedDeck:(VGDeck*)deck;


@end

@interface VGDeckViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,VGCardsViewDelegate,VGCardDetailDelegate,UIAlertViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    NSMutableArray *cards;
    VGDeck          * deck;
    NSOperationQueue * mQueue;
}


@property (atomic, retain) NSMutableArray *cards;
@property (atomic, retain) VGDeck * deck;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (atomic, retain) NSMutableArray *normalUnits;

@property (atomic, retain ) NSMutableArray * triggerUnits;

@property (atomic, retain) NSMutableArray * gradeZeroUnits;

@property (atomic, retain) NSMutableArray * gradeOneUnits;

@property (atomic, retain) NSMutableArray * gradeTwoUnits;

@property (atomic, retain) NSMutableArray * gradeThreeUnits;

@property (atomic, retain) NSMutableArray * gradeFourUnits;

@property (atomic, retain) NSMutableArray * gUnits;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (strong, nonatomic) VGVanguardSelectorActionSheetDelegate * vanguardActionSheetDelegate;


@property (strong, nonatomic) NSMutableArray * visibleCells;


@property (nonatomic,retain) UITextField * deckNameField;

- (void)editDeckName;

- (IBAction)enterEditMode:(id)sender;
- (IBAction)btnDrawHandPressed:(id)sender;

@property int numberOfNormalUnits;
@property int numberOfTriggerUnits;

@property int numberOfGradeZeroUnits;
@property int numberOfGradeOneUnits;
@property int numberOfGradeTwoUnits;
@property int numberOfGradeThreeUnits;
@property int numberOfGradeFourUnits;
@property int numberOfGUnits;


@property (weak, nonatomic) id<VGDeckViewDelegate>delegate;
- (IBAction)btnActionPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAction;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDraw;

@property (strong, atomic) NSThread * imageGrabThread;


@end

