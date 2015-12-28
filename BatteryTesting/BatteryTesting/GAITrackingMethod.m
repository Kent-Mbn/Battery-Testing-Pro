//
//  GAITrackingMethod.m
//  Roots
//
//  Created by Harry Tran on 3/13/15.
//  Copyright (c) 2015 HarryTran. All rights reserved.
//

#import "GAITrackingMethod.h"
#import <AFNetworking/AFNetworking.h>


#define kGAITrackingTypeCategoryError           @"INTERNAL_ERROR"
#define kGAITrackingTypeCategoryNetworkError    @"EXTERNAL_ERROR"

BOOL GoogleTrackingBlock(id viewController, NSString *screenName)
{
    if (ALLOW_GOOGLE_TRACKING) {
        NSLog(@"ALLOW_GOOGLE_TRACKING in SCREEN --> %@",screenName);
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:screenName];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        return YES;
    }
    return NO;
};

BOOL GoogleTrackingBatteryPointBlock(NSDictionary *paramRequest, NSDictionary *sender)
{
    if (ALLOW_GOOGLE_TRACKING)
    {
        if (paramRequest)
        {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

            NSString *modelName = paramRequest[@"model_device"] ? paramRequest[@"model_device"] : @"Unknow";
            NSString *countryName = paramRequest[@"version_system_device"] ? paramRequest[@"version_system_device"] : @"Unknow";
            NSNumber *value = paramRequest[@"score"]  ?  @([paramRequest[@"score"] integerValue]) : @(0);
            NSLog(@"paramRequest --> %@",[paramRequest XMLString]);
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:modelName
                                                                  action:countryName
                                                                   label:[paramRequest XMLString]
                                                                   value:value] build]];
        }
        
        return YES;
    }
    return NO;
};



