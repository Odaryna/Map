//
//  ReviewMoodViewController.h
//  Map
//
//  Created by Admin on 12/6/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinsDescription.h"

@interface ReviewMoodViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mood;
@property (weak, nonatomic) IBOutlet UITextField *placeType;
@property (weak, nonatomic) IBOutlet UITextView *descriptionOfMood;
- (IBAction)editMood:(UIButton *)sender;
- (IBAction)deleteMood:(UIButton *)sender;

-(void)setPin:(PinsDescription *)pin;

@end
