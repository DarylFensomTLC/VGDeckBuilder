//
//  VGCardsViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 01/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGCardsViewController.h"
#import "VGCard.h"
#import "VGCardDetailViewController.h"
#import "VGBlankViewController.h"
#import "VGDownloadImageOperation.h"

@interface VGCardsViewController ()

@end

@implementation VGCardsViewController

@synthesize searchResults   =   mSearchResults;
@synthesize cards           =   mCards;
@synthesize deck            =   mDeck;
@synthesize isAdvancedSearchTableShowing = mIsAdvancedSearchTableShowing;
@synthesize visibleCells    =   mVisibleCells;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mQueue = [[NSOperationQueue alloc]init];
        [mQueue setMaxConcurrentOperationCount:6];
    }
    
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    if(mSearchResults   ==  nil)
        mSearchResults  =   mCards;
    mVisibleCells = [[NSMutableArray alloc] init];
    
    self.title = NSLocalizedString(@"Card Search", @"Card Search");
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_linen.png"]];
    
    /*
     UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
     style:UIBarButtonItemStyleDone target:nil action:nil];
     */
    
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(AdvancedSearchButtonPressed)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Advanced" style:UIBarButtonItemStyleBordered target:self action:@selector(AdvancedSearchButtonPressed)];
    
    self.navigationItem.rightBarButtonItem=  rightButton;
    
    mIsAdvancedSearchTableShowing    =   false;
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    //[super viewWillDisappear:animated];
    
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Table Stuff
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellCard";
    
    
    
    VGCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VGCardCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }

    VGCard *tempCard;
    NSString *tempCardName;
    
    //**********************
    //WORK OUT THE CARD NAME
    //**********************
    
    tempCard = [mSearchResults objectAtIndex:indexPath.row];
    
    [cell.lblName setText:tempCard.Name];
    [cell setGrade:tempCard.Grade];
    [cell setClan:tempCard.Clan];
    [cell setTrigger:tempCard.Trigger];
    [cell setStats:tempCard.Power defense:tempCard.Shield];
    
    if(tempCard.Effect.length > 125)
        [cell setEffect:[tempCard.Effect substringToIndex:125]];
    else
        [cell setEffect:tempCard.Effect];
    
    [cell.imageView setImage:[UIImage imageNamed:@"placeholderCard.png"]];
    
    
    VGImageToGrab * imageToGrabObject = [[VGImageToGrab alloc] initWithCard:tempCard cardCell:cell tableView:tableView];
    //VGDownloadImageOperation *dio = [[VGDownloadImageOperation alloc] initWithImageTograbObject:imageToGrabObject];
    
    NSArray * visibleCells = tableView.visibleCells;
    
    [mVisibleCells addObject:cell];
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString* foofile = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[tempCard.Name stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    
    if(fileExists)
    {
        UIImage *mCardImage = [UIImage imageWithContentsOfFile:foofile];
        
        [cell.imageView setImage:mCardImage];
        [cell resetCell];
        
    }
    else
    {
        [self performSelectorInBackground:@selector(grabCardImage:) withObject:imageToGrabObject];
    }
    
    //[mQueue addOperation:dio];
    NSLog(@"Loading Cell");
    
    //*****************************CHANGING CELL COLOUR********************
    [tempCard determineTriggerType];
    
    switch (tempCard.triggerType)
    {
        case 1:
            cell.lblTrigger.textColor = [UIColor greenColor];
            break;
        case 2:
            cell.lblTrigger.textColor = [UIColor orangeColor];
            break;
        case 3:
            cell.lblTrigger.textColor = [UIColor yellowColor];
            break;
        case 4:
            cell.lblTrigger.textColor = [UIColor cyanColor];
            break;
            
            
    }
    
    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    VGCardCell * cardCell = (VGCardCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [mVisibleCells removeObject:cardCell];
}

-(void) grabCardImage:(VGImageToGrab*)inImageToGrab
{
    //first check for cached image
    
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    
    
    if([mVisibleCells containsObject:inImageToGrab.cardCell])
    {
        
        NSString * imageGrabURL = [inImageToGrab.card getImageURL:90];
        if([mVisibleCells containsObject:inImageToGrab.cardCell])
        {
            
            [inImageToGrab.cardCell.imageView setImage:nil];
            UIImage * mCardImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageGrabURL]]];
            
            UIImage * resizedImage = [self imageScaledToSize:mCardImage :CGSizeMake(81, 119)];
            
            if([mVisibleCells containsObject:inImageToGrab.cardCell])
            {
                
                if(inImageToGrab.cardCell.imageView !=nil)
                {
                    
                    [inImageToGrab.cardCell.imageView setImage:resizedImage];
                    [inImageToGrab.cardCell.imageView setBounds:CGRectMake(8, 14, 81, 119)];
                    
                }
                
                
                CGSize resizedImageSize = resizedImage.size;
                
                NSData *imgData = UIImagePNGRepresentation(resizedImage);
                // Identify the home directory and file name
                NSString  *jpgPath = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[inImageToGrab.card.Name stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
                
                
                [imgData writeToFile:jpgPath atomically:NO];
                
                
            }
            
            
            NSArray *viewsToRemove = [inImageToGrab.cardCell.imageView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
        }}
    
    
}


- (UIImage *)imageScaledToSize:(UIImage*)originalImage:(CGSize)size
{
    
    CGSize orginalSize = originalImage.size;
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    
    return image;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Boolean glassEnabled = NO;
    
    if(glassEnabled)
    {
        
        if (indexPath.row % 2 == 0 )
        {
            
            [cell setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
        }
        else
        {
            
            [cell setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
        }
    }
    else
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mSearchResults.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //What happens when cell is selected?
    VGCardDetailViewController * CDVC = [[VGCardDetailViewController alloc]initWithNibName:@"VGCardDetailViewController" bundle:nil];
    
    CDVC.card       =   [mSearchResults objectAtIndex:indexPath.row];
    CDVC.delegate   =   self;
    CDVC.deck       =   mDeck;
    
    
    [self.searchBar resignFirstResponder];
    [self.navigationController pushViewController:CDVC animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    // Get the text so we can measure it
    static NSString *CellIdentifier = @"Cell";
    
    VGCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return 140 + cell.lblEffect.frame.size.height;

}


-(void)AdvancedSearchButtonPressed
{
    //VGAdvancedSearchViewController * ASVC = [[VGAdvancedSearchViewController alloc] initWithNibName:@"VGAdvancedSearchView" bundle:nil];
    
    VGAdvancedSearchViewController * ASVC = [[VGAdvancedSearchViewController alloc]init];
    
    ASVC.cards          =   mCards;
    ASVC.searchResults  =   mSearchResults;
    ASVC.delegate       =   self;
    
    [self.searchBar resignFirstResponder];
    
    [self.navigationController presentViewController:ASVC animated:YES completion:nil];
    
    
}

-(void)passSearchBack:(VGAdvancedSearchViewController *)controller finishedResults:(NSMutableArray *)results
{
    mSearchResults  =   results;
}

-(void)passDeckBack:(VGCardDetailViewController *)controller changedDeck:(VGDeck *)deck
{
    mDeck       =   deck;
    [self.delegate passDeckBack:self changedDeck:mDeck];
}


//*********************************
//DEALING WITH SEARCH BAR
//*********************************


- (IBAction)testButtonPressed:(id)sender {
    VGBlankViewController * ASVC = [[VGBlankViewController alloc] initWithNibName:@"BlankView" bundle:nil];
    
    //ASVC.cards      =   mCards;
    
    [self.navigationController pushViewController:ASVC animated:YES];
}

-(void)searchForCardsContaining:(NSString*)searchString
{
    mSearchResults  =   nil;
    mSearchResults  =   [[NSMutableArray alloc] init];
    if([searchString isEqual: @""])
    {
        mSearchResults  =   mCards;
    }
    else
    {
        for (int i = 0; i < mCards.count; i++)
        {
            VGCard * searchCard = [mCards objectAtIndex:i ];
            if ([searchCard.Name rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [mSearchResults addObject:[mCards objectAtIndex:i ]];
            }
        }
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchForCardsContaining:searchText];
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}



@end
