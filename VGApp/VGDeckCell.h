//
//  VGDeckCell.h
//  VGApp
//
//  Created by Daryl Fensom on 14/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VGDeckCell : UICollectionViewCell


@property (retain, nonatomic) IBOutlet UIImageView *deckImage;
@property (retain, nonatomic) IBOutlet UILabel *deckNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deleteIcon;
@property (weak, nonatomic) IBOutlet UIImageView *copyingIcon;



-(void)fadeInDelete;
-(void)fadeOutDelete;
-(void)fadeInCopy;
-(void)fadeOutCopy;

@end
