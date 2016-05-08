//
//  VGVanguardSelectorActionSheetDelegate.h
//  Deckbuilder
//
//  Created by Daryl Fensom on 14/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VGVanguardSelectorActionSheetDelegate : NSObject
<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>


@property (strong, nonatomic) NSMutableArray * grade0UnitArray;


@end
