//
//  VGSelectSetViewController.m
//  Deckbuilder
//
//  Created by Daryl Fensom on 15/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGSelectSetViewController.h"



@implementation VGSelectSetViewController


@synthesize cardSets = mCardSets;
@synthesize pickerView = mPickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
         self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_linen.png"]];
        self.btnSelect.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.btnCancel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//*********************PICKER VIEW DELEGATE METHODS***************************//

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [mCardSets count];
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [mCardSets objectAtIndex:row];
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    NSLog(@"Chosen item: %@", [mCardSets objectAtIndex:row]);
}




- (void)viewDidUnload {
    [self setBtnSelect:nil];
    [self setBtnCancel:nil];
    [self setPickerView:nil];
    [self setBtnSelect:nil];
    [self setBtnCancel:nil];
    [super viewDidUnload];
}
- (IBAction)btnSelectPressed:(id)sender {
    int selected = [self.pickerView selectedRowInComponent:0];
    [self.delegate passBack:self :selected];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnCancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
