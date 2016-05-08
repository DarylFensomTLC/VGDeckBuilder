//
//  VGSelectSetViewController.h
//  Deckbuilder
//
//  Created by Daryl Fensom on 15/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGSelectSetViewController;

@protocol VGSelectSetDelegate <NSObject>
-(void) passBack: set:(int)inSet;
@end

@interface VGSelectSetViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSMutableArray * cardSets;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) id<VGSelectSetDelegate> delegate;
- (IBAction)btnSelectPressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *horse;

@end
