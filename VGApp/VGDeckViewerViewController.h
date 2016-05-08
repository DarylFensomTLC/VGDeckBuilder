//
//  VGDeckViewerViewController.h
//  VGApp
//
//  Created by Daryl Fensom on 14/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGDeckViewController.h"


@class VGDeckViewerViewController;

@protocol VGDeckViewerDelegate<NSObject>

-(void) passDecksBack:(VGDeckViewerViewController*)controller decks:(NSMutableArray*)inDecks;


@end



@interface VGDeckViewerViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate,VGDeckViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)btnCopyPressed:(id)sender;

@property (retain, nonatomic) NSMutableArray * decks;
@property (retain, nonatomic) NSMutableArray * cards;
@property (retain,nonatomic) UITextField * deckNameField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCopy;

@property Boolean deleteMode;
@property Boolean copyMode;

@property (weak, nonatomic) id<VGDeckViewerDelegate>delegate;

@end
