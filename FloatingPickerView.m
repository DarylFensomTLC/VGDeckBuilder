//
//  FloatingPickerView.m
//  Deckbuilder
//
//  Created by Daryl Fensom on 15/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

//
// FloatingPickerView.m
// AppearingPickerView
//
// Created by Daniel Vela on 2/22/11.
// Copyright 2011 veladan.org . All rights reserved.
//

#import "FloatingPickerView.h"

@implementation FloatingPickerView
@synthesize pickerView;
@synthesize selectRowRow;
@synthesize selectRowComponent;
@synthesize selectRowAnimated;

#pragma mark -
#pragma mark initialization
-(id)initWithController:(UIViewController*)control
           withDelegate:(id) dele
         withDataSource:(id) data
          withDelegate2:(id) dele2 {
    controller = control;
    delegate = dele;
    dataSource = data;
    delegate2 = dele2;
    return self;
}

- (void)showPicker {
    aac = [[UIActionSheet alloc] initWithTitle:@""
                                      delegate:self
                             cancelButtonTitle:nil
                        destructiveButtonTitle:nil
                             otherButtonTitles:nil];
    aac.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    pickerView = [[UIPickerView alloc] initWithFrame:
                  CGRectMake(0.0, 44, 0.0, 0.0)];
    pickerView.delegate = delegate;
    pickerView.dataSource = dataSource;
    pickerView.userInteractionEnabled = YES;
    pickerView.showsSelectionIndicator = YES;
    [aac addSubview:pickerView];
    UISegmentedControl* doneButton = [[UISegmentedControl alloc] initWithItems:
                                      [NSArray arrayWithObject:@"OK"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260,7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blueColor];
    [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventValueChanged];
    [aac addSubview:doneButton];
    [aac showInView:controller.view];
    [UIView beginAnimations:nil context:nil];
    [aac setBounds:CGRectMake(0, 0, 320, 496)];
    [UIView commitAnimations];
    
}

-(void)donePressed {
    [aac dismissWithClickedButtonIndex:0 animated:YES];
    [aac removeFromSuperview];
    
    [delegate2 donePressed];
}

- (void)selectRow:(NSInteger)row
      inComponent:(NSInteger)component
         animated:(BOOL)animated {
    // If you call selectRow from UIPickerView while calling a delegate method, the
    // data will be not displayed.
    // This cheap trick allows to select a row animated.
    self.selectRowRow = row;
    self.selectRowComponent = component;
    self.selectRowAnimated = animated;
    [self performSelector:@selector(doSelectRow) withObject:nil afterDelay:0.5];
}

-(void)doSelectRow {
    [self.pickerView selectRow:self.selectRowRow
                   inComponent:self.selectRowComponent
                      animated:self.selectRowAnimated];
}


@end