//
//  VGAdvancedSearchViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 09/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGAdvancedSearchViewController.h"
#import "VGCard.h"


@interface VGAdvancedSearchViewController ()

@end

@implementation VGAdvancedSearchViewController


@synthesize searchResults       =   mSearchResults;
@synthesize cards               =   mCards;
@synthesize sectionTitles       =   mSectionTitles;
@synthesize searchByBattleStats =   mSearchByBattleStats;
@synthesize searchByClan        =   mSearchByClan;
@synthesize searchByGrade       =   mSearchByGrade;

//DataFields
@synthesize gradeSlider         =   mGradeSlider;
@synthesize cardNameTextView    =   mCardNameTextView;
@synthesize powerSlider         =   mPowerSlider;
@synthesize shieldSlider        =   mShieldSlider;
@synthesize clanTextView        =   mClanTextView;


//Search Criteria
@synthesize grade           =   mGrade;
@synthesize power           =   mPower;
@synthesize shield          =   mShield;
@synthesize clan            =   mClan;

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
    
    
    mSectionTitles  =   [[NSArray alloc]initWithObjects:@"Name Contains:",@"Search by Clan:",@"Search by Grade:",@"Search by Battle Stats:",@"Begin Advanced Search", nil];
    
    mGrade          =   0;
    mPower          =   0;
    mShield         =   0;
    mClan           =   @"";
    
    
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
    
    
    [self setTitle:@"Advanced Search"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animationCompleted
{
    
}

//***************************************
//TABLE STUFF
//***************************************

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    
    UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    
    switch(section)
    {
        case 0:
            
            break;
        case 1:
            break;
    }
    
    
    
    titleLabel.textColor = [UIColor whiteColor];
    
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [customTitleView addSubview:titleLabel];
    
    return customTitleView;
    
}
 

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
                
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        
        
        
    }
    
    if(indexPath.section == 4)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    //Set values to blank
    
    cell.selectionStyle =   UITableViewCellEditingStyleNone;
    if(indexPath.row != 0 || indexPath.section  ==  4)
    {
        cell.accessoryView  =   nil;
    }
    
    cell.detailTextLabel.text   =   @"";
    
    
    
    
    if(indexPath.row == 0 && indexPath.section != 0 && indexPath.section != 4)
    {
        //**********************
        //ADDING SWITCH TO CELL
        //**********************
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        switchView.tag     = indexPath.section;
        
        switch (indexPath.section)
        {
            case 3:
            {
                [switchView setOn:mSearchByBattleStats];
            }
                break;
            case 2:
            {
                 [switchView setOn:mSearchByGrade];
            }
                break;
            case 1:
            {
                 [switchView setOn:mSearchByClan];
            }
                break;
        }
        
        cell.accessoryView = switchView;
        
    }
    
    //VGCard *cellCard =  [mSearchResults objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = cellCard.Name;
    
   
    //Cells n shiz
    if(indexPath.row    ==  0)
    {
        cell.textLabel.text =   [mSectionTitles objectAtIndex:indexPath.section];
    }
    
    CGRect textViewRect = CGRectMake(0, 0, 140, 20);
    UIFont * textViewFont = [UIFont fontWithName:@"Lato-Regular" size:15];
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            if(indexPath.row    ==  0)
            {
                if(mCardNameTextView == nil)
                {
                    mCardNameTextView                   =   [[UITextField alloc] initWithFrame:textViewRect];
                    //mCardNameTextView.backgroundColor   = [UIColor whiteColor];
                    mCardNameTextView.font              =   textViewFont;
                    mCardNameTextView.delegate          = self;
                    mCardNameTextView.textAlignment     = NSTextAlignmentRight;
                    [mCardNameTextView setTextColor:[UIColor whiteColor]];
                    cell.accessoryView                  =   mCardNameTextView;
                }
                
            }
        }
        case 3:
        {
            if(mSearchByBattleStats && indexPath.row    ==  1)
            {
                cell.textLabel.text =   @"Power:";
                cell.detailTextLabel.text=  [NSString stringWithFormat:@"%d", mPower * 1000];
                
                mPowerSlider    =   [[UISlider alloc] initWithFrame:CGRectMake(-30, 0, 160, 30)];
                mPowerSlider.minimumValue       =   0;
                mPowerSlider.maximumValue       =   15;
                mPowerSlider.continuous         =   YES;
                
                mPowerSlider.tag                =   1;
                
                [mPowerSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
                
                cell.accessoryView  =   mPowerSlider;
                

                
            }
            if(mSearchByBattleStats && indexPath.row    ==  2)
            {
                cell.textLabel.text =   @"Shield:";
                
                mShieldSlider    =   [[UISlider alloc] initWithFrame:CGRectMake(-30, 0, 160, 30)];
                mShieldSlider.minimumValue       =   0;
                mShieldSlider.maximumValue       =   2;
                [mShieldSlider sendActionsForControlEvents:UIControlEventValueChanged];
                mShieldSlider.tag                =   2;
                
                [mShieldSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView  =   mShieldSlider;
                cell.detailTextLabel.text=  [NSString stringWithFormat:@"%d", mShield * 5000];

            }
            
        }
            break;
        case 2:
        {
            if(mSearchByGrade && indexPath.row    ==  1)
            {
                cell.textLabel.text =   @"Grade:";
                mGradeSlider    =   [[UISlider alloc] initWithFrame:CGRectMake(-30, 0, 100, 30)];
                mGradeSlider.minimumValue       =   0;
                mGradeSlider.maximumValue       =   4;
                
                mGradeSlider.tag                =   0;
               
                [mGradeSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView  =   mGradeSlider;
                cell.detailTextLabel.text=  [NSString stringWithFormat:@"%d", mGrade];
            }
        }
            break;
        case 1:
        {
            if(mSearchByClan && indexPath.row   ==  1)
            {
                 cell.textLabel.text =   @"Clan:";
                if(mClanTextView == nil)
                {
                    textViewRect = CGRectMake(0, 0, 225, 20);
                    mClanTextView                   =   [[UITextField alloc] initWithFrame:textViewRect];
                    //mClanTextView.backgroundColor   = [UIColor whiteColor];
                    mClanTextView.font              =   textViewFont;
                    mClanTextView.delegate          = self;
                    mClanTextView.textAlignment     = NSTextAlignmentRight;
                    mClanTextView.tag               =   1;
                    [mClanTextView setTextColor:[UIColor whiteColor]];
                    
                }
                cell.accessoryView                  =   mClanTextView;

            }
        }
            break;
        case 4:
        {
            if(indexPath.row    ==  0)
            {
                
                cell.selectionStyle =   UITableViewCellSelectionStyleBlue;
                
                cell.textLabel.textAlignment    =   NSTextAlignmentCenter;
            }
        }
    }
    [cell setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
   
    
    return cell;

}
 


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 1;
            break;
        }
        case 3:
        {
            //Filter by battle stats
            if(mSearchByBattleStats)
            {
                return 3;
            }
            else
            return 1;
            break;
        }
        case 2:
        {
            //Filter by Grade
            if(mSearchByGrade)
            return 2;
            else
                return 1;
            break;
        }
        case 1:
        {
            //Filter by Clan
            if(mSearchByClan)
                return 2;
            else
                return 1;
            return 1;
            break;
        }
        case 4:
        {
            return 1;
        }
            
            
    }
    
    return 0;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 4)
    {
        [self advancedSearch: self];
    }
    
}

-(void)switchChanged:(id)sender{
    UISwitch* switchControl =   sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    NSLog(@"The switch pressed was in section %d",switchControl.tag);
    switch(switchControl.tag)
    {
        case 3:
        {
            mSearchByBattleStats    =   switchControl.on;
            
        }
            break;
        case 2:
        {
            mSearchByGrade    =   switchControl.on;
        }
            break;
        case 1:
        {
            mSearchByClan    =   switchControl.on;
        }
            break;
    }
    [self.tableView reloadData];
}

-(void)sliderChanged:(id)sender{
    UISlider* slider   =   sender;
    UIView *view = sender;
    
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    
    UITableViewCell * senderCell = (UITableViewCell *)view;
    switch(slider.tag)
    {
        case 0:
        {
           
            mGrade  = slider.value; //Grade
            senderCell.detailTextLabel.text=  [NSString stringWithFormat:@"%d", mGrade];
        }
            break;
        case 1:
        {
            mPower  =   slider.value; //Power
            senderCell.detailTextLabel.text=  [NSString stringWithFormat:@"%d", mPower * 1000];
        }
            break;
        case 2:
        {
            mShield  =   slider.value; //Shield
            senderCell.detailTextLabel.text=  [NSString stringWithFormat:@"%d", mShield * 5000];
        }
            break;
    }
    
    
   
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag    ==  1)
    {
        mClan   =   textField.text;
    }
    [textField resignFirstResponder];
    return NO;
}

-(void)advancedSearch:(id)sender
{
    NSMutableArray * finalSearchResults = [[NSMutableArray alloc]init];
        
    
    
    //Beginning with name
    
    if(mCardNameTextView.text == nil || [mCardNameTextView.text isEqual: @""])
    {
        for (int i = 0; i < mCards.count; i++)
        {
            [finalSearchResults addObject:[mCards objectAtIndex:i]];
        }
    }
    else
    {
        for (int i = 0; i < mCards.count; i++)
        {
            VGCard * searchCard = [mCards objectAtIndex:i ];
            if ([searchCard.Name rangeOfString:mCardNameTextView.text options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [finalSearchResults addObject:[mCards objectAtIndex:i ]];
            }
        }
    }
    
    
    
    //if(mCard.Shield == nil || [mCard.Shield isEqual: @"(null)"])
    
    if(mSearchByBattleStats)
    {
        if(mPower > 0)
        {
            for (int i = 0; i < finalSearchResults.count; i++)
            {
                VGCard * searchCard = [finalSearchResults objectAtIndex:i ];
                
                NSInteger cardPower = [searchCard.Power intValue];
                
                
                if (cardPower != mPower * 1000) {
                    [finalSearchResults removeObject:[finalSearchResults objectAtIndex:i]];
                    i--;
                }
            }
        }
        
        if(mShield > 0)
        {
            for (int i = 0; i < finalSearchResults.count; i++)
            {
                VGCard * searchCard = [finalSearchResults objectAtIndex:i ];
                
                NSInteger cardShield = [searchCard.Shield intValue];
                
                
                if (cardShield != mShield * 5000 || searchCard.Shield == nil || [searchCard.Shield isEqual: @"(null)"]) {
                    [finalSearchResults removeObject:[finalSearchResults objectAtIndex:i]];
                    i--;
                }
            }

        }
    }
    
    if(mSearchByGrade)
    {
        for (int i = 0; i < finalSearchResults.count; i++)
        {
            VGCard * searchCard = [finalSearchResults objectAtIndex:i ];
            
            NSInteger cardGrade = [searchCard.Grade intValue];
            
            
            if (cardGrade != mGrade) {
                [finalSearchResults removeObject:[finalSearchResults objectAtIndex:i]];
                i--;
            }
        }
    }
    
    if(mSearchByClan)
    {
        for (int i = 0; i < finalSearchResults.count; i++)
        {
            VGCard * searchCard = [finalSearchResults objectAtIndex:i ];
            if ([searchCard.Clan rangeOfString:mClan options:NSCaseInsensitiveSearch].location == NSNotFound) {
                [finalSearchResults removeObjectAtIndex:i];
                i--;
            }
        }
    }
    
    
 
    
    mSearchResults  =   finalSearchResults;
       
    
   
    [self.delegate passSearchBack:self finishedResults:finalSearchResults];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}






@end
