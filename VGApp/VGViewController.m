//
//  VGViewController.m
//  VGApp
//
//  Created by Daryl Fensom on 01/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#define FONT_LATO(s) [UIFont fontWithName:@"Lato-Regular" size:s];

#import "VGViewController.h"
#import "VGCardsViewController.h"
#import "VGCardsXMLParser.h"
#import "VGCard.h"
#import "VGCardDetailViewController.h"
#import "VGDeckViewController.h"
#import "VGDecksXMLParser.h"
#import "VGDeck.h"

#import "SBJson/SBJson.h"




@interface VGViewController ()

@end

@implementation VGViewController

@synthesize cards;
@synthesize decks;
@synthesize buttonTitles = mButtonTitles;
@synthesize didCardGrabFail =   mDidCardGrabFail;
@synthesize parser          =   mParser;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"Cards"
    //                                    ofType:@"xml"];
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_linen.png"]];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    
    
    mButtonTitles   =   [[NSArray alloc]initWithObjects:@"Deck Builder",@"Card Search",@"View Random Card",@"Update Card Database",@"Give Feedback",@"Version Zero on Facebook", nil];
    
    [self loadXMLData];
    
    
    
    
    
}
//************************************
//THIS CODE IS IMPORTANT
//************************************

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if(cards.count == 0)
    {
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        HUD.detailsLabelText = @"Updating Card Database";
        HUD.square = YES;
        HUD.labelFont = FONT_LATO(15);
        [HUD showWhileExecuting:@selector(updateCardDatabaseJSON) onTarget:self withObject:nil animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCardlistPressed:(id)sender {
    VGCardsViewController * cardsView = [[VGCardsViewController alloc] initWithNibName:@"VGCardsViewController" bundle:nil];
    
    
    cardsView.cards     =   cards;
    
    [self.navigationController pushViewController:cardsView animated:YES];
    
}

- (IBAction)btnSaveXMLPressed:(id)sender {
    
    [self saveCardsToXML];
    
}

- (IBAction)btnUpdatePressed:(id)sender {
    [self updateCardDatabaseJSON];
}

- (IBAction)btnAlfredEarlyPressed:(id)sender {
    VGCardDetailViewController * view = [[VGCardDetailViewController alloc] initWithNibName:@"VGCardDetailViewController" bundle:nil];
    
    
    view.card       =   [cards objectAtIndex:0];
    
    [self.navigationController presentViewController:view animated:YES completion:nil];
}

- (IBAction)btnEditDeckPressed:(id)sender {
    VGDeckViewController * view = [[VGDeckViewController alloc]initWithNibName:@"VGDeckView" bundle:nil];
    
    view.cards  =   cards;
    view.deck   =   [decks objectAtIndex:0];
    
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)btnDeckBuilderPressed:(id)sender {
    VGDeckViewerViewController * view = [[VGDeckViewerViewController alloc] initWithNibName:@"VGDeckViewerViewController" bundle:nil];
    view.delegate = self;
    view.decks  =   decks;
    view.cards  =   cards;
    
    [self.navigationController pushViewController:view animated:YES];
    
}



-(void)updateCardDatabase
{
    
    NSLog(@"UPDATING CARD DATABASE");
    mDidCardGrabFail    =   false;
    //*********************
    //UPDATE FROM LOCAL DATABASE
    //**************************
    NSString *url = @"http://www.versionzero.co.uk/API/VG/GrabData.php";
    
    //NSString *url = @"http://localhost/VanguardService/grabData.php";
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    //theConnection = [[[NSURLConnection alloc] send:theRequest delegate:self] ];
    
    NSURLResponse  *response;
    NSError *error;
    
    NSData *urlData             =   [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    NSString *data                   =   [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
    
    NSData* cardData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    
    if(error != nil)
    {
        mDidCardGrabFail    =   true;
        return;
    }
    
    [self doParse:cardData];
    
    //[self saveCardsToXML];
    //[self saveCardsToJSON];
    [self.tableView reloadData];
    
}

-(void)updateCardDatabaseJSON
{
    
    NSString *url = @"http://www.versionzero.co.uk/API/VG/JSON/GrabData.php";
    
    
    //NSString *url = @"http://192.168.1.66/VanguardService/json/grabData.php";
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    mParser              =   [[SBJsonParser alloc] init];
    
    
    //theConnection = [[[NSURLConnection alloc] send:theRequest delegate:self] ];
    
    NSURLResponse  *response;
    NSError *error;
    
    NSData *urlData             =   [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    NSString *data                   =   [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    NSDictionary  * jsonArray = [mParser objectWithString:data];
    
    
    NSArray * jsonObject = [jsonArray objectForKey:@"Cards"];
    
    if(jsonObject){
        cards   =   [[NSMutableArray alloc] init];
        
        
        for (int i = 0; i < jsonObject.count; i++)
        {
            NSDictionary *item =   [jsonObject objectAtIndex:i];
            
            NSString *Name              =   [item objectForKey:@"Name"];
            if([Name rangeOfString:@"Tirami" options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                Name = [[NSString alloc] initWithString:Name];
            }
            NSString *ImageLocation     =   [item objectForKey:@"ImageLocation"];
            NSString *Trigger           =   [item objectForKey:@"Trigger"];
            NSString *Grade             =   [item objectForKey:@"Grade"];
            NSString *Power             =   [item objectForKey:@"Power"];
            NSString *Shield            =   [item objectForKey:@"Shield"];
            NSString *Clan              =   [item objectForKey:@"Clan"];
            NSString *Effect            =   [item objectForKey:@"Effect"];
            NSString *Set               =   [item objectForKey:@"Set"];
            VGCard *newItem             =   [[VGCard alloc] init];
            newItem.Name                =   Name;
            newItem.ImageLocation       =   ImageLocation;
            newItem.Trigger             =   Trigger;
            newItem.Grade               =   Grade;
            newItem.Power               =   Power;
            newItem.Shield              =   Shield;
            newItem.Clan                =   Clan;
            newItem.Effect              =   Effect;
            newItem.Set                 =   Set;
            
            [cards addObject:newItem];
            
        }
        
        if(error != nil)
        {
            mDidCardGrabFail    =   true;
            return;
        }
        
        [self saveCardsToXML];
        [self.tableView reloadData];
    }
    
}

-(void)saveCardsToXML
{
    
    NSLog(@"Saving Card Database to XML");
    
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *file = [applicationDocumentsDir stringByAppendingPathComponent:@"cards.xml"];
    NSLog(@"file: %@", file);
    NSOutputStream *output = [NSOutputStream outputStreamToFileAtPath:file append:NO];
    [output open];
    
    NSString * xmlString;
    xmlString   =   @"<Cards>";
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    //**************************
    //STREAM THE DATA TO THE XML
    //**************************
    [output write:data.bytes maxLength:data.length];
    
    
    for (int i = 0; i < cards.count; i++)
    {
        VGCard * tempCard   =   [cards objectAtIndex:i];
        data = [[tempCard toXML] dataUsingEncoding:NSUTF8StringEncoding];
        [output write:data.bytes maxLength:data.length];
    }
    
    xmlString   =   @"</Cards>";
    data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [output write:data.bytes maxLength:data.length];
    
    [output close];
    
}

-(void)saveCardsToJSON
{
    NSLog(@"Saving Card Database to JSON");
    NSString * JSONString = [[NSString alloc] init];\
    
    
    JSONString = [JSONString stringByAppendingString:@"["];
    
    for (int i = 0; i < cards.count; i++)
    {
        VGCard * tempCard   =   [cards objectAtIndex:i];
        JSONString   =   [JSONString stringByAppendingString:[tempCard toJSON]];
        if(i < cards.count - 2)
        {
            JSONString   =   [JSONString stringByAppendingString:@","];
        }
    }
    
    JSONString = [JSONString stringByAppendingString:@"]"];
    
    // NSData *data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];  // Load XML data from web
    
    
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:@"cards.json"];
    
    [JSONString writeToFile:path atomically:TRUE];
    
}

-(void)loadXMLData
{
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //USED IN TESTING, CHANGE FOR REAL
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"decks.xml" ofType:nil];
    
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:@"cards.xml"];
    NSData *xmlFileContents2 = [NSData dataWithContentsOfFile:path];
    
    [self doParse:xmlFileContents2];
}

- (void) doParse:(NSData *)data {
    
    // create and init NSXMLParser object
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:data];
    
    NSString *test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // create and init our delegate
    VGCardsXMLParser *parser = [[VGCardsXMLParser alloc] initXMLParser];
    
    // set delegate
    [nsXmlParser setDelegate:parser];
    
    // parsing...
    BOOL success = [nsXmlParser parse];
    
    // test the result
    if (success) {
        NSLog(@"No errors - card count : %i", [parser.cards count]);
        // get array of users here
        //  NSMutableArray *users = [parser users];
        [nsXmlParser setDelegate:nil];
        cards       =   [parser cards];
        //LOAD DECKS
        [self loadDecksXMLData];
        
    } else {
        NSLog(@"Error parsing document!");
        
    }
    
}

-(void)loadDecksXMLData
{
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //USED IN TESTING, CHANGE FOR REAL
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"decks.xml" ofType:nil];
    
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:@"decks.xml"];
    NSData *xmlFileContents2 = [NSData dataWithContentsOfFile:path];
    
    NSString *deckstring = [[NSString alloc] initWithData:xmlFileContents2 encoding:NSUTF8StringEncoding];
    
    if(([deckstring rangeOfString:@"<ExtraDeck>" options:NSCaseInsensitiveSearch].length==0)) {
        deckstring = [deckstring stringByReplacingOccurrencesOfString: @"</Deck>" withString:@"</Deck><ExtraDeck></ExtraDeck>"];
    }
    
    NSData *deckStringData = [deckstring dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doDecksParse:deckStringData];
}

- (void) doDecksParse:(NSData *)data {
    
    // create and init NSXMLParser object
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:data];
    
    // create and init our delegate
    VGDecksXMLParser *parser = [[VGDecksXMLParser alloc] initXMLParser];
    parser.cards = cards;
    
    // set delegate
    [nsXmlParser setDelegate:parser];
    
    // parsing...
    BOOL success = [nsXmlParser parse];
    
    // test the result
    if (success) {
        NSLog(@"No errors - deck count : %i", [parser.decks count]);
        // get array of users here
        //  NSMutableArray *users = [parser users];
        
        
        decks       =   [parser decks];
        
    } else {
        NSLog(@"Error parsing document!");
    }
    
    
}

-(void)viewRandomCard
{
    int random = arc4random_uniform(cards.count);
    
    VGCardDetailViewController * cardViewController = [[VGCardDetailViewController alloc] initWithNibName:@"VGCardDetailViewController" bundle:nil];
    cardViewController.card =   [cards objectAtIndex:random];
    
    [self.navigationController pushViewController:cardViewController animated:YES];
}


//*********************************************
//TABLE VIEW STUFF
//*********************************************
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![tableView cellForRowAtIndexPath:indexPath].selectionStyle == UITableViewCellSelectionStyleNone)
    {
        switch(indexPath.section)
        {
            case 1:
                if(cards.count ==0)
                {
                    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"No Cards Found" message:@"Please update your card database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                    [self btnDeckBuilderPressed:nil];
                
                break;
            case 2:
                if(cards.count ==0)
                {
                    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"No Cards Found" message:@"Please update your card database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                    [self btnCardlistPressed:nil];
                break;
            case 3:
                if(cards.count ==0)
                {
                    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"No Cards Found" message:@"Please update your card database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                    [self viewRandomCard];
                break;
            case 4:
                ////////////////////////////////
                
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                
                HUD.delegate = self;
                HUD.labelText = @"Loading";
                HUD.detailsLabelText = @"Updating Card Database";
                HUD.square = YES;
                
                [HUD showWhileExecuting:@selector(updateCardDatabaseJSON) onTarget:self withObject:nil animated:YES];
                
                break;
            case 5:
            {
                if(indexPath.row == 0)
                {
                    [self emailFeedback];
                }
                
            }
                break;
            case 6:
            {
                
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Version-Zero-LTD/284514215012465?fref=ts"]];
                    
            }
                break;
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
        case 6:
            return 1;
            break;
            
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mButtonTitles.count + 2;
}


- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 0;
            break;
            
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 3;
            break;
        case 5:
            return 3;
            break;
        case 6:
            return 3;
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    [cell setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    
    //Buttons for first row in every section
    
    if(indexPath.section == 0){
        
        CGRect logoRect = CGRectMake(100,20,109,102);
        
        
        UIView * logoContainerView = [[UIView alloc] initWithFrame:logoRect];
        
        
        UIImageView * logoView = [[UIImageView alloc] initWithFrame: logoRect];
        
        
        
        
        logoView.image  =   [UIImage imageNamed:@"deckBuilderLogo.png"];
        logoView.clipsToBounds = true;
        
        [cell addSubview:logoView];
        
        
    }
    
    
    if(indexPath.section == 7){
        UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 20)];
        
        UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 220)];
        
        titleLabel.text = @"Cardfight Vanguard and all trademarks associated with or referred to within this application are the property of Bushiroad. \n\n Version Zero is not endorsed or sponsored by Bushiroad and this application was made without their permission. Please support the official Cardfight Vanguard card game";
        
        
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_LATO(15);
        [cell addSubview:titleLabel];
        
    }
    
    if(indexPath.row == 0 && indexPath.section > 0 && indexPath.section < 7)
    {
        cell.textLabel.text = [mButtonTitles objectAtIndex:indexPath.section-1];
        
        UIImage *image;
        
        
        
        switch(indexPath.section)
        {
            case 1:
                image = [UIImage imageNamed:@"44-shoebox.png"];
                break;
            case 2:
                image = [UIImage imageNamed:@"06-magnify.png"];
                break;
            case 3:
                image = [UIImage imageNamed:@"162-receipt.png"];
                break;
            case 4:
                image = [UIImage imageNamed:@"57-download.png"];
                break;
            case 5:
                image = [UIImage imageNamed:@"18-envelope.png"];
                
                break;
            case 6:
                image = [UIImage imageNamed:@"facebook-icon.png"];
                break;
                
                
        }
        
        
        
        cell.imageView.image = image;
        
        CGRect imageRect = CGRectMake(cell.imageView.bounds.origin.x + 50,cell.imageView.bounds.origin.y,cell.imageView.bounds.size.width,cell.imageView.bounds.size.height);
        
        cell.imageView.bounds = imageRect;
        cell.imageView.frame = imageRect;
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        
        
        
        
    }
   
    
    cell.textLabel.font = FONT_LATO(15);
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    cell.detailTextLabel.font = FONT_LATO(15);
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
    return cell;
    
}


-(void)emailFeedback{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    
    [mailController setMailComposeDelegate:self];
    
    [mailController setSubject:@"Feedback on Vanguard Deckbuilder"];
    [mailController setToRecipients:[NSArray arrayWithObjects:@"daryl@versionzero.co.uk", nil]];
    [self presentViewController:mailController animated:YES completion:nil];
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //180
    return 0;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 140;
    }
    
    if(indexPath.section > 0 && indexPath.section < 7){
        return 40;
    }
    
    if(indexPath.section > 6){
        return 220;
    }
}


-(void)passDecksBack:(VGDeckViewerViewController *)controller decks:(NSMutableArray *)inDecks
{
    self.decks  =   inDecks;
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    
    HUD = nil;
    
    
    if(mDidCardGrabFail)
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Card Update Failed" message:@"Please check your internet connection and try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString *cardUpdateString = [NSString stringWithFormat:@"Card Update Complete, cards in database: %lu",(unsigned long)cards.count];
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:cardUpdateString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}


@end
