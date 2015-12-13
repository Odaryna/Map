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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    /*NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pin" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objectID = %@)",self.currentPin.contextId];
    [fetchRequest setPredicate:predicate];
    */
    
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
