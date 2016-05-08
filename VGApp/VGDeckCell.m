//
//  VGDeckCell.m
//  VGApp
//
//  Created by Daryl Fensom on 14/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGDeckCell.h"

@implementation VGDeckCell

@synthesize deckNameLabel   = mDeckNameLabel;
@synthesize deckImage       =   mDeckImage;
@synthesize deleteIcon      =   mDeleteIcon;
@synthesize copyingIcon        =   mCopyIcon;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"VGDeckCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    mDeleteIcon.alpha = 0;
    mCopyIcon .alpha    =   0;
    
   
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)fadeInDelete
{
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{mDeleteIcon.alpha = 1.0;}
                     completion:nil];
    [UIView commitAnimations];
}



-(void)fadeOutDelete
{
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{mDeleteIcon.alpha = 0;}
                     completion:nil];
    [UIView commitAnimations];
}

-(void)fadeInCopy
{
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{mCopyIcon.alpha = 1.0;}
                     completion:nil];
    [UIView commitAnimations];
}



-(void)fadeOutCopy
{
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{mCopyIcon.alpha = 0;}
                     completion:nil];
    [UIView commitAnimations];
}


@end
