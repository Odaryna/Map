//
//  CDPins.h
//  Map
//
//  Created by Admin on 12/8/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinsDescription.h"

@interface CDPins : NSObject

+ (void)addPinIntoCoreData:(PinsDescription *)userPin by:(NSUInteger)userId;

@end
