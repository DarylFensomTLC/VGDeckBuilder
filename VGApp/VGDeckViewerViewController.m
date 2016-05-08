//
//  VGDeckViewerViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 14/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGDeckViewerViewController.h"
#import "VGDeckCell.h"
#import "VGDeck.h"
#import "VGDeckViewController.h"

@interface VGDeckViewerViewController ()

@end

@implementation VGDeckViewerViewController

@synthesize decks           =   mDecks;
@synthesize deckNameField   =   mDeckNameField;
@synthesize cards           =   mCards;
@synthesize deleteMode      =   mDeleteMode;
@synthesize copyMode        =   mCopyMode;


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
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(52/255.0) green:(152/255.0) blue:219/255.0 alpha:1]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Lato-Regular" size:16.0], NSFontAttributeName,nil]];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [attributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
    [attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
    [attributes setValue:[UIFont fontWithName:@"Lato-Regular" size:16.0f] forKey:UITextAttributeFont];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
        [self.collectionView registerClass:[VGDeckCell class] forCellWithReuseIdentifier:@"VGDeckCell"];
    
    self.title = @"My Decks";
    
    
    if(mDecks == nil)
    {
        mDecks  =   [[NSMutableArray alloc] init];
    }
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddDeckButtonPressed)];
    
    self.navigationItem.rightBarButtonItem=  rightButton;

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self saveDeckToXML];
    [self.collectionView reloadData];
    mDeleteMode         =   false;
    mCopyMode           =   false;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
   // [self.navigationController setNavigationBarHidden:YES animated:animated];
   // [super viewWillDisappear:animated];
    [self.delegate passDecksBack:self decks:mDecks];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)AddDeckButtonPressed
{
        UIAlertView* dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Enter Deck Name"];
        [dialog setMessage:@" "];
        [dialog addButtonWithTitle:@"OK"];
        [dialog addButtonWithTitle:@"Cancel"];
    
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    
        if(mDeleteMode)
            [self deleteButtonPressed:nil];
    
        if(mCopyMode)
            [self btnCopyPressed:nil];
        
        [dialog show];
 
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        VGDeck * newDeck    =   [[VGDeck alloc] init];
        newDeck.name  =   [alertView textFieldAtIndex:0].text;
        
        
        [mDecks addObject:newDeck];
        newDeck.deckID = mDecks.count - 1;
        [self saveDeckToXML];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    }
    
    
}

-(void)saveDeckToXML
{
    
    NSLog(@"Saving Deck to XML");
    
    NSString * xmlString = [[NSString alloc] init] ;
    
    xmlString   =   [xmlString stringByAppendingString:@"<Decks>"];
    
    for(int i = 0; i < mDecks.count; i++)
    {
        VGDeck * deckToAdd = [mDecks objectAtIndex:i];
        NSString * deckString = [deckToAdd toXML];
        
        xmlString   =   [xmlString stringByAppendingString:deckString];
    }
    
    
    
    xmlString   =   [xmlString stringByAppendingString:@"</Decks>"];
    
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];  // Load XML data from web
    
    // construct path within our documents directory
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"decks.xml"];
    
    // write to file atomically (using temp file)
    [data writeToFile:storePath atomically:TRUE];
    
    
}


-(void)passDeckBack:(VGDeckViewController *)controller changedDeck:(VGDeck *)deck
{
    [mDecks replaceObjectAtIndex:deck.deckID withObject:deck];
    [self saveDeckToXML];
    [self.delegate passDecksBack:self decks:mDecks];
}

//*******************************
//COLLECTIONVIEW METHODS
//*******************************

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"VGDeckCell";
    
    VGDeckCell *cell = (VGDeckCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    VGDeck * deck    =  [mDecks objectAtIndex:indexPath.item];
    
    if(!mDeleteMode)
        cell.deleteIcon.alpha   = 0;
    else
        cell.deleteIcon.alpha   =   1;
    
    if(!mCopyMode)
        cell.copyingIcon.alpha   = 0;
    else
        cell.copyingIcon.alpha   =   1;
    
    //NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    
    NSString *cellData = deck.name;
    [cell.deckNameLabel setText:cellData];
    
   
   return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mDecks.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(mDeleteMode)
    {
        [mDecks removeObjectAtIndex:indexPath.item];
         [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self saveDeckToXML];
    }
    else if(mCopyMode)
    {
        VGDeck * deckToCopy = [mDecks objectAtIndex:indexPath.item];
        VGDeck * newDeck = [[VGDeck alloc] init];
        
        newDeck.name    =   [NSString stringWithFormat:@"%@ copy",deckToCopy.name];
        
        
        newDeck.cards = [[NSMutableArray alloc] initWithArray:deckToCopy.cards];
        
        newDeck.cardsSets = [[NSMutableArray alloc] initWithArray:deckToCopy.cardsSets];
        newDeck.deckID = mDecks.count;
        
        [mDecks addObject:newDeck];
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self saveDeckToXML];
    }
    else
    {
        VGDeckViewController * view = [[VGDeckViewController alloc] initWithNibName:@"VGDeckView" bundle:nil];
        
        view.deck   =   [mDecks objectAtIndex:indexPath.item];
        view.cards  =   mCards;
        
        view.delegate = self;
        [self.navigationController pushViewController:view animated:YES];
    }
    
}







- (IBAction)deleteButtonPressed:(id)sender {
    
    
    NSArray * visibleCells = [self.collectionView visibleCells];
    
    if(mDeleteMode)
    {
        [self.deleteButton setTitle:@"Delete Deck"];
        for(int i = 0; i < visibleCells.count; i++)
        {
            VGDeckCell * cell = [visibleCells objectAtIndex:i];
            [cell fadeOutDelete];
        }

        mDeleteMode =   false;
    }
    else
    {
        [self.deleteButton setTitle:@"Done"];
        for(int i = 0; i < visibleCells.count; i++)
        {
            VGDeckCell * cell = [visibleCells objectAtIndex:i];
            [cell fadeInDelete];
        }
        mDeleteMode =   true;
        
        if(mCopyMode)
        {
            [self btnCopyPressed:nil];
        }

    }
}

- (IBAction)btnCopyPressed:(id)sender {
    NSArray * visibleCells = [self.collectionView visibleCells];
    
    if(mCopyMode)
    {
        [self.btnCopy setTitle:@"Copy Deck"];
        for(int i = 0; i < visibleCells.count; i++)
        {
            VGDeckCell * cell = [visibleCells objectAtIndex:i];
            [cell fadeOutCopy];
        }
        
        mCopyMode =   false;
    }
    else
    {
        [self.btnCopy setTitle:@"Done"];
        for(int i = 0; i < visibleCells.count; i++)
        {
            VGDeckCell * cell = [visibleCells objectAtIndex:i];
            [cell fadeInCopy];
        }
        mCopyMode =   true;
        
        if(mDeleteMode)
        {
            [self deleteButtonPressed:nil];
        }
        
    }

}
@end
