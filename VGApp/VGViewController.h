//
//  VGViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 01/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "VGDeckViewerViewController.h"


@class SBJsonParser;

@interface VGViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate,MFMailComposeViewControllerDelegate,VGDeckViewerDelegate>
{
    NSMutableArray *cards;
    NSMutableArray *decks;
    MBProgressHUD *HUD;
    SBJsonParser *parser;
}

- (IBAction)btnCardlistPressed:(id)sender;
- (IBAction)btnSaveXMLPressed:(id)sender;
- (IBAction)btnUpdatePressed:(id)sender;
- (IBAction)btnAlfredEarlyPressed:(id)sender;
- (IBAction)btnEditDeckPressed:(id)sender;
- (IBAction)btnDeckBuilderPressed:(id)sender;

-(void)saveCardsToXML;
-(void)updateCardDatabase;
-(void)loadXMLData;
-(void)loadDecksXMLData;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCardList;

@property (nonatomic, retain) SBJsonParser *parser;


@property (nonatomic, retain) NSMutableArray *cards;
@property (nonatomic, retain) NSMutableArray *decks;
@property (nonatomic, retain) NSArray *buttonTitles;
@property Boolean didCardGrabFail;

@end
