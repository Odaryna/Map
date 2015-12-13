//
//  LoggedUser.h
//  Map
//
//  Created by Admin on 12/8/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggedUser : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;

+ (LoggedUser *)loginUserWithInfo:(NSDictionary *)userInfo;
+ (LoggedUser *)currentLoggedUser;

@end
