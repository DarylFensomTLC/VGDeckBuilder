//
//  FloatingPickerView.h
//  Deckbuilder
//
//  Created by Daryl Fensom on 15/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FloatingPickerViewDelegate
-(void)donePressed;
@end

@interface FloatingPickerView : NSObject
<UIActionSheetDelegate>{
    id delegate;
    id dataSource;
    id delegate2;
    UIViewController* controller;
    UIActionSheet* aac;
    UIPickerView* pickerView;
    NSInteger selectRowRow;
    NSInteger selectRowComponent;
    BOOL selectRowAnimated;
}
@property (nonatomic, retain) UIPickerView* pickerView;
@property NSInteger selectRowRow;
@property NSInteger selectRowComponent;
@property BOOL selectRowAnimated;
-(id)initWithController:(UIViewController*)control
           withDelegate:(id) dele
         withDataSource:(id) data
          withDelegate2:(id) dele2;
- (void)showPicker;
- (void)donePressed;
- (void)selectRow:(NSInteger)row
      inComponent:(NSInteger)component
         animated:(BOOL)animated;
- (void)doSelectRow;
@end

