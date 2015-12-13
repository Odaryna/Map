//
//  AddMoodViewController.m
//  Map
//
//  Created by Admin on 12/6/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "AddMoodViewController.h"
#import "ViewController.h"
#import "CDPins.h"
#import "LoggedUser.h"

@interface AddMoodViewController () <UIScrollViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSArray *arrayWithMoods;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation AddMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerMoodView.delegate = self;
    self.descriptionOfMood.text = @"";
    [self.placeType setDelegate:self];
    [self.descriptionOfMood setDelegate:self];
    self.arrayWithMoods = [[NSArray alloc] initWithObjects:@"😱",@"😡",@"😍",@"😭",@"😊",@"😨",@"😤", nil];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.pickerMoodView selectRow:3 inComponent:0 animated:YES];
    if (self.pin.title)
    {
        self.placeType.text = self.pin.subtitle;
        self.descriptionOfMood.text = self.pin.descriptionOfMood;
        
        for (NSInteger index = 0; index < [self.arrayWithMoods count]; index++)
        {
            NSString *smile = [self.arrayWithMoods objectAtIndex:index];
            if ([smile isEqualToString:self.pin.title])
            {
                [self.pickerMoodView selectRow:index inComponent:0 animated:YES];
                break;
            }
        }
    }
}
\
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrayWithMoods count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.arrayWithMoods[row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirm
{
    if (self.pin)
    {
        self.pin.title = [self.arrayWithMoods objectAtIndex:[self.pickerMoodView selectedRowInComponent:0]];
        self.pin.subtitle = self.placeType.text;
        self.pin.descriptionOfMood = self.descriptionOfMood.text;
    }
    
    LoggedUser* loggedUser = [LoggedUser currentLoggedUser];
    
    if (loggedUser)
    {
        [CDPins addPinIntoCoreData:self.pin by:loggedUser.userID];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)setCoords:(CLLocationCoordinate2D)coords
{
    self.pin = [[PinsDescription alloc] init];
    self.pin.coordinate = coords;
}

- (void)showOldData:(PinsDescription *)currentPin
{
    self.pin = currentPin;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.placeType resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self.descriptionOfMood resignFirstResponder];
        return NO;
    }
    
    return YES;
}


@end
