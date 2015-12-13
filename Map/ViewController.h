//
//  ViewController.h
//  Map
//
//  Created by Admin on 12/5/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PinsDescription.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) PinsDescription *currentPin;

@end

