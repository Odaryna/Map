//
//  ReviewMoodViewController.m
//  Map
//
//  Created by Admin on 12/6/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ReviewMoodViewController.h"
#import "AppDelegate.h"
#import "AddMoodViewController.h"

@interface ReviewMoodViewController ()

@property (nonatomic, strong) PinsDescription *currentPin;

@end

@implementation ReviewMoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.currentPin)
    {
        self.mood.text = self.currentPin.title;
        self.placeType.text = self.currentPin.subtitle;
        self.descriptionOfMood.text = self.currentPin.descriptionOfMood;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editMood:(UIButton *)sender
{
    [self deletePin];
    [self performSegueWithIdentifier:@"editPin" sender:self];
}


- (IBAction)deleteMood:(UIButton *)sender
{
    [self deletePin];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deletePin
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    
    Pin *a = (Pin *)[context objectWithID:self.currentPin.contextId];
    [context deleteObject:a];
    [context save:nil];
}

- (void)setPin:(PinsDescription *)pin
{
    self.currentPin = pin;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editPin"])
    {
        AddMoodViewController *controller = (AddMoodViewController *)segue.destinationViewController;
        [controller showOldData:self.currentPin];
    }
}

@end
