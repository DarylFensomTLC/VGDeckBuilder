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
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_linen.png"]];
    
    mSetSelected = 0;
    
    //**********************
    //Calculate number of cards
    //**********************
    
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * searchCard = [mDeck.cards objectAtIndex:i ];
        if (searchCard.Name == mCard.Name)
        {
            mCopiesInDeck++;
        }
    }

    
    [self calculateNumberOfTriggersInDeck];
    
    mSetArray = [mCard.Set componentsSeparatedByString:@"||"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calculateNumberOfTriggersInDeck{
    
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

-(BOOL)checkForTooManyCardCopies{
    if(mCopiesInDeck + mCopiesToAdd > 4)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Deck" message:@"Only 4 copies of an individual card allowed per deck" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message show];
        return false;
    }
    else
    {
        return true;
    }
}

-(BOOL)checkForTooManyHealTriggers{
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

-(BOOL)checkForTooManyTriggers{
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

-(BOOL)checkForTooManyCardsInDeck{
    if(mDeck.cards
       .count + mCopiesToAdd > 50)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Deck" message:@"A deck must contain 50 cards" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message show];
        return false;
    }
    else{
            return true;
    }


}

-(void)addCardToDeck{
    for (int i = 0; i < mCopiesToAdd; i++)
    {
        [mDeck.cards addObject:mCard];
        [mDeck.cardsSets addObject:[NSString stringWithFormat:@"%d",mSetSelected]];
    }
    

}

-(void)showSelectSetView{
    UIViewController *rvc = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *pvc = rvc.presentedViewController;
    
    
    VGSelectSetViewController * selectSetViewController = [[VGSelectSetViewController alloc] initWithNibName:@"VGSelectSetViewController" bundle:nil];
    
    selectSetViewController.cardSets = mSetArray;
    selectSetViewController.delegate = self;
    
    
    
    [pvc presentViewController:selectSetViewController animated:YES completion:nil];
}

//****************************
//TABLE REQUIRED METHODS
//****************************


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        
        //*************************
        //DECK CHECKS
        //*************************
        //A deck may not contain more than 4 copies of one card
        //A deck may not contain more than 4 heal triggers
        //A deck may not contain more than 16 triggers
        //A deck may not contain more than 50 cards
        //***************************
        
        if([self checkForTooManyCardCopies])
        {
            if([self checkForTooManyHealTriggers])
            {
                if([self checkForTooManyTriggers])
                {
                    if([self checkForTooManyCardsInDeck])
                    {
                        [self addCardToDeck];
                        [self.delegate passDeckBack:self changedDeck:mDeck];
                        [self dismissViewControllerAnimated:YES completion:nil];

                    }
                }
            }
        }
        
    }
    if(indexPath.section    ==  3 && indexPath.row == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        [self showSelectSetView];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
      cell.selectionStyle =   UITableViewCellEditingStyleNone;
        
    }
    
    cell.detailTextLabel.text           =   nil;
    
    if(indexPath.section == 0)
    {
        
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Current Deck Size:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)mDeck.cards.count];
        }
        
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Number of Triggers in Deck:";
            cell.detailTextLabel.text =  [NSString stringWithFormat:@"%ld",(long)mTriggersInDeck];
        }
        
        if(indexPath.row == 2)
        {
            cell.textLabel.text = @"Copies of This Card in Deck:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)mCopiesInDeck];
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
        
        
    }
    
    if(indexPath.section == 2)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text =   @"Add Card(s)";
        cell.textLabel.textAlignment    = NSTextAlignmentCenter;
       
    }
    
    if(indexPath.section == 3)
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
            senderCell.detailTextLabel.text=  [NSString stringWithFormat:@"%ld", (long)mCopiesToAdd];
        }
            break;
        
    }

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
            return 2;
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
    }
    return 0;
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
