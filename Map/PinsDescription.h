//
//  PinsDescription.h
//  Map
//
//  Created by Admin on 12/5/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Pin.h"


@interface PinsDescription : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *descriptionOfMood;
@property (nonatomic, strong) NSManagedObjectID *contextId;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(instancetype)initPinFromCD:(Pin *)pin;

@end


