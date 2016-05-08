
//  VGDeckViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 11/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGDeckViewController.h"
#import "VGCard.h"
#import "VGHandViewController.h"

@interface VGDeckViewController ()

@end

@implementation VGDeckViewController


@synthesize cards                   =   mCards;
@synthesize deck                    =   mDeck;

@synthesize vanguardActionSheetDelegate = mVanguardActionSheetDelegate;

@synthesize numberOfGradeZeroUnits  =   mNumberOfGradeZeroUnits;

@synthesize numberOfGradeOneUnits  =   mNumberOfGradeOneUnits;

@synthesize numberOfGradeTwoUnits  =   mNumberOfGradeTwoUnits;

@synthesize numberOfGradeThreeUnits  =   mNumberOfGradeThreeUnits;

@synthesize numberOfGradeFourUnits  =   mNumberOfGradeFourUnits;

@synthesize numberOfGUnits      =   mNumberOfGUnits;

@synthesize gradeZeroUnits      =   mGradeZeroUnits;
@synthesize gradeOneUnits       =   mGradeOneUnits;
@synthesize gradeTwoUnits       =   mGradeTwoUnits;
@synthesize gradeThreeUnits     =   mGradeThreeUnits;
@synthesize gradeFourUnits      =   mGradeFourUnits;
@synthesize gUnits              =   mGUnits;
@synthesize deckNameField       =   mDeckNameField;
@synthesize imageGrabThread     =   mImageGrabThread;
@synthesize visibleCells        =   mVisibleCells;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    mVisibleCells = [[NSMutableArray alloc] init];
    
    if(mDeck == nil)
    {
        mDeck       =   [[VGDeck alloc] init];
        mDeck.name  =   @"Untitled Deck";
    }
    
    
    
    self.title  =   mDeck.name;
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddCardButtonPressed)];
    
    self.navigationItem.rightBarButtonItem=  rightButton;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self generateTableArrays];
    [self generateGUnitArray];
    [self.tableView reloadData];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            
                                                            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                                            UITextAttributeFont: [UIFont fontWithName:@"Lato-Regular" size:17.0f]}];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)AddCardButtonPressed
{
    VGCardsViewController * view = [[VGCardsViewController alloc]initWithNibName:@"VGCardsViewController" bundle:nil];
    
    view.cards      =   mCards;
    view.deck       =   mDeck;
    view.delegate   =   self;
    
    [self.navigationController pushViewController:view animated:YES];
    
}

-(void)passDeckBack:(VGCardsViewController *)controller changedDeck:(VGDeck *)deck
{
    mDeck   =   deck;
    [self.delegate passDeckBack:self changedDeck:mDeck];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            tempCardName = [mGradeZeroUnits objectAtIndex:indexPath.row];
            
        }
            break;
        case 1:
        {
            tempCardName = [mGradeOneUnits objectAtIndex:indexPath.row];
        }
            break;
        case 2:
        {
            tempCardName = [mGradeTwoUnits objectAtIndex:indexPath.row];
        }
            break;
        case 3:
        {
            tempCardName = [mGradeThreeUnits objectAtIndex:indexPath.row];
        }
            break;
        case 4:
        {
            tempCardName = [mGradeFourUnits objectAtIndex:indexPath.row];
        }
            break;
        case 5:
        {
            tempCardName = [mGUnits objectAtIndex:indexPath.row];
        }
            break;
            
    }
    
    tempCard = [self getCardByDeckTableEntry:tempCardName];
    
    [cell.lblName setText:tempCardName];
    [cell setGrade:tempCard.Grade];
    [cell setClan:tempCard.Clan];
    [cell setTrigger:tempCard.Trigger];
    [cell setStats:tempCard.Power defense:tempCard.Shield];
    [cell setEffect:tempCard.Effect];
    [mVisibleCells addObject:cell];
    
    
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
        
        [cell.cardImageView setImage:mCardImage];
        cell.cardImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        //[cell resetCell];
        
    }
    else
    {
        
        [self performSelectorInBackground:@selector(grabCardImage:) withObject:imageToGrabObject];
    }
    
    
    
    
    
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
    
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, cell.frame.size.width);
    
    cell.indentationLevel = 0;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
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
        
        NSString * imageGrabURL = [inImageToGrab.card getImageURL:95];
        if([mVisibleCells containsObject:inImageToGrab.cardCell])
        {
            
            [inImageToGrab.cardCell.imageView setImage:nil];
            UIImage * mCardImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageGrabURL]]];
            
            UIImage * resizedImage = [self imageScaledToSize:mCardImage :CGSizeMake(91, 148)];
            
            if([mVisibleCells containsObject:inImageToGrab.cardCell])
            {
                
                if(inImageToGrab.cardCell.imageView !=nil)
                {
                    
                    [inImageToGrab.cardCell.imageView setImage:resizedImage];
                    //[inImageToGrab.cardCell.imageView setBounds:CGRectMake(0, 0, 81, 119)];
                    
                }
                
                
                CGSize resizedImageSize = resizedImage.size;
                
                NSData *imgData = UIImagePNGRepresentation(resizedImage);
                // Identify the home directory and file name
                NSString  *jpgPath = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[inImageToGrab.card.Name stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
                
                
                [imgData writeToFile:jpgPath atomically:NO];
                
                
            }
            
            
            inImageToGrab.cardCell.imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
            
            NSArray *viewsToRemove = [inImageToGrab.cardCell.imageView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
        }}
    
    
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VGCardDetailViewController * view = [[VGCardDetailViewController alloc]initWithNibName:@"VGCardDetailViewController" bundle:nil];
    
    VGCardCell * cardCell = (VGCardCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    
    
    view.card       =   [self getCardByDeckTableEntry:cardCell.lblName.text];
    view.deck       =   mDeck;
    view.delegate   =   self;
    
    [self.navigationController pushViewController:view animated:YES];
    
    
}




- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, tableView.bounds.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    label.textColor = [UIColor whiteColor];
    
    switch(section)
    {
        case 0:
        {
            label.text = [NSString stringWithFormat:@"Grade 0 Units: %d",mNumberOfGradeZeroUnits];
        }
            break;
        case 1:
        {
            label.text = [NSString stringWithFormat:@"Grade 1 Units:  %d",mNumberOfGradeOneUnits];
        }
            break;
        case 2:
        {
            label.text = [NSString stringWithFormat:@"Grade 2 Units:  %d",mNumberOfGradeTwoUnits];
        }
            break;
        case 3:
        {
            label.text = [NSString stringWithFormat:@"Grade 3 Units:  %d",mNumberOfGradeThreeUnits];
        }
            break;
        case 4:
        {
            label.text = [NSString stringWithFormat:@"Grade 4 Units:  %d",mNumberOfGradeFourUnits];
        }
            break;
        case 5:
        {
            label.text = [NSString stringWithFormat:@"G-Units:  %lu",(unsigned long)mNumberOfGUnits];
        }
            break;
            
    }

    
    
    [headerView setBackgroundColor:[UIColor colorWithRed:52/255.0 green:73/255.0 blue:94/255.0 alpha:1]];
    [headerView addSubview:label];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Get the text so we can measure it
    static NSString *CellIdentifier = @"Cell";
    
    VGCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return 130 + cell.lblEffect.frame.size.height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return mGradeZeroUnits.count;
        }
            break;
        case 1:
        {
            return mGradeOneUnits.count;
        }
            break;
        case 2:
        {
            return mGradeTwoUnits.count;
        }
            break;
        case 3:
        {
            return mGradeThreeUnits.count;
        }
            break;
        case 4:
        {
            return mGradeFourUnits.count;
        }
            break;
        case 5:
        {
            return mGUnits.count;
        }
            break;
            
        default:
            break;
    }
    return mDeck.cards.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}




-(VGCard *)getCardByDeckTableEntry:(NSString *)tableEntry
{
    NSString * cardName = @"";
    if([[tableEntry substringToIndex:2] integerValue] > 9)
    {
        cardName = [tableEntry substringFromIndex:5];
    }
    else
    {
        cardName = [tableEntry substringFromIndex:4];
    }
    
    
    for (int i = 0; i < mCards.count; i++)
    {
        VGCard * searchCard = [mCards objectAtIndex:i ];
        if ([searchCard.Name isEqualToString:cardName]) {
            return searchCard;
        }
    }
    
    return nil;
    
}

-(NSInteger)getDeckCardIDByDeckTableEntry:(NSString *)tableEntry
{
    NSString * cardName = [tableEntry substringFromIndex:4];
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * searchCard = [mDeck.cards objectAtIndex:i ];
        if ([searchCard.Name isEqualToString:cardName]) {
            return i;
        }
    }
    
    return 0;
    
}

-(NSInteger)getExtraDeckCardIDByDeckTableEntry:(NSString *)tableEntry
{
    NSString * cardName = [tableEntry substringFromIndex:4];
    for (int i = 0; i < mDeck.extraCards.count; i++)
    {
        VGCard * searchCard = [mDeck.extraCards objectAtIndex:i ];
        if ([searchCard.Name isEqualToString:cardName]) {
            return i;
        }
    }
    
    return 0;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}


- (void)editDeckName{
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setTitle:@"Enter Deck Name"];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:@"OK"];
    [dialog addButtonWithTitle:@"Cancel"];
    
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 100.0);
    //[dialog setTransform: moveUp];
    [dialog show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        mDeck.name  =    [alertView textFieldAtIndex:0].text;
        [self setTitle:mDeck.name];
        
    }
    
    
}

- (IBAction)enterEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        
        [self.tableView setEditing:FALSE animated:TRUE];
        
        
        UIBarButtonItem * editButton = sender;
        
        [editButton setTitle: @"Remove Card"];
        
        [self.delegate passDeckBack:self changedDeck:mDeck];
        //  [[self.tableView tableViewsetEditing:NO animated:YES];
        
        //[self.editButtonsetTitle:@"Edit"forState:UIControlStateNormal];
        
    }
    
    else {
        
        // [self.editButtonsetTitle:@"Done"forState:UIControlStateNormal];
        
        
        // Turn on edit mode
        
        
        // [self.tableViewsetEditing:YESanimated:YES];
        
        
        
        [self.editButton setTitle: @"Done"];
        
        
        [self.tableView setEditing:TRUE animated:TRUE];
        
    }
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        
        VGCardCell * cardCell = (VGCardCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        
        
        
        if(indexPath.section != 5){
            int deckCardID = [self getDeckCardIDByDeckTableEntry:cardCell.lblName.text];
            [mDeck.cards removeObjectAtIndex:deckCardID];
            [mDeck.cardsSets removeObjectAtIndex:deckCardID];

        }
        else
        {
            int deckCardID = [self getExtraDeckCardIDByDeckTableEntry:cardCell.lblName.text];
            [mDeck.extraCards removeObjectAtIndex:deckCardID];
            [mDeck.extraCardSets removeObjectAtIndex:deckCardID];
        }
        
        
        
        switch (indexPath.section) {
            case 0:
                mNumberOfGradeZeroUnits--;
                
                
                break;
            case 1:
                mNumberOfGradeOneUnits--;
                break;
            case 2:
                mNumberOfGradeTwoUnits--;
                break;
            case 3:
                mNumberOfGradeThreeUnits--;
                break;
            case 4:
                mNumberOfGradeFourUnits--;
                break;
            case 5:
                mNumberOfGUnits--;
            default:
                break;
        }
        [self generateTableArrays];
        [self generateGUnitArray];
        if(indexPath.section < 6)
        {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation: UITableViewRowAnimationAutomatic];
        }
        else
        {
            [self.tableView reloadData];
        }
        
        
        
        //[self.dataSourceArray removeObjectAtIndex:indexPath.row];
        
        // You might want to delete the object from your Data Store if you’re using CoreData
        
        // [context deleteObject:pairToDelete];
        
        // NSError *error;
        
        // [context save:&error];
        
        // Animate the deletion
        
        //[tableView deleteRowsAtIndexPaths:[NSArrayarrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        // Additional code to configure the Edit Button, if any
        
        //  if (self.dataSourceArray.count == 0) {
        
        //     self.editButton.enabled = NO;
        
        //    self.editButton.titleLabel.text = @”Edit”;
        
        // }
        
    }
    
    
    
    
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

-(void) generateGUnitArray
{
    int nameOccurrenceCount =   0;
    mNumberOfGUnits         =   0;
    mGUnits                 =   [[NSMutableArray alloc] init];
    
    NSString * currentCardName;
    
    for(int i = 0 ; i < mDeck.extraCards.count; i++)
    {
        VGCard* currentCard = [mDeck.extraCards objectAtIndex:i];
        
        if(currentCardName == nil)
        {
            currentCardName = currentCard.Name;
            nameOccurrenceCount = 1;
        }
        else
        {
            if([currentCardName isEqual:currentCard.Name]){
                nameOccurrenceCount++;
            }
            else
            {
                NSString  * cardCountString = [NSString stringWithFormat:@"%d x",nameOccurrenceCount];
                NSString  * arrayEntry = [NSString stringWithFormat:@"%@ %@",cardCountString,currentCardName];
                
                [mGUnits addObject:arrayEntry];
                
                currentCardName = currentCard.Name;
                nameOccurrenceCount = 1;
                
            }
        }
        
        if(i == mDeck.extraCards.count -1)
        {
            NSString  * cardCountString = [NSString stringWithFormat:@"%d x",nameOccurrenceCount];
            NSString  * arrayEntry = [NSString stringWithFormat:@"%@ %@",cardCountString,currentCardName];
            [mGUnits addObject:arrayEntry];
            mNumberOfGUnits+= nameOccurrenceCount;
            
        }
        
    }
    
    
    
}

-(void) generateTableArrays
{
    //****************************************
    //Sort Deck into triggers and normal units
    //****************************************
    
    [mDeck sortDeckByName];
    
    int nameOccurrenceCount =   0;
    
    
    mNumberOfGradeZeroUnits =   0;
    mNumberOfGradeOneUnits  =   0;
    mNumberOfGradeTwoUnits  =   0;
    mNumberOfGradeThreeUnits=   0;
    mNumberOfGradeFourUnits =   0;
    mNumberOfGUnits         =   0;
    
    NSString * currentCardName;
    NSInteger currentCardGrade  =   0;
    
    
    
    mGradeZeroUnits     =   [[NSMutableArray alloc] init];
    mGradeOneUnits      =   [[NSMutableArray alloc] init];
    mGradeTwoUnits      =   [[NSMutableArray alloc] init];
    mGradeThreeUnits    =   [[NSMutableArray alloc] init];
    mGradeFourUnits     =   [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * currentCard    =   [mDeck.cards objectAtIndex:i];
        
        if(i == 0) //Set the first card name
        {
            currentCardName =   currentCard.Name;
            nameOccurrenceCount = 0 ;
            
            currentCardGrade = [currentCard getGrade];
            
            
        }
        
        
        if([currentCardName isEqual:currentCard.Name])
        {
            //Add one to the current card count
            nameOccurrenceCount++;
            
        }
        else
        {
            
            //Add the old card to to the array
            
            NSString  * cardCountString = [NSString stringWithFormat:@"%d x",nameOccurrenceCount];
            
            NSString  * arrayEntry = [NSString stringWithFormat:@"%@ %@",cardCountString,currentCardName];
            
            
            
            switch(currentCardGrade)
            {
                case 0:
                {
                    [mGradeZeroUnits addObject:arrayEntry];
                    mNumberOfGradeZeroUnits += nameOccurrenceCount;
                }
                    break;
                case 1:
                {
                    [mGradeOneUnits addObject:arrayEntry];
                    mNumberOfGradeOneUnits += nameOccurrenceCount;
                    
                }
                    break;
                case 2:
                {
                    [mGradeTwoUnits addObject:arrayEntry];
                    mNumberOfGradeTwoUnits += nameOccurrenceCount;
                    
                }
                    break;
                case 3:
                {
                    [mGradeThreeUnits addObject:arrayEntry];
                    mNumberOfGradeThreeUnits += nameOccurrenceCount;
                    
                }
                    break;
                case 4:
                {
                    [mGradeFourUnits addObject:arrayEntry];
                    mNumberOfGradeFourUnits += nameOccurrenceCount;
                }
                    break;
            }
            
            //Dealing with next card
            
            currentCardName = currentCard.Name;
            
            nameOccurrenceCount = 1;
            
            
            
            currentCardGrade = [currentCard getGrade];
            
            
            
        }
        
        if(i == mDeck.cards.count - 1)
        {
            
            NSString  * cardCountString = [NSString stringWithFormat:@"%d x",nameOccurrenceCount];
            
            NSString  * arrayEntry = [NSString stringWithFormat:@"%@ %@",cardCountString,currentCardName];
            
            //nameOccurrenceCount++;
            
            switch(currentCardGrade)
            {
                case 0:
                {
                    [mGradeZeroUnits addObject:arrayEntry];
                    mNumberOfGradeZeroUnits += nameOccurrenceCount;
                }
                    break;
                case 1:
                {
                    [mGradeOneUnits addObject:arrayEntry];
                    mNumberOfGradeOneUnits += nameOccurrenceCount;
                    
                }
                    break;
                case 2:
                {
                    [mGradeTwoUnits addObject:arrayEntry];
                    mNumberOfGradeTwoUnits += nameOccurrenceCount;
                    
                }
                    break;
                case 3:
                {
                    [mGradeThreeUnits addObject:arrayEntry];
                    mNumberOfGradeThreeUnits += nameOccurrenceCount;
                    
                }
                    break;
                case 4:
                {
                    [mGradeFourUnits addObject:arrayEntry];
                    mNumberOfGradeFourUnits += nameOccurrenceCount;
                }
                    break;
            }
            
        }
        
        
        
        
    }
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
        {
            [self editDeckName];
        }
            break;
        case 1:
            [self postToFacebook];
            break;
        case 2:
            [self emailDeck];
            break;
        case 3:
            [self printDeck];
            break;
    }
}



- (IBAction)btnActionPressed:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"Deck Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Change Deck Name",@"Share on Facebook",@"Email Decklist",@"Print Decklist", nil];
    
    
    
    [actionSheet showFromBarButtonItem:self.btnAction animated:YES];
    
}

-(void)postToFacebook
{
    
    
    NSString* decklistString = [self getDeckListString];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebook = [[SLComposeViewController alloc]init];
        
        facebook =[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebook setInitialText:[NSString stringWithFormat:@"Hey check out my Vanguard Deck: \n\n%@\n Created with Vanguard Deck Builder",decklistString]];
        [self presentViewController:facebook animated:YES completion:nil];
        
        [facebook setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result)
            {
                case SLComposeViewControllerResultCancelled:
                    output = @"Post Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successful";
                    break;
                default:
                    break;
            }
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }];
        
    }
}

-(void)emailDeck{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    
    [mailController setMailComposeDelegate:self];
    
    NSString * decklistString   =   [self getDeckListString];
    NSString * emailString      = [NSString stringWithFormat:@"Hey check out my Vanguard Deck: \n\n%@\n Created with Vanguard Deck Builder",decklistString];
    
    [mailController setSubject:[NSString stringWithFormat:@"Vanguard Deck: %@",mDeck.name]];
    [mailController setMessageBody:emailString isHTML:NO];
    [self presentViewController:mailController animated:YES completion:nil];
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)printDeck{
    UIPrintInteractionController * printController = [UIPrintInteractionController sharedPrintController];
    
    UIPrintInfo * printInfo =[UIPrintInfo printInfo];
    
    printInfo.outputType    =   UIPrintInfoOutputGeneral;
    printInfo.jobName       =   @"Vanguard Deck Print";
    NSString * deckString   =   [self getDeckListString];
    NSData * printData  =   [deckString dataUsingEncoding:NSUTF8StringEncoding];
    
    printController.printingItem    =   printData;
    
    [printController presentAnimated:YES completionHandler:nil];
}

-(NSString *)getDeckListString
{
    //*******************
    //DECKLIST ASSEMBLE
    //*******************
    NSString * decklistString   = [NSString stringWithFormat:@"%@ \n\n",mDeck.name];
    
    
    
    decklistString = [NSString stringWithFormat:@"%@Grade 0 Units: %d \n\n",decklistString,mNumberOfGradeZeroUnits];
    
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * card = [mDeck.cards objectAtIndex:i];
        
        NSArray * cardSets = [card getSetArray];
        
        int cardSetNumber = [mDeck getCardSetIDfrom:i];
        NSString * cardSet = [cardSets objectAtIndex:cardSetNumber];
        
        if([card getGrade] == 0)
        {
            decklistString = [NSString stringWithFormat:@"%@%@               %@\n",decklistString,card.Name,cardSet];
        }
        
    }
    
    
    
    
    decklistString = [NSString stringWithFormat:@"%@\nGrade 1 Units: %d \n\n",decklistString,mNumberOfGradeOneUnits];
    
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * card = [mDeck.cards objectAtIndex:i];
        
        NSArray * cardSets = [card getSetArray];
        
        int cardSetNumber = [mDeck getCardSetIDfrom:i];
        NSString * cardSet = [cardSets objectAtIndex:cardSetNumber];
        
        if([card getGrade] == 1)
        {
            decklistString = [NSString stringWithFormat:@"%@%@               %@\n",decklistString,card.Name,cardSet];
        }
        
    }
    
    decklistString = [NSString stringWithFormat:@"%@\nGrade 2 Units: %d \n\n",decklistString,mNumberOfGradeTwoUnits];
    
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * card = [mDeck.cards objectAtIndex:i];
        
        NSArray * cardSets = [card getSetArray];
        
        int cardSetNumber = [mDeck getCardSetIDfrom:i];
        NSString * cardSet = [cardSets objectAtIndex:cardSetNumber];
        
        
        if([card getGrade] == 2)
        {
            decklistString = [NSString stringWithFormat:@"%@%@               %@\n",decklistString,card.Name,cardSet];
        }
        
    }
    
    decklistString = [NSString stringWithFormat:@"%@\nGrade 3 Units: %d \n\n",decklistString,mNumberOfGradeThreeUnits];
    
    for (int i = 0; i < mDeck.cards.count; i++)
    {
        VGCard * card = [mDeck.cards objectAtIndex:i];
        
        NSArray * cardSets = [card getSetArray];
        
        int cardSetNumber = [mDeck getCardSetIDfrom:i];
        NSString * cardSet = [cardSets objectAtIndex:cardSetNumber];
        
        
        if([card getGrade] == 3)
        {
            decklistString = [NSString stringWithFormat:@"%@%@               %@\n",decklistString,card.Name,cardSet];
        }
        
    }
    
    if(mGradeFourUnits.count >0)
    {
        decklistString = [NSString stringWithFormat:@"%@\nGrade 4 Units: %d \n\n",decklistString,mNumberOfGradeFourUnits];
        for (int i = 0; i < mDeck.cards.count; i++)
        {
            VGCard * card = [mDeck.cards objectAtIndex:i];
            
            NSArray * cardSets = [card getSetArray];
            
            int cardSetNumber = [mDeck getCardSetIDfrom:i];
            NSString * cardSet = [cardSets objectAtIndex:cardSetNumber];
            
            
            if([card getGrade] == 4)
            {
                decklistString = [NSString stringWithFormat:@"%@%@               %@\n",decklistString,card.Name,cardSet];
            }
            
        }
    }
    
    decklistString = [NSString stringWithFormat:@"%@\nG-Zone Units: %d \n\n",decklistString,mNumberOfGUnits];
    
    for (int i = 0; i < mDeck.extraCards.count; i++)
    {
        VGCard * card = [mDeck.extraCards objectAtIndex:i];
        
        NSArray * cardSets = [card getSetArray];
        
        int cardSetNumber = [mDeck getExtraCardSetIDfrom:i];
        NSString * cardSet = [cardSets objectAtIndex:cardSetNumber];

        decklistString = [NSString stringWithFormat:@"%@%@               %@\n",decklistString,card.Name,cardSet];
        
    }


    return decklistString;
}

//**************HAND DRAW****************//

- (IBAction)btnDrawHandPressed:(id)sender {
    if (mDeck.cards.count < 50)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Deck" message:@"A deck must contain 50 cards" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [message show];
    }
    else
    {
        
        VGHandViewController * handViewController = [[VGHandViewController alloc] initWithNibName:@"VGHandViewController" bundle:nil];
        handViewController.deck = mDeck;
        [self.navigationController presentViewController:handViewController animated:YES completion:nil];
        
    }
}

-(void) dismissActionSheet:(id)sender {
    UIActionSheet *actionSheet =  (UIActionSheet *)[(UIView *)sender superview];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}





@end
