//
//  AppDelegate.m
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/4/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "AppDelegate.h"
#import "GAITrackingMethod.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (ALLOW_GOOGLE_TRACKING) {
        //Google Analytics
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 20;
        
        // Optional: set Logger to VERBOSE for debug information.
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelInfo];
        
        // Initialize tracker.
        [[GAI sharedInstance] trackerWithTrackingId:@"UA-58878956-4"];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Disable sleep mode
    application.idleTimerDisabled = YES;
    
    //Config for uipagecontroller
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = COLOR_UIPAGE_CONTROLLER_INDEX;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = MASTER_COLOR;
    
    //Call immediatly get list score from server when begin app
    //[self endTimerGetListScoreFromServer];
    
    //Call immediatly push last score to server
    [self endTimerPushLastScoreToServer];
    
    [self startTimerPushLastScoreToServer];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[self stopTimerGetListScoreFromServer];
    //[self stopTimerPushLastScoreToServer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self startTimerGetListScoreFromServer];
    [self startTimerPushLastScoreToServer];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[self stopTimerPushLastScoreToServer];
    //[self stopTimerGetListScoreFromServer];
}

#pragma mark - FUNCTIONS
- (void) startTimerGetListScoreFromServer {
    if (_timerGetListScoreFromServer) {
        [_timerGetListScoreFromServer invalidate];
        _timerGetListScoreFromServer = nil;
    }
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    _timerGetListScoreFromServer = [NSTimer scheduledTimerWithTimeInterval:timeGetListScoreFromServer target:self selector:@selector(endTimerGetListScoreFromServer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerGetListScoreFromServer forMode:NSRunLoopCommonModes];
}

- (void) startTimerPushLastScoreToServer {
    if (_timerPushLastScoreToServer) {
        [_timerPushLastScoreToServer invalidate];
        _timerPushLastScoreToServer = nil;
    }
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    _timerPushLastScoreToServer = [NSTimer scheduledTimerWithTimeInterval:timePushLastScoreToServer target:self selector:@selector(endTimerPushLastScoreToServer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerPushLastScoreToServer forMode:NSRunLoopCommonModes];
}

- (void) stopTimerGetListScoreFromServer {
    if (_timerGetListScoreFromServer) {
        [_timerGetListScoreFromServer invalidate];
        _timerGetListScoreFromServer = nil;
    }
}

- (void) stopTimerPushLastScoreToServer {
    if (_timerPushLastScoreToServer) {
        [_timerPushLastScoreToServer invalidate];
        _timerPushLastScoreToServer = nil;
    }
}

- (void) endTimerGetListScoreFromServer {
    [Common showNetworkActivityIndicator];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                                @"model_device":[Common deviceModel]
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_GET_LIST_SCORE));
    [manager POST:URL_SERVER_API(API_GET_LIST_SCORE) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //GoogleTrackingServiceBlock(operation, nil);
        [Common hideNetworkActivityIndicator];
        NSLog(@"Respone: %@", responseObject);
        
        //Save list score of device model to local
        NSMutableArray *arrListScoreFromServer = [[NSMutableArray alloc] init];
        NSArray *arrRespone = responseObject[@"data"][@"data"];
        if ([arrRespone count] > 0) {
            for (int i = 0; i < [arrRespone count]; i++) {
                [arrListScoreFromServer addObject:[arrRespone objectAtIndex:i][@"results"]];
            }
            [Common writeArrayToFileListScoreFromServer:arrListScoreFromServer];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //GoogleTrackingServiceBlock(operation, nil);
        [Common hideNetworkActivityIndicator];
    }];
}

- (void) endTimerPushLastScoreToServer {
    NSString *strLastScore = [Common getLastScoreLocal];
    NSString *strLastTotal = [Common getLastTotalTimeLocal];
    
    if (strLastScore.length > 0 && strLastTotal.length > 0 && [[Common getSavedLocalToServer] isEqualToString:@"false"]) {
        [Common showNetworkActivityIndicator];
        AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
        NSMutableDictionary *request_param = [@{
                                                @"name_device" : [[UIDevice currentDevice] name],
                                                @"model_device" : [Common deviceModel],
                                                @"country_device" : [Common getCountryName],
                                                @"version_system_device" : [NSString stringWithFormat:@"%.1f", [[[UIDevice currentDevice] systemVersion] floatValue]],
                                                @"score" : strLastScore,
                                                @"time_checking" : strLastTotal,
                                                @"created_date" : [Common convertDateTimeToString:[NSDate date]],
                                                } mutableCopy];
        NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_ADD_RESULT));
        [manager POST:URL_SERVER_API(API_ADD_RESULT) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            GoogleTrackingBatteryPointBlock(request_param, nil);
            
            [Common hideNetworkActivityIndicator];
            NSLog(@"Respone: %@", responseObject);
            if ([responseObject[@"data"][@"status"] integerValue] == 1) {
                [Common setSavedLocalToServer:@"true"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            GoogleTrackingBatteryPointBlock(request_param, nil);
            [Common hideNetworkActivityIndicator];
        }];
    }
}

#pragma mark - REDIRECT
- (void) setRootViewHomeWithCompletion:(dispatch_block_t)block {
    UIStoryboard *storyboard = [self.window.rootViewController storyboard];
    if (!storyboard) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    }
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ROOT_HOME"];
    
    if (![self.window.rootViewController isEqual:viewController]) {
        self.window.rootViewController = viewController;
        if (block) {
            block();
        }
    }
}

- (void) setRootViewIntroduceWithCompletion:(dispatch_block_t)block {
    UIStoryboard *storyboard = [self.window.rootViewController storyboard];
    if (!storyboard) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    }
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ROOT_INTRODUCE"];
    
    if (![self.window.rootViewController isEqual:viewController]) {
        self.window.rootViewController = viewController;
        if (block) {
            block();
        }
    }
}

@end
