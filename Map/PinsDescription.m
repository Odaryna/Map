//
//  PinsDescription.m
//  Map
//
//  Created by Admin on 12/5/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "PinsDescription.h"


@implementation PinsDescription

-(instancetype)initPinFromCD:(Pin *)pin
{
    self = [super init];
    if (self)
    {
        self.title = pin.title;
        self.coordinate = CLLocationCoordinate2DMake([pin.latitude doubleValue], [pin.longitude doubleValue]);
        self.subtitle = pin.subtitle;
        self.descriptionOfMood = pin.descript;
        self.contextId = [pin objectID];
    }
    
    return self;
}

@end
