//
//  VGVanguardSelectorActionSheetDelegate.m
//  Deckbuilder
//
//  Created by Daryl Fensom on 14/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGVanguardSelectorActionSheetDelegate.h"

@implementation VGVanguardSelectorActionSheetDelegate


@synthesize grade0UnitArray = mGrade0UnitArray;
//@synthesize parent = mParent;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [mGrade0UnitArray count];
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [mGrade0UnitArray objectAtIndex:row];
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    NSLog(@"Chosen item: %@", [mGrade0UnitArray objectAtIndex:row]);
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
            
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
           
            break;
    }
}


@end
