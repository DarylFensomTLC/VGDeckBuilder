//
//  VGAddCardViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 12/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGAddCardViewController.h"

@interface VGAddCardViewController ()

@end

@implementation VGAddCardViewController

@synthesize deck            =   mDeck;
@synthesize card            =   mCard;
@synthesize copiesInDeck    =   mCopiesInDeck;
@synthesize copiesToAdd     =   mCopiesToAdd;
@synthesize triggersInDeck  =   mTriggersInDeck;
@synthesize healsInDeck     =   mHealsInDeck;

@synthesize addCardSlider   =   mAddCardSlider;
@synthesize pickerView      =   mPickerView;
@synthesize setArray        =   mSetArray;
@synthesize setSelected     =   mSetSelected;
@synthesize ignoresCardCopyLimit = mIgnoresCardCopyLimit;
@synthesize addToExtraDeck  =   mAddToExtraDeck;


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
    
    
    
    mSetSelected = 0;
    
    
    
    [self calculateNumberOfCardCopiesInDeck];
    [self calculateNumberOfTriggersInDeck];
    mSetArray = [mCard.Set componentsSeparatedByString:@"||"];
    
    if(mCopiesInDeck > 4){
        mIgnoresCardCopyLimit = true;
    }
    else{
        mIgnoresCardCopyLimit = false;
    }
    
    mAddToExtraDeck = false;
    
}


-(void)calculateNumberOfCardCopiesInDeck
{
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * searchCard = [mDeck.cards objectAtIndex:i ];
        if (searchCard.Name == mCard.Name)
        {
            mCopiesInDeck++;
        }
    }
}

-(void)calculateNumberOfTriggersInDeck
{
    for(int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * searchCard = [mDeck.cards objectAtIndex:i ];
        if ([searchCard.Trigger rangeOfString:@"Stand" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            mTriggersInDeck++;
        }
        
        if ([searchCard.Trigger rangeOfString:@"Critical" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            mTriggersInDeck++;
        }
        
        if ([searchCard.Trigger rangeOfString:@"Draw" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            mTriggersInDeck++;
        }
        
        if ([searchCard.Trigger rangeOfString:@"Heal" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            mTriggersInDeck++;
            mHealsInDeck++;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(bool)deckWillContain4OrLessCopiesOfCard{
    if(mCopiesInDeck + mCopiesToAdd > 4)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Deck" message:@"Only 4 copies of an individual card allowed per deck" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message show];
        return false;
    }
    else{
        return true;
    }

}

-(bool)deckWillContain4OrLessHealTriggers{
    if (mHealsInDeck + mCopiesToAdd > 4 && [mCard.Trigger rangeOfString:@"Heal" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Deck" message:@"Only 4 heal triggers allowed per deck" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message show];
        return false;
    }
    else{
        return true;
    }

}

-(bool)deckWillContain16OrLessTriggers{
    if (mTriggersInDeck + mCopiesToAdd > 16 && ([mCard.Trigger rangeOfString:@"Heal" options:NSCaseInsensitiveSearch].location != NSNotFound || [mCard.Trigger rangeOfString:@"Draw" options:NSCaseInsensitiveSearch].location != NSNotFound || [mCard.Trigger rangeOfString:@"Stand" options:NSCaseInsensitiveSearch].location != NSNotFound || [mCard.Trigger rangeOfString:@"Critical" options:NSCaseInsensitiveSearch].location != NSNotFound))
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Deck" message:@"A deck may not contain more than 16 triggers" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message show];
        return false;
    }
    else{
        return true;
    }

}

-(bool)deckWillContain50OrLessCards{
    if(mDeck.cards.count + mCopiesToAdd > 50)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Deck" message:@"A deck must contain 50 cards" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message show];
        return false;
    }
    else{
        return true;
    }

}


-(bool)extraDeckWillContain8OrLessCards{
    if(mDeck.extraCards.count + mCopiesToAdd > 8)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Deck" message:@"G Zone must contain 8 or less cards" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message show];
        return false;
    }
    else{
        return true;
    }
    
}

-(void)addCopiesOfCardToDeck{
    for (int i = 0; i < mCopiesToAdd; i++)
    {
        [mDeck.cards addObject:mCard];
        [mDeck.cardsSets addObject:[NSString stringWithFormat:@"%d",mSetSelected]];
    }
    [self.delegate passDeckBack:self changedDeck:mDeck];
}


-(void)addCopiesOfCardToExtraDeck{
    for (int i = 0; i < mCopiesToAdd; i++)
    {
        [mDeck.extraCards addObject:mCard];
        [mDeck.extraCardSets addObject:[NSString stringWithFormat:@"%d",mSetSelected]];
    }
    [self.delegate passDeckBack:self changedDeck:mDeck];
}

//****************************
//TABLE REQUIRED METHODS
//****************************

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        
        if([self deckWillContain4OrLessHealTriggers])
        {
            if([self deckWillContain50OrLessCards])
            {
                if([self deckWillContain16OrLessTriggers])
                {
                    if(mIgnoresCardCopyLimit)
                    {
                        [self addCopiesOfCardToDeck];
                        [self dismissViewControllerAnimated:YES completion:nil];

                    }
                    else
                    {
                        if([self deckWillContain4OrLessCopiesOfCard])
                        {
                            [self addCopiesOfCardToDeck];
                            [self dismissViewControllerAnimated:YES completion:nil];

                        }
                    }
                }
            }
        }
       
    }
    
    if(indexPath.section == 3 && indexPath.row == 0){
        if([self extraDeckWillContain8OrLessCards])
        {
            if(mIgnoresCardCopyLimit)
            {
                [self addCopiesOfCardToExtraDeck];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            else
            {
                if([self deckWillContain4OrLessCopiesOfCard])
                {
                    [self addCopiesOfCardToExtraDeck];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
            }

        }
    }
    
    if(indexPath.section    ==  4 && indexPath.row == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        
        
        UIViewController *rvc = [UIApplication sharedApplication].delegate.window.rootViewController;
        UIViewController *pvc = rvc.presentedViewController;
        
        
        VGSelectSetViewController * selectSetViewController = [[VGSelectSetViewController alloc] initWithNibName:@"VGSelectSetViewController" bundle:nil];
        
        selectSetViewController.cardSets = mSetArray;
        selectSetViewController.delegate = self;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        [pvc presentViewController:selectSetViewController animated:YES completion:nil];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
      cell.selectionStyle =   UITableViewCellEditingStyleNone;
        
    }
    
    cell.detailTextLabel.text            =   nil;
    
    if(indexPath.section == 0)
    {
        
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Current Deck Size:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",mDeck.cards.count];
        }
        
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Number of Triggers in Deck:";
            cell.detailTextLabel.text =  [NSString stringWithFormat:@"%d",mTriggersInDeck];
        }
        
        if(indexPath.row == 2)
        {
            cell.textLabel.text = @"Copies of This Card in Deck:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",mCopiesInDeck];
        }
        
    }
    
    if(indexPath.section == 1)
    {
    
        if(indexPath.row == 0)
        {
            cell.textLabel.text =   @"Add:";
            
            cell.detailTextLabel.text=  [NSString stringWithFormat:@"%d", 1];
            
            
                mAddCardSlider    =   [[UISlider alloc] initWithFrame:CGRectMake(-30, 0, 160, 30)];
                mAddCardSlider.minimumValue       =   1;
                mAddCardSlider.maximumValue       =   4;

                mAddCardSlider.value              =   1;
                mCopiesToAdd                      =   mAddCardSlider.value;
                mAddCardSlider.tag                =   0;
            
            
            [mAddCardSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView  =   mAddCardSlider;
            
        }
        
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Select Card Set ID: ";
            cell.detailTextLabel.text = [mSetArray objectAtIndex:mSetSelected];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; 
            
            cell.selectionStyle =   UITableViewCellSelectionStyleBlue;
            
        }
        
        if(indexPath.row == 2)
        {
            cell.textLabel.text = @"Ignore Card Limit: ";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            switchView.tag     = indexPath.section;
            
            [switchView setOn:mIgnoresCardCopyLimit];
                           
            cell.accessoryView = switchView;

        }

        
        
    }
    
    if(indexPath.section == 2)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text =   @"Add Card(s) to Main Deck";
        cell.textLabel.textAlignment    = NSTextAlignmentCenter;
       
    }
    
    if(indexPath.section == 3)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text =   @"Add Card(s) to G-Zone";
        cell.textLabel.textAlignment    = NSTextAlignmentCenter;
        
    }
    
    if(indexPath.section == 4)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text =   @"Cancel";
        cell.textLabel.textAlignment    = NSTextAlignmentCenter;
        
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
    cell.backgroundColor = [UIColor colorWithWhite: 0 alpha:0.2];
    
    
    return cell;
    
    
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
            mCopiesToAdd  =   slider.value;
            senderCell.detailTextLabel.text=  [NSString stringWithFormat:@"%d", mCopiesToAdd];
        }
            break;
        
    }
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
        {
            return 3;
        }
            break;
        case 1:
        {
            return 3;
        }
            break;
        case 2:
        {
            return 1;
        }
        case 3:
        {
            return 1;
        }
            break;
        case 4:
        {
            return 1;
        }
            break;
    }
    return 0;
}

-(void)switchChanged:(id)sender{
    UISwitch* switchControl =   sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    NSLog(@"The switch pressed was in section %d",switchControl.tag);
    switch(switchControl.tag)
    {
        case 1:
        {
            mIgnoresCardCopyLimit    =   switchControl.on;
        }
            break;
    }
    [self.tableView reloadData];
}


//************************PICKER VIEW METHODS******************************//

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [mSetArray count];
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [mSetArray objectAtIndex:row];
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    NSLog(@"Chosen item: %@", [mSetArray objectAtIndex:row]);
}

//***********************************SELECT SET DELEGATE METHOD****************//
-(void)passBack:(id)set :(int )inSet
{
    mSetSelected = inSet;
    [self.tableView reloadData];
}


@end
