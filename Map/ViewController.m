//
//  ViewController.m
//  Map
//
//  Created by Admin on 12/5/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import "AddMoodViewController.h"
#import "ReviewMoodViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoggedUser.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"



@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>

- (IBAction)setPinOnLocation:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationPinButton;
- (IBAction)showMyLocation:(UIBarButtonItem *)sender;
- (IBAction)movePin:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *movePinBtn;

@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,assign) CLLocationCoordinate2D currentCoordinate;

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) NSUInteger userID;

@property (nonatomic, strong) NSMutableArray *pins;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;

@end

@implementation ViewController

@synthesize fetchedResultsController = _fetchedResultsController;
static bool isMoving = NO;

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Pin"
                                   inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %i", self.userID];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"subtitle" ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:appDelegate.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Pin"];
    
    self.fetchedResultsController = theFetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self renewMap];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    PinsDescription *pin = [[PinsDescription alloc] initPinFromCD:(Pin*)anObject];
   
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [self.pins addObject:pin];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.pins removeObjectAtIndex:indexPath.row];
            break;
            
        case NSFetchedResultsChangeUpdate:
            self.pins[indexPath.row] = pin;
            break;
            
        case NSFetchedResultsChangeMove:
            break;
    }
}

-(void)renewMap
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (NSMutableArray* obj in self.pins)
    {
        [self.mapView addAnnotation:(PinsDescription *)obj];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startLocationManager];
    [self.mapView setShowsUserLocation:true];
    [self.mapView setDelegate:self];
    
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        [self fetchUserInfo];
        self.loginButton.title = @"Log out";
        
    }
    
    [self.movePinBtn setEnabled:NO];
    [self.movePinBtn setTintColor:[UIColor clearColor]];
}



- (void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization]; // Add This Line
    
    
}

-(void)handleLongPressGesture:(UIGestureRecognizer *)sender
{
    LoggedUser *user = [LoggedUser currentLoggedUser];
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (user)
        {
            CGPoint point = [sender locationInView:self.mapView];
            self.currentCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
            if (!isMoving)
            {
                [self performSegueWithIdentifier:@"addMood" sender:self];
            }
            else
            {
                AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                NSManagedObjectContext* context = appDelegate.managedObjectContext;
                
                Pin *a = (Pin *)[context objectWithID:self.currentPin.contextId];
                
                [a setLatitude:[NSNumber numberWithFloat:self.currentCoordinate.latitude]];
                [a setLongitude:[NSNumber numberWithFloat:self.currentCoordinate.longitude]];
                [context save:nil];
                isMoving = NO;
                [self.movePinBtn setEnabled:NO];
                [self.movePinBtn setTintColor:[UIColor clearColor]];
            }
        }
        else
        {
            [self showAlert];
        }
    }
}

-(void)showAlert
{
    UIAlertController * alertController=   [UIAlertController
                                            alertControllerWithTitle:@"You are not logged in"
                                            message:@"For creating mood you have to be logged in via Facebook."
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString* myIdentifier = @"myIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
    
    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        PinsDescription *pin = (PinsDescription *)pinView.annotation;
        
        if ([pin.title isEqualToString:@"😍"])
        {
            pinView.pinTintColor = [UIColor redColor];
        }
        else if ([pin.title isEqualToString:@"😭"])
        {
            pinView.pinTintColor = [UIColor blueColor];
        }
        else
        {
            pinView.pinTintColor = [UIColor greenColor];
        }
        
        pinView.animatesDrop = YES;
    }
    return pinView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
    {
        return ;
    }
    
    self.currentPin = (PinsDescription *)view.annotation;
    [self performSegueWithIdentifier:@"reviewMood" sender:view];
    isMoving = NO;
    [self.movePinBtn setEnabled:NO];
    [self.movePinBtn setTintColor:[UIColor clearColor]];
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
    {
        return ;
    }
    
    self.currentPin = (PinsDescription *)view.annotation;
    [self.movePinBtn setEnabled:YES];
    [self.movePinBtn setTintColor:[UIColor whiteColor]];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
    {
        return;
    }
    
    [self.movePinBtn setEnabled:NO];
    [self.movePinBtn setTintColor:[UIColor clearColor]];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqualToString: @"addMood"])
    {
        AddMoodViewController *controller = (AddMoodViewController *)segue.destinationViewController;
        [controller setCoords:self.currentCoordinate];
    }
    else if ([segue.identifier  isEqualToString: @"reviewMood"])
        {
            ReviewMoodViewController *controller = (ReviewMoodViewController *)segue.destinationViewController;
            [controller setPin:self.currentPin];
        }
}


/*aipnpgr_bowersescu_1449697816@tfbnw.net*/
-(IBAction)facebookLogin:(UIBarButtonItem *)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if (![sender.title isEqualToString:@"Log out"])
    {
        if (![FBSDKAccessToken currentAccessToken])
        {
            [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
             {
                 if (error)
                 {
                     NSLog(@"Login process error");
                 }
                 else if (result.isCancelled)
                 {
                     NSLog(@"User cancelled login");
                 }
                 else
                 {
                     NSLog(@"Login Success");
                     
                     if ([result.grantedPermissions containsObject:@"email"])
                     {
                         NSLog(@"result is:%@",result);
                         [self fetchUserInfo];
                     }
                     else
                     {
                         NSLog(@"Facebook email permission error");
                         
                     }
                 }
             }];
        }
        
        sender.title = @"Log out";
    }
    else
    {
        [login logOut];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutFromMapNotification" object:self];
        sender.title = @"Login";
    }
}


-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"results:%@",result);
                 
                 NSString *email = [result objectForKey:@"email"];
                 NSNumber *userId = [result objectForKey:@"id"];
                 
                 NSDictionary * info = @{
                                         @"email":email,
                                         @"userId":[result objectForKey:@"id"],
                                         @"name":[result objectForKey:@"name"]
                                         };
                 
                 if (email.length >0 )
                 {
                     LoggedUser *currentUser = [LoggedUser loginUserWithInfo:info];
                     if (currentUser)
                     {
                         self.userID = [userId integerValue];
                         
                         if (self.pins)
                         {
                             [self.pins removeAllObjects];
                         }
                         else
                         {
                             self.pins = [NSMutableArray new];
                         }
                         
                         [NSFetchedResultsController deleteCacheWithName:@"Pin"];
                         self.fetchedResultsController = nil;
                         
                         
                         NSMutableArray *allPins = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]];
                         
                         for (Pin *obj in allPins)
                         {
                             PinsDescription *pin = [[PinsDescription alloc] initPinFromCD:obj];
                             [self.pins addObject:pin];
                         }
                         
                         [self renewMap];
                         
                     }
                 }
                 else
                 {
                     NSLog(@"Facebook email is not verified");
                 }
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
    }
}

- (IBAction)setPinOnLocation:(UIBarButtonItem *)sender
{
    LoggedUser *user = [LoggedUser currentLoggedUser];
    
    if (user)
    {
        MKUserLocation *userLocation = self.mapView.userLocation;
        self.currentCoordinate = userLocation.coordinate;
        [self performSegueWithIdentifier:@"addMood" sender:self];
    }
    else
    {
        [self showAlert];
    }
}



- (IBAction)showMyLocation:(UIBarButtonItem *)sender
{
    MKUserLocation *userLocation = self.mapView.userLocation;
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.4f, 0.4f)) animated:true];
}

- (IBAction)movePin:(UIBarButtonItem *)sender
{
    UIAlertController * alertController=   [UIAlertController
                                            alertControllerWithTitle:@"Move mood to another place"
                                            message:@"For moving pin you have to make long press on the place where you want to be this mood."
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                               {
                                   isMoving = YES;
                               }];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                               {
                                   [self.movePinBtn setEnabled:NO];
                                   [self.movePinBtn setTintColor:[UIColor clearColor]];
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}
@end
