//
//  VGCardViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 08/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGCardDetailViewController.h"
#import "VGAddCardViewController.h"


@interface VGCardDetailViewController ()

@end

@implementation VGCardDetailViewController

@synthesize card                    =   mCard;
@synthesize sectionHeadings         =   mSectionHeadings;
@synthesize cardDetails             =   mCardDetails;
@synthesize cardDetailHeadings      =   mCardDetailHeadings;
@synthesize pageState               =   mPageState;
@synthesize cardImage               =   mCardImage;
@synthesize imageView               =   mImageView;
@synthesize ebayView                =   mEbayView;
@synthesize deck                    =   mDeck;
@synthesize setArray                =   mSetArray;




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
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:62/255.0 blue:80/255.0 alpha:1];
    
    self.title = NSLocalizedString(mCard.Name, mCard.Name);
    
    if([mCard.Effect isEqual: @"(null)"])
    {
        mSectionHeadings    =   [[NSArray alloc] initWithObjects:@"Stats",nil];
        
    }
    else
    {
        mSectionHeadings    =   [[NSArray alloc] initWithObjects:@"Stats",@"Effect", nil];
        
    }
    if(mCard.Shield == nil || [mCard.Shield isEqual: @"(null)"])
    {
        mCardDetailHeadings  =   [[NSArray alloc] initWithObjects:@"Grade",@"Power",@"Clan",@"Trigger",@"Set", nil];
        mCardDetails        =   [[NSArray alloc] initWithObjects:mCard.Grade,mCard.Power,mCard.Clan,mCard.Trigger, nil];
    }
    else
    {
        mCardDetailHeadings  =   [[NSArray alloc] initWithObjects:@"Grade",@"Power",@"Shield",@"Clan",@"Trigger",@"Set", nil];
        mCardDetails        =   [[NSArray alloc] initWithObjects:mCard.Grade,mCard.Power,mCard.Shield,mCard.Clan,mCard.Trigger,mCard.Set, nil];
    }
    
    
    //*******************
    //Tab Bar Stuff
    //*******************
    
    //mCardDetailHeadings
    
    if(mDeck == nil)
    {
        NSMutableArray * modifyMe = [[_tabBar items] mutableCopy];
        [modifyMe removeObjectAtIndex:3];
        NSArray *newItems = [[NSArray alloc] initWithArray:modifyMe];
        [_tabBar setItems:newItems animated:false];
    }
    
    mSetArray = [mCard.Set componentsSeparatedByString:@"||"];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:mPageState]];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //   [self.navigationController setNavigationBarHidden:YES animated:animated];
    // [super viewWillDisappear:animated];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//****************************
//TABLE REQUIRED METHODS
//****************************

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    [cell setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:11]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    cell.detailTextLabel.text = @"";
    if(indexPath.row < mCardDetails.count-1)
    {
        switch(indexPath.section)
        {
                
            case 0:
                if(mCardDetails.count > indexPath.row)
                {
                    cell.detailTextLabel.text   =   [mCardDetails objectAtIndex:indexPath.row];
                }
                cell.textLabel.text         =   [mCardDetailHeadings objectAtIndex:indexPath.row];
                
                break;
            case 1:             //CARD DESCRIPTION CELL
                cell.textLabel.lineBreakMode = NSLineBreakByClipping;
                cell.textLabel.numberOfLines = 20;
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
                cell.textLabel.text =   mCard.Effect;
                
                
                
                
                break;
                
        }
        
        
        
        
    }
    else{
        
        int row = indexPath.row;
        int cardDetailCount = mCardDetails.count-1;
        
        NSString * setTitleText = [NSString stringWithFormat:@"Set %d",row - cardDetailCount + 1];
        NSString * setText = [mSetArray objectAtIndex:row-cardDetailCount];
        
        cell.textLabel.text = setTitleText;
        cell.detailTextLabel.text = setText;
        
    }
    
    return cell;
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mSectionHeadings.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            //return mCardDetailHeadings.count;
            return mCardDetails.count -1 + mSetArray.count;
            break;
        case 1:
            return 1;
            break;
    }
    
    return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 int rowHeight = 40;
 
 if(indexPath.section != nil){
 
 
 
 if(indexPath.section == 1)
 {
 NSString *stringForThisCell = mCard.Effect;
 
 CGSize titleSize = [stringForThisCell sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByClipping];
 
 return tableView.rowHeight/2 + titleSize.height;
 }
 }
 
 
 return rowHeight;
 }
 */


//***********************************
//DEALING WITH TAB BAR
//***********************************

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSUInteger indexOfTab = [[tabBar items] indexOfObject:item];
    
    if(indexOfTab   !=  mPageState)
    {
        [self switchPage:indexOfTab];
    }
}

-(void)switchPage:(NSUInteger)pageToChangeTo
{
    
    switch(pageToChangeTo)
    {
        case 0:
        {
            if(mPageState   ==  1)
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.75];
                
                
                
                
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
                
                
                [mImageView removeFromSuperview];
                
                [UIView commitAnimations];
                
                break;
                
            }
            
            if(mPageState   ==  2)
            {
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.75];
                
                
                
                
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
                
                
                [mEbayView removeFromSuperview];
                
                [UIView commitAnimations];
                
                
                
                
                
            }
            
            break;
            
            
        }
        case 1:
        {
            
            
            
            if(mCardImage   ==    nil)
            {
                ////////////////////////////////
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                
                HUD.delegate = self;
                HUD.labelText = @"Downloading image";
                HUD.labelFont = [UIFont fontWithName:@"Helvetica Neue" size:15];
                
                
                HUD.square = YES;
                
                [HUD showWhileExecuting:@selector(loadCardImage) onTarget:self withObject:nil animated:YES];
                
                
            }
            else
            {
                [self displayCardImage];
            }
            
            
            
            break;
            
        }
        case 2:
        {
            
            
            
            
            CGRect screenRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -  self.tabBar.bounds.size.height);
            mEbayView   =   [[UIWebView alloc] initWithFrame:screenRect];
            [mEbayView setDelegate:self];
            
            
            //**********************
            //DEALING WITH LOCALES
            //**********************
            
            NSString * ebaySearchURLRaw;
            
            if([[[NSLocale currentLocale] localeIdentifier] isEqual: @"en_GB"])
            {
                ebaySearchURLRaw =   [NSString stringWithFormat:@"http://search.ebay.co.uk/Vanguard %@",mCard.Name];
            }
            else
            {
                ebaySearchURLRaw =   [NSString stringWithFormat:@"http://search.ebay.com/Vanguard %@",mCard.Name];
            }
            
            
            NSString * ebaySearchURL = [ebaySearchURLRaw stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            NSURL *url = [NSURL URLWithString:ebaySearchURL];
            
            //URL Requst Object
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            
            //Load the request in the UIWebView.
            [mEbayView loadRequest:requestObj];
            
            
            
            [self.view addSubview:mEbayView];
            
            
            
            
            
            
            
            break;
        }
        case 3:
        {
            
            VGAddCardViewController * ACVC = [[VGAddCardViewController alloc]initWithNibName:@"VGAddCardViewController" bundle:nil];
            
            ACVC.deck       =   mDeck;
            ACVC.card       =   mCard;
            ACVC.delegate   =   self;
            
            [self.navigationController presentViewController:ACVC animated:YES completion:nil];
            
            //[mDeck.cards addObject:mCard];
            
            //NSLog(@"ADD CARD TO DECK");
            //[self.delegate passDeckBack:self changedDeck:mDeck];
        }
            break;
    }
    
    
    
    
    
    
    if(pageToChangeTo < 3)
        mPageState  =   pageToChangeTo;
}

-(void)passDeckBack:(VGAddCardViewController *)controller changedDeck:(VGDeck *)deck
{
    mDeck   =   deck;
    
    [self.delegate passDeckBack:self changedDeck:mDeck];
}

-(void)loadCardImage
{
    
    NSURL *url = [[NSURL alloc] initWithString:mCard.ImageLocation];
    
    
    mCardImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    [self displayCardImage];
}

-(void)displayCardImage
{
    mImageView = [[UIImageView alloc] initWithImage:mCardImage];
    
    CGRect screenRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -  self.tabBar.bounds.size.height);
    
    
    mImageView.frame     =   screenRect;
    mImageView.clipsToBounds =   true;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    [self.view addSubview:mImageView];
    //[self.view insertSubview:mImageView atIndex:0];
    [UIView commitAnimations];
    
    
    [mEbayView removeFromSuperview];
    
}



#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    
    
    HUD = nil;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
}


@end

