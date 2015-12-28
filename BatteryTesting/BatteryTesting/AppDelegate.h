//
//  AppDelegate.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/4/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "Common.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSTimer *timerGetListScoreFromServer;
@property (nonatomic) NSTimer *timerPushLastScoreToServer;

- (void) setRootViewHomeWithCompletion:(dispatch_block_t)block;
- (void) setRootViewIntroduceWithCompletion:(dispatch_block_t)block;


@end

