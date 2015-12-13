//
//  CDPins.m
//  Map
//
//  Created by Admin on 12/8/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "CDPins.h"
#import "Pin.h"

#import "AppDelegate.h"

@implementation CDPins

+ (void)addPinIntoCoreData:(PinsDescription *)userPin by:(NSString *)userId
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    NSError *error;
    
    Pin *ob = [NSEntityDescription insertNewObjectForEntityForName:@"Pin" inManagedObjectContext:context];
    
    [ob setTitle:userPin.title];
    [ob setLatitude:[NSNumber numberWithFloat: userPin.coordinate.latitude]];
    [ob setLongitude:[NSNumber numberWithFloat: userPin.coordinate.longitude]];
    [ob setUserId:userId];
    [ob setSubtitle:userPin.subtitle];
    [ob setDescript:userPin.descriptionOfMood];
    
    [context save:&error];
    
}

@end
