//
//  VGCardCell.m
//  Deckbuilder
//
//  Created by Daryl Fensom on 02/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGCardCell.h"

@implementation VGCardCell

@synthesize lblName = mLblName;
@synthesize lblGrade = mLblGrade;
@synthesize lblClan = mLblClan;
@synthesize lblTrigger = mlblTrigger;
@synthesize lblStats = mLblStats;
@synthesize lblEffect = mLblEffect;
@synthesize activityIndicator = mActivityIndicator;
@synthesize cardImageView = mCardImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"VGCardCellView" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    
    
    }
    
    
    
    
     
     
    return self;
}

-(void)resetCell
{
    
    mActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    
    CGFloat centerX = mCardImageView.center.x - mActivityIndicator.bounds.size.width/4;
    
    CGFloat centerY = mCardImageView.center.y - mActivityIndicator.bounds.size.height/4;
    
    CGPoint activityIndicatorLocation = CGPointMake(centerX, centerY);
    
    [mActivityIndicator setCenter:activityIndicatorLocation];
    
    [mCardImageView addSubview:mActivityIndicator];
    [mActivityIndicator startAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCardName:(NSString*)inName
{
    [mLblName setText:inName];
}

-(void) setGrade:(NSString*)inGrade
{
    NSString * gradeText = [NSString stringWithFormat:@"Grade %@",inGrade];
    [mLblGrade setText:gradeText];
}

-(void) setClan:(NSString*)inClan
{
    [mLblClan setText:[inClan substringFromIndex:1]];
}

-(void) setTrigger:(NSString*)inTrigger
{
    NSRange isRange = [inTrigger rangeOfString:@"none" options:NSCaseInsensitiveSearch];
    if(isRange.location == 0) {
        [mlblTrigger setText:@""];
    }
    else
    {
        NSString * triggerText = inTrigger;
        [mlblTrigger setText:triggerText];
    }
}

-(void) setStats:(NSString*)inPower defense:(NSString*)inDefense
{
    
    if(inDefense == nil)
    {
         NSString * statsText = [NSString stringWithFormat:@"%@ Power",[inPower substringFromIndex:1]];
        [mLblStats setText:statsText];
    }
    else
    {
        NSString * statsText = [NSString stringWithFormat:@"%@ Power / %@ Shield",[inPower substringFromIndex:1],inDefense];
        [mLblStats setText:statsText];
    }
    
    
    
}

-(void) setEffect:(NSString*)inEffect
{
    [mLblEffect setText:inEffect];
   
    
    
   
}







@end
