//
//  ProcessClass.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/8/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface ProcessClass : NSObject {
    
}

//BOOL for stop or not
@property(nonatomic) __block int isStatusNow;

//Number of finised process
@property(nonatomic) __block unsigned long long numberFinished;

//Time in nano second from begin and finish
//@property(nonatomic) __block unsigned long timeFinished;

//Begin start or stop executing process
- (void) startRunningProcess;
- (void) stopRunningProcess;

//Share instance object
+ (instancetype) sharedProcessObject;

@end
