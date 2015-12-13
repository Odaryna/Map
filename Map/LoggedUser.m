//
//  LoggedUser.m
//  Map
//
//  Created by Admin on 12/8/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "LoggedUser.h"

@interface LoggedUser ()

@property (nonatomic, strong) LoggedUser *loggedUser;

@end

@implementation LoggedUser

#pragma mark - Singleton
+ (instancetype)sharedAccount
{
    static LoggedUser *sharedAccount = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedAccount = [[LoggedUser alloc] initPrivate];
    });
    
    return sharedAccount;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        //Add observer to listen when to performe logout
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(logout)
                   name:@"LogoutFromMapNotification"
                 object:nil];
    }
    return self;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Error" reason:@"Can't create instanse of this class. To login use method:loginUserWithInfo" userInfo:nil];
    return nil;
}

#pragma mark - Login
+ (LoggedUser *)loginUserWithInfo:(NSDictionary *)userInfo
{
    if (userInfo)
    {
        [self parseUser:userInfo];
        LoggedUser *sharedAccount = [LoggedUser sharedAccount];
        sharedAccount.loggedUser = sharedAccount;
    }
    else return nil;
    
    return [LoggedUser sharedAccount];
}

+ (void)parseUser:(NSDictionary *)userInfo
{
    LoggedUser *sharedAccount = [self sharedAccount];
    
    if (userInfo)
    {
        sharedAccount.name = ![[userInfo valueForKey:@"name"] isKindOfClass:[NSNull class]] ? [userInfo valueForKey:@"name"] : nil;
        sharedAccount.userID = ![[userInfo valueForKey:@"userId"] isKindOfClass:[NSNull class]] ? [userInfo valueForKey:@"userId"] : nil;
        sharedAccount.email = ![[userInfo valueForKey:@"email"] isKindOfClass:[NSNull class]] ? [userInfo valueForKey:@"email"] : nil;
    }
    NSLog(@"%@",sharedAccount.name);
    
}

+(LoggedUser *)currentLoggedUser
{
    if (![[LoggedUser sharedAccount] loggedUser])
    {
        return nil;
    }
    
    return [[LoggedUser sharedAccount] loggedUser];
}

#pragma mark - Logout
- (void)logout
{
    if ([[LoggedUser sharedAccount] loggedUser])
    {
        [[LoggedUser sharedAccount] setLoggedUser:nil];
    }
}

#pragma mark - NSObject override
- (NSString *)description
{
    return [NSString stringWithFormat:@"Logged user: %@ ", self.name];
}
@end

