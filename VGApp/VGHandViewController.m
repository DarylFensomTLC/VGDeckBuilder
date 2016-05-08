//
//  VGHandViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 17/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGHandViewController.h"


@interface VGHandViewController ()

@end

@implementation VGHandViewController

@synthesize deck            = mDeck;
@synthesize sectionTitles   = mSectionTitles;
@synthesize hand            =   mHand;
@synthesize localDeck       =   mLocalDeck;
@synthesize potentialVanguardArray = mPotentialVanguardArray;
@synthesize vanguard        =   mVanguard;
@synthesize selectedVanguard    =   mSelectedVanguard;


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
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_linen.png"]];
    
    mSectionTitles = [[NSArray alloc] initWithObjects:@"Hand - Tap a card to return it to the deck", nil];
    mPotentialVanguardArray = [[NSMutableArray alloc] init];
    mLocalDeck = [[NSMutableArray alloc] init];
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        [mLocalDeck addObject:[mDeck.cards objectAtIndex:i]];
    }
    [self generateVanguardArray];
    
    [self drawHand];
}

-(void)drawHand
{
    mHand   =   [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++)
    {
        int randomNumber = [self randomInRangeLo:0 toHi:mLocalDeck.count];
        
        [mHand addObject:[mLocalDeck objectAtIndex:randomNumber]];
        [mLocalDeck removeObjectAtIndex:randomNumber];

         
    }
}

-(void)drawCard
{
    int randomNumber = [self randomInRangeLo:0 toHi:mLocalDeck.count-1];
    
        [mHand addObject:[mLocalDeck objectAtIndex:randomNumber]];
        [mLocalDeck removeObjectAtIndex:randomNumber];
        
}

-(void)generateVanguardArray
{
    mSelectedVanguard = 0;
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * tempCard = [mDeck.cards objectAtIndex:i];
        if (tempCard.getGrade == 0 && tempCard.triggerType ==   0)
        {
            [mPotentialVanguardArray addObject:tempCard];
        }
    }
    
    if(mPotentialVanguardArray.count > 0)
    {
        mVanguard = [mPotentialVanguardArray objectAtIndex:0];
        [mLocalDeck removeObject:mVanguard];
    }
}

-(void)changeSelectedVanguard
{
    if(mSelectedVanguard + 1 < mPotentialVanguardArray.count)
    {
        mSelectedVanguard++;
    }
    else
    {
        mSelectedVanguard = 0;
    }
    
    
    [mLocalDeck addObject:mVanguard];
    mVanguard = [mPotentialVanguardArray objectAtIndex:mSelectedVanguard];
    if ([mHand containsObject:mVanguard])
    {
        [self sendCardBack:[mHand indexOfObject:mVanguard]];
    }
    [mLocalDeck removeObject:mVanguard];
    
    [self.tableView reloadData];

    
}

-(void)sendCardBack:(NSInteger)cardToSendBack
{
    [mLocalDeck addObject:[mHand objectAtIndex:cardToSendBack]];
    [mHand removeObjectAtIndex:cardToSendBack];
    //[self shuffleDeck];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)getNumberOfCopiesInDeck:(NSString *)tableEntry
{
    int numberOfCopiesInDeck = 0;
    
    for (int i = 0; i < mLocalDeck.count; i++)
    {
        VGCard * searchCard = [mLocalDeck objectAtIndex:i];
        if ([searchCard.Name isEqualToString:tableEntry]) {
            numberOfCopiesInDeck++;
        }
    }
    
    return numberOfCopiesInDeck;
    
}

- (u_int32_t)randomInRangeLo:(u_int32_t)loBound toHi:(u_int32_t)hiBound
{
    u_int32_t random;
    int32_t   range = hiBound - loBound + 1;
    
    u_int32_t limit = UINT32_MAX - (UINT32_MAX % range);
    
    do {
        random = arc4random();
    } while (random > limit);
    
    return loBound + (random % range);
}



//Table Stuff
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
       
    }
    
    
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        
    
    
    switch(indexPath.section)
    {
        case 0:
        {
            
            if(indexPath.row ==0)
            {
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Optima-BoldItalic" size:15]];
                cell.textLabel.text = @"Starting Vanguard: ";
                cell.detailTextLabel.text = mVanguard.Name;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if(indexPath.row ==1)
            {
                cell.textLabel.text = @"Change Vanguard";
            }
        }
            break;
        case 1:
        {
            VGCard * rowCard    =   [mHand objectAtIndex:indexPath.row];
            cell.textLabel.text         =   rowCard.Name;
            
            UIFont * cardNameFont = [UIFont fontWithName:@"Optima-BoldItalic" size:14.0];
            
            cell.textLabel.font         =   cardNameFont;
            
            UIFont * triggerNameFont   =   [UIFont fontWithName:@"Optima-Bold" size:14];
            cell.detailTextLabel.font   =   triggerNameFont;
            cell.detailTextLabel.text   =   @"";

        }
            break;
        case 2:
        {
            
            
            cell.textLabel.text =   @"Draw Card";
        }
            break;
        case 3:
        {
            
            cell.textLabel.text =   @"Return to Deck";
        }
            break;
    }
    
    
    
    
            
    return cell;
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return 2;
            break;
        case 1:
            return mHand.count;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
            
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.section)
    {
        case 0:
        {
            if(indexPath.row == 1)
            {
                [self changeSelectedVanguard];
            }
        }
            break;
        case 1:
            if(mHand.count > 0)
            {
                [self sendCardBack:indexPath.row];
                [self.tableView reloadData];
            }
            break;
        case 2:
            if(mLocalDeck.count > 0)
            {
                [self drawCard];
                [self.tableView reloadData];
            }
            else
            {
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Deck has run out of cards" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];

            }
            break;

        case 3:
            [self dismissViewControllerAnimated:self completion:nil];
            break;

    }
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        
        UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
        
        UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
        
        switch(section)
        {
            case 1:
                titleLabel.text = [mSectionTitles objectAtIndex:0];
                break;
            case 2:
                
                break;
        }
        
        
    UIFont * headerFont =   [UIFont systemFontOfSize:15];
    
    titleLabel.textColor = [UIColor whiteColor];
        
    titleLabel.font =   headerFont;
        titleLabel.backgroundColor = [UIColor clearColor];
        
        [customTitleView addSubview:titleLabel];
        
        return customTitleView;
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 1:
        {
            return 30;
        }
            break;
        
    }
    
    return 0;
}




@end
