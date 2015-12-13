//
//  AddMoodViewController.h
//  Map
//
//  Created by Admin on 12/6/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PinsDescription.h"

@interface AddMoodViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *pickerMoodView;
@property (weak, nonatomic) IBOutlet UITextField *placeType;
@property (weak, nonatomic) IBOutlet UITextView *descriptionOfMood;
@property (strong, nonatomic) PinsDescription *pin;

- (IBAction)confirm;
- (void)setCoords:(CLLocationCoordinate2D)coords;
- (void)showOldData:(PinsDescription *)currentPin;

@end
