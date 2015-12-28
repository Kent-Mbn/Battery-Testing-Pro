//
//  ProcessClass.m
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/8/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ProcessClass.h"

static ProcessClass *pClass = nil;

@implementation ProcessClass

#pragma mark INIT
- (instancetype) init {
    self = [super init];
    if (self) {
        _numberFinished = 0;
        //_timeFinished = 0;
        if ([Common validAllConditionsBeforeStart]) {
            _isStatusNow = kStopAndCanStart;
        } else {
            _isStatusNow = kStopAndCannotStart;
        }
    }
    return self;
}

+ (instancetype) sharedProcessObject {
    @synchronized (self) {
        if (pClass == nil) {
            pClass = [[ProcessClass alloc] init];
        }
    }
    return pClass;
}

#pragma mark FUNCTION

unsigned long TIME_BLOCK(NSString *key, void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS)
    {return -1.0;}
    
    uint64_t start = mach_absolute_time();
    block();
    uint64_t end = mach_absolute_time();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    unsigned long cost = (unsigned long)nanos;
    return cost;
}

- (void) startRunningProcess {
    _isStatusNow = kStatusPreparing;
    //_timeFinished = 0;
    _numberFinished = 0;
    
    //Set brightness to max
    [[UIScreen mainScreen] setBrightness:1.0];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self executeProcess1];
//    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self executeProcess2];
    });
}

- (void) stopRunningProcess {
    if ([Common validAllConditionsBeforeStart]) {
        _isStatusNow = kStopAndCanStart;
    } else {
        _isStatusNow = kStopAndCannotStart;
    }
}

#pragma mark ALGORITHM
- (void) executeProcess1 {
    while (true) {
        if (_isStatusNow == kStopAndCannotStart || _isStatusNow == kStopAndCanStart) {
            return;
        } else {
            //unsigned long t = TIME_BLOCK(@"unknow", ^{
                [self functionCalculateLinearDiophantine:numberA andNumB:numberB andNumC:numberC];
            //});
            
            if (_isStatusNow == kStatusStarting) {
                //_timeFinished += t;
                _numberFinished++;
            }
            //NSLog(@"Process 1: %lu", t);
            //NSLog(@"Process 1 finished: %lu", _timeFinished);
        }
    }
}

- (void) executeProcess2 {
    while (true) {
        if (_isStatusNow == kStopAndCannotStart || _isStatusNow == kStopAndCanStart) {
            return;
        } else {
            //unsigned long t = TIME_BLOCK(@"unknow", ^{
                [self functionReadFile];
            //});
            if (_isStatusNow == kStatusStarting) {
                //_timeFinished += t;
                _numberFinished++;
            }
            //NSLog(@"Process 2: %lu", t);
            //NSLog(@"Process 2 finished: %lu", _timeFinished);
        }
    }
}

- (void)functionCalculateLinearDiophantine:(int) numA andNumB:(int)numB andNumC:(int)numC {
        @autoreleasepool {
            //
            int x = 0;
            int y = 0;
            
            int a = numA;
            int b = numB;
            
            int q = 0;
            int r = 0;
            
            int xa = 1;
            int ya = 0;
            int xb = 0;
            int yb = 1;
            
            int xr = 0;
            int yr = 0;
            
            while (b != 0) {
                q = a / b;
                r = a % b;
                a = b;
                b = r;
                xr = xa - q * xb;
                yr = ya - q * yb;
                xa = xb;
                ya = yb;
                xb = xr;
                yb = yr;
            }
            
            x = (xa * numC) / (xa * numA + ya * numB);
            y = (ya * numC) / (xa * numA + ya * numB);
            
            
        }
}

- (void) functionReadFile {
        @autoreleasepool {
            //Read data from file
            NSMutableArray *arrDataLocal = [Common readFileLocalForDecodeEncode];
            
            //For loop to encode or decode
            if ([arrDataLocal count] > 0) {
                for (int i = 0; i < [arrDataLocal count]; i++) {
                    NSMutableDictionary *dicObj = [arrDataLocal objectAtIndex:i];
                    if ([dicObj[@"status"] isEqualToString:@"encoded"]) {
                        //decode
                        dicObj[@"strEncodeDecode"] = [Common decodeBase64:dicObj[@"strEncodeDecode"]];
                        dicObj[@"status"] = @"decoded";
                    } else {
                        //encode
                        dicObj[@"strEncodeDecode"] = [Common encodeBase64:dicObj[@"strEncodeDecode"]];
                        dicObj[@"status"] = @"encoded";
                    }
                }
            }
            
            //Rewrite to file
            [Common writeArrayToFileLocalForDecodeEncode:arrDataLocal];
        }
}



@end
