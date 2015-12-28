//
//  Common.m
//  ParentalControlChildren
//
//  Created by CHAU HUYNH on 5/8/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "Common.h"

@implementation Common

+(void)roundView:(UIView *)uView andRadius:(float) radius andBorderWidth:(float)borderWidth andColorBorder:(UIColor *) bColor {
    uView.layer.cornerRadius = radius;
    uView.clipsToBounds = YES;
    uView.layer.borderWidth = borderWidth;
    uView.layer.borderColor = bColor.CGColor;
    uView.contentMode = UIViewContentModeScaleAspectFill;
}

+ (void) showAlertView:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle arrayTitleOtherButtons:(NSArray *)arrayTitleOtherButtons tag:(int)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    alert.tag = tag;
    
    if([arrayTitleOtherButtons count] > 0) {
        for (int i = 0; i < [arrayTitleOtherButtons count]; i++) {
            [alert addButtonWithTitle:arrayTitleOtherButtons[i]];
        }
    }
    
    [alert show];
}

+ (void) circleImageView:(UIView *) imgV {
    imgV.layer.cornerRadius = imgV.frame.size.width / 2;
    imgV.clipsToBounds = YES;
    imgV.contentMode = UIViewContentModeScaleAspectFill;
}

+ (void) updateDeviceToken:(NSString *) newDeviceToken {
    [[NSUserDefaults standardUserDefaults] setObject:newDeviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getDeviceToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
}

+ (BOOL) isValidEmail:(NSString *)checkString
{
    checkString = [checkString lowercaseString];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

+ (void) showNetworkActivityIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void) hideNetworkActivityIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

+ (CGFloat) heightScreen {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat) widthScreen {
    return [[UIScreen mainScreen] bounds].size.width;
}

/*
+ (AFHTTPRequestOperationManager *)AFHTTPRequestOperationManagerReturn {
    NSLog(@".......Call WS........");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    return manager;
}

+ (BOOL) validateRespone:(id) respone {
    NSArray *arrRespone = (NSArray *)respone;
    NSDictionary *dicRespone = (NSDictionary *)[arrRespone objectAtIndex:0];
    if (dicRespone) {
        if ([dicRespone[@"resultcode"] intValue] == CODE_RESPONE_SUCCESS) {
            return YES;
        }
    }
    return NO;
}
 */

+ (NSArray *) arrayForEncodeDecode {
    return @[@"jahksjkjskdfsdfsdfssdfsdfdfjsks", @"siuiusisdfsdfsdsdfsdfsdfsddoijijis", @"iwuiooicusdfsdsdfsdfsdfsdfnosiuos", @"kasodiusidosdfsdfsdfdasdfsdfdkxlkcslw"];
}

+ (void) initDataFileLocalForEncodeDecode {
    NSMutableArray *arrInit = [self readFileLocalForDecodeEncode];
    if ([arrInit count] == 0) {
        arrInit = [[NSMutableArray alloc] init];
        NSArray *arrInitData = [self arrayForEncodeDecode];
        if ([arrInitData count] > 0) {
            for (int i = 0; i < [arrInitData count]; i++) {
                NSString *strEncode = [arrInitData objectAtIndex:i];
                NSDictionary *dicData = [[NSDictionary alloc] initWithObjects:@[strEncode,@"encoded"] forKeys:@[@"strEncodeDecode", @"status"]];
                [arrInit addObject:dicData];
            }
        }
        //Write to file
        [self writeArrayToFileLocalForDecodeEncode:arrInit];
    }
}

+ (NSString *) pathOfFileLocalForDecodeEncode {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [filePaths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:NAME_LOCAL_FILE_FOR_ENCODE_DECODE];
    return path;
}

+ (void) writeArrayToFileLocalForDecodeEncode:(NSMutableArray *) arrToWrite {
    [arrToWrite writeToFile:[self pathOfFileLocalForDecodeEncode] atomically:YES];
}

+ (NSMutableArray *) readFileLocalForDecodeEncode {
    NSMutableArray *arrReturn = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathOfFileLocalForDecodeEncode]]) {
        arrReturn = [[NSMutableArray arrayWithContentsOfFile:[self pathOfFileLocalForDecodeEncode]] mutableCopy];
    }
    return arrReturn;
}

+ (void) writeObjToFileForDecodeEncode:(NSDictionary *) dicObj {
    //Get data
    NSMutableArray *arrInit = [self readFileLocalForDecodeEncode];
    if (arrInit != nil) {
        [arrInit addObject:dicObj];
    } else {
        arrInit = [[NSMutableArray alloc] init];
        [arrInit addObject:dicObj];
    }
    
    //Write to file
    [self writeArrayToFileLocalForDecodeEncode:arrInit];
}

+ (void) removeFileLocalForDecodeEncode {
    NSString *filePath = [self pathOfFileLocalForDecodeEncode];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

#pragma mark - SECTION FOR GET LIST SCORE OF SERVER
+ (NSString *) pathOfFileListScoreFromServer {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [filePaths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:NAME_LOCA_FILE_LIST_SCORE];
    return path;
}

+ (NSMutableArray *) readFileListScoreFromServer {
    NSMutableArray *arrReturn = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathOfFileListScoreFromServer]]) {
        arrReturn = [[NSMutableArray arrayWithContentsOfFile:[self pathOfFileListScoreFromServer]] mutableCopy];
    }
    return arrReturn;
}

+ (void) writeArrayToFileListScoreFromServer:(NSMutableArray *) arrToWrite {
    [arrToWrite writeToFile:[self pathOfFileListScoreFromServer] atomically:YES];
}

+ (void) removeFileListScoreFromServer {
    NSString *filePath = [self pathOfFileListScoreFromServer];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

+ (NSString *) decodeBase64:(NSString *) strDecode {
    NSData *plainData = [strDecode dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}

+ (NSString *) encodeBase64:(NSString *) strEncode {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:strEncode options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

+ (BOOL) isValidString:(NSString *) strCheck {
    if (strCheck.length > 0 && ![strCheck isEqual:[NSNull null]] && ![strCheck isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

+ (int) returnIntBattery:(float)floatBattery;
{
    floatBattery = floatBattery * 100;
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        [numberFormatter setMaximumFractionDigits:1];
    }
    NSNumber *levelObj = [NSNumber numberWithFloat:floatBattery];
    return [levelObj intValue];
}

+ (float) getBatteryLevel {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    return [UIDevice currentDevice].batteryLevel;
}

+ (BOOL) checkingAirPlaneMode {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, "8.8.8.8");
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    if (!success) {
        return YES;
    }
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL isNetworkReachable = (isReachable && ! needsConnection);
    
    if (!isNetworkReachable) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *) returnTimeCounter:(unsigned long long) numMiliSeconds {
    unsigned long long numMinutes = 0;
    unsigned long long numSeconds = 0;
    
    NSString *strMinute = @"00";
    NSString *strSecond = @"00";
    
    numMinutes = numMiliSeconds / 60000;
    numSeconds = (numMiliSeconds - (numMinutes * 60000)) / 1000;
    
    if (numMinutes == 0) {
        strMinute = @"00";
    } else if (numMinutes > 0 && numMinutes < 10) {
        strMinute = [NSString stringWithFormat:@"0%llu", numMinutes];
    } else {
        strMinute = [NSString stringWithFormat:@"%llu", numMinutes];
    }
    
    if (numSeconds == 0) {
        strSecond = @"00";
    } else if (numSeconds > 0 && numSeconds < 10) {
        strSecond = [NSString stringWithFormat:@"0%llu", numSeconds];
    } else {
        strSecond = [NSString stringWithFormat:@"%llu", numSeconds];
    }
    
    return [NSString stringWithFormat:@"%@:%@", strMinute, strSecond];
    
}

+ (unsigned long long) convertFromString:(NSString *) strLlu {
    NSNumberFormatter *numFormater = [[NSNumberFormatter alloc] init];
    NSNumber *number = [numFormater numberFromString:strLlu];
    return [number unsignedLongLongValue];
}

+ (int) convertToIntFromString:(NSString *) strInt {
    NSNumberFormatter *numFormater = [[NSNumberFormatter alloc] init];
    NSNumber *number = [numFormater numberFromString:strInt];
    return [number intValue];
}

+ (void) circleView:(UIView *) viewInput {
    viewInput.layer.cornerRadius = viewInput.frame.size.width / 2;
    viewInput.clipsToBounds = YES;
    viewInput.layer.borderWidth = [self widthScreen] / widthExiplonCircle;
    viewInput.layer.borderColor = MASTER_COLOR_EXTRA.CGColor;
    viewInput.contentMode = UIViewContentModeScaleAspectFill;
}

+ (NSString *) pathOfFileLocalSavingResult {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [filePaths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:NAME_LOCAL_FILE_SAVE_RESULT_TESTING];
    return path;
}
+ (NSMutableArray *) readFileLocalSavingResult {
    NSMutableArray *arrReturn = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathOfFileLocalSavingResult]]) {
        arrReturn = [[NSMutableArray arrayWithContentsOfFile:[self pathOfFileLocalSavingResult]] mutableCopy];
    }
    return arrReturn;
}
+ (void) writeObjToFileSavingResult:(NSDictionary *) dicObj {
    NSMutableArray *arrInit = [self readFileLocalSavingResult];
    if (arrInit != nil) {
        [arrInit addObject:dicObj];
    } else {
        arrInit = [[NSMutableArray alloc] init];
        [arrInit addObject:dicObj];
    }
    
    //Write to file
    [self writeArrayToFileSavingResult:arrInit];
}

+ (void) writeArrayToFileSavingResult:(NSMutableArray *) arrToWrite {
    [arrToWrite writeToFile:[self pathOfFileLocalSavingResult] atomically:YES];
}

+ (void) removeFileLocalSavingResult {
    NSString *filePath = [self pathOfFileLocalSavingResult];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}


+ (NSString *) pathOfFileLocalSavingResultCare {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [filePaths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:NAME_LOCAL_FILE_SAVE_RESULT_TESTING_CARE];
    return path;
}
+ (NSMutableArray *) readFileLocalSavingResultCare {
    NSMutableArray *arrReturn = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathOfFileLocalSavingResultCare]]) {
        arrReturn = [[NSMutableArray arrayWithContentsOfFile:[self pathOfFileLocalSavingResultCare]] mutableCopy];
    }
    return arrReturn;
}
+ (void) writeObjToFileSavingResultCare:(NSDictionary *) dicObj {
    NSMutableArray *arrInit = [self readFileLocalSavingResultCare];
    if (arrInit != nil) {
        [arrInit addObject:dicObj];
    } else {
        arrInit = [[NSMutableArray alloc] init];
        [arrInit addObject:dicObj];
    }
    
    //Write to file
    [self writeArrayToFileSavingResultCare:arrInit];
}

+ (void) writeArrayToFileSavingResultCare:(NSMutableArray *) arrToWrite {
    [arrToWrite writeToFile:[self pathOfFileLocalSavingResultCare] atomically:YES];
}

+ (void) removeFileLocalSavingResultCare {
    NSString *filePath = [self pathOfFileLocalSavingResultCare];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}


+ (NSString *) returnStringFromInterval:(unsigned long long) numInterval {
    NSDate *lastDate = [[NSDate alloc] initWithTimeIntervalSince1970:numInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    return [dateFormatter stringFromDate:lastDate];
}

+ (NSDictionary *) dicLastResultLocal:(BOOL)isFastly {
    NSDictionary *dicReturn = nil;
    NSMutableArray *arrResults = [[NSMutableArray alloc] init];
    if (isFastly) {
        arrResults = [Common readFileLocalSavingResult];
    } else {
        arrResults = [Common readFileLocalSavingResultCare];
    }
    if ([arrResults count] > 0) {
        dicReturn = [arrResults lastObject];
    }
    return dicReturn;
}

+ (NSString *) getCountryName {
    NSLocale *countryLocale = [NSLocale currentLocale];
    NSString *countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
    return [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
}

+ (NSString*) deviceModel
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6s Plus",   //
                              @"iPhone8,2" :@"iPhone 6s",
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini"        // (2nd Generation iPad Mini - Cellular)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    return deviceName;
}

+ (AFHTTPRequestOperationManager *)AFHTTPRequestOperationManagerReturn {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    return manager;
}

+ (unsigned long long) scoreCalculate:(unsigned long long) totalProcess andPercentTest:(int) percentInt {
    unsigned long long numProcessIn1Percent = 0;
    numProcessIn1Percent = totalProcess / percentInt;
//    if (IS_OS_8_OR_LATER) {
//        numProcessIn1Percent = totalProcess / percentValueBatteryIos8;
//    } else {
//        numProcessIn1Percent = totalProcess / percentValueBatteryIos7;
//    }
    return numProcessIn1Percent / constToCalScore;
}

+ (NSString *) percentDecrease:(unsigned long long) checkingTime {
    NSString *percent = @"0";
    if (IS_OS_8_OR_LATER) {
        percent = [NSString stringWithFormat:@"%.0llu", (constLoseBattery * percentValueBatteryIos8) / checkingTime];
    } else {
        percent = [NSString stringWithFormat:@"%.0llu", (constLoseBattery * percentValueBatteryIos7) / checkingTime];
    }
    return percent;
}

+ (void) setStarToview:(int) numStars andImgView:(UIImageView *) imgV andLabelGoodBad:(UILabel *) lblGoodBad {
    switch (numStars) {
        case 0:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_0"];
                lblGoodBad.text = @"Poor";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_0"];
            }
        }
            break;
        case 1:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_1"];
                lblGoodBad.text = @"Poor";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_1"];
            }
        }
            break;
        case 2:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_2"];
                lblGoodBad.text = @"Poor";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_2"];
            }
        }
            break;
        case 3:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_3"];
                lblGoodBad.text = @"Fair";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_3"];
            }
        }
            break;
        case 4:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_4"];
                lblGoodBad.text = @"Fair";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_4"];
            }
        }
            break;
        case 5:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_5"];
                lblGoodBad.text = @"Average";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_5"];
            }
        }
            break;
        case 6:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_6"];
                lblGoodBad.text = @"Average";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_6"];
            }
        }
            break;
        case 7:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_7"];
                lblGoodBad.text = @"Good";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_7"];
            }
        }
            break;
        case 8:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_8"];
                lblGoodBad.text = @"Good";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_8"];
            }
        }
            break;
        case 9:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_9"];
                lblGoodBad.text = @"Excellent";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_9"];
            }
        }
            break;
        case 10:
        {
            if (lblGoodBad != nil) {
                imgV.image = [UIImage imageNamed:@"star_10"];
                lblGoodBad.text = @"Excellent";
            } else {
                imgV.image = [UIImage imageNamed:@"star_h_10"];
            }
        }
            break;
            
        default:
        {
            
        }
            break;
    }
}

+ (void) editDataSaveResultLocal:(long)indexObj andNumProcess:(NSString *) newNumProcess andTotalTime:(NSString *) newTotalTime andCheckingTime:(NSString *) newCheckingTime{
    NSMutableArray *arrLocalResults = [self readFileLocalSavingResult];
    if ([arrLocalResults count] > 0) {
        if (newNumProcess != nil && newNumProcess.length > 0) {
            [arrLocalResults objectAtIndex:indexObj][keyNumProcess] = newNumProcess;
        }
        
        if (newCheckingTime != nil && newCheckingTime.length > 0) {
            [arrLocalResults objectAtIndex:indexObj][keyCheckingTime] = newCheckingTime;
        }
        
        if (newTotalTime != nil && newTotalTime.length > 0) {
            [arrLocalResults objectAtIndex:indexObj][keyTotalTime] = newTotalTime;
        }
        
        //Save gain to file
        [self writeArrayToFileSavingResult:arrLocalResults];
    }
}

+ (UIImage *) captureAViewToImage:(UIView *) viewCaptured {
    UIGraphicsBeginImageContextWithOptions(viewCaptured.bounds.size, viewCaptured.opaque, 0.0f);
    [viewCaptured drawViewHierarchyInRect:viewCaptured.bounds afterScreenUpdates:NO];
    UIImage *captureImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:UIImageJPEGRepresentation(captureImg, kQualityCaptureView)];
}

+ (BOOL) checkingAppIsCharging {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) validAllConditionsBeforeStart {
    //Deveice is charing
    if ([Common checkingAppIsCharging]) {
        return NO;
    }
    
    //Current battery too small
    if ([Common getBatteryLevel] < minBatteryToChecking) {
        return NO;
    }
    
    //Current battery is 100%
    if ([Common getBatteryLevel] == 1.0) {
        return NO;
    }
    
    //Air plan mode is not available
    if (![Common checkingAirPlaneMode]) {
        return NO;
    }
    
    return YES;
}

+ (void)addBottomBorderWithColor:(UIView *)viewAdd andColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;

    border.frame = CGRectMake(0, viewAdd.frame.size.height - borderWidth, viewAdd.frame.size.width, borderWidth);
    [viewAdd.layer addSublayer:border];
}

+ (void)addTopBorderWithColor:(UIView *)viewAdd andColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, viewAdd.frame.size.width, borderWidth);
    [viewAdd.layer addSublayer:border];
}

/*
- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}
 */
+ (void)addRightBorderWithColor:(UIView *)viewAdd andColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(viewAdd.frame.size.width - borderWidth, 0, borderWidth, viewAdd.frame.size.height);
    [viewAdd.layer addSublayer:border];
}


+ (void) changeY:(UIView *) viewChange andY:(float) y {
    CGRect frameT = viewChange.frame;
    frameT.origin.y = y;
    viewChange.frame = frameT;
}
+ (void) changeX:(UIView *) viewChange andX:(float) x {
    CGRect frameT = viewChange.frame;
    frameT.origin.x = x;
    viewChange.frame = frameT;
}
+ (void) changeWidth:(UIView *) viewChange andWidth:(float) width {
    CGRect frameT = viewChange.frame;
    frameT.size.width = width;
    viewChange.frame = frameT;
}
+ (void) changeHeight:(UIView *) viewChange andHeight:(float) height {
    CGRect frameT = viewChange.frame;
    frameT.size.height = height;
    viewChange.frame = frameT;
}

+ (void) addShadowUnderView:(UIView*) viewAdded {
    //UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:viewAdded.bounds];
    //viewAdded.layer.masksToBounds = NO;
    viewAdded.layer.shadowColor = [UIColor grayColor].CGColor;
    viewAdded.layer.shadowOffset = CGSizeMake(0, 4);
    viewAdded.layer.shadowOpacity = 1;
    viewAdded.layer.shadowRadius = 1.0;
}

+ (void) setSavedLocalToServer:(NSString *) isSaved {
    [[NSUserDefaults standardUserDefaults] setObject:isSaved forKey:@"kIsSavedToServer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getSavedLocalToServer {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kIsSavedToServer"];
}

+ (void) saveLastScoreLocal:(NSString *) lastScore {
    [[NSUserDefaults standardUserDefaults] setObject:lastScore forKey:@"kLastScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getLastScoreLocal {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kLastScore"];
}

+ (void) saveLastTotalTimeLocal:(NSString *) lastTotal {
    [[NSUserDefaults standardUserDefaults] setObject:lastTotal forKey:@"kLastTotal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getLastTotalTimeLocal {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kLastTotal"];
}

+ (void) saveLastTimeInterval:(NSString *) lastTimeInterval {
    [[NSUserDefaults standardUserDefaults] setObject:lastTimeInterval forKey:@"kLastTimeInterval"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getLastTimeInterval {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kLastTimeInterval"];
}

//Cal score of stars: 2, 2.5, 3,...
+ (int) calScoreStar:(unsigned long long) lastScore {
    int percentResult = 10;
    NSMutableArray *arrMuScores = [[NSMutableArray alloc] init];
    
    //Get array of score
    NSMutableArray *arrListScore = [Common readFileListScoreFromServer];
    if ([arrListScore count] > 0) {
        for (int i = 0; i < [arrListScore count]; i++) {
            NSDictionary *oneRecord = [arrListScore objectAtIndex:i];
            [arrMuScores addObject:oneRecord[@"score"]];
        }
    }
    
    //Add last score to array
    [arrMuScores addObject:[NSString stringWithFormat:@"%llu", lastScore]];
    
    //Arrange array of scores
    if ([arrMuScores count] > 0) {
        //Convert to nsarray
        NSArray *arrScores = [[NSArray alloc] initWithArray:arrMuScores];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"integerValue" ascending:YES];
        arrScores = [arrScores sortedArrayUsingDescriptors:[NSMutableArray arrayWithObject:sort]];
        arrMuScores = [[NSMutableArray alloc] initWithArray:arrScores];
    }
    
    //Remove duplicate value in array
    arrMuScores = [[NSMutableArray alloc] initWithArray:[NSOrderedSet orderedSetWithArray:arrMuScores].array];
    
    //Get Stars
    int index = -1;
    for (int i = 0; i < [arrMuScores count]; i++) {
        if ([Common convertFromString:[arrMuScores objectAtIndex:i]] == lastScore) {
            index = i;
        }
    }
    if (index != -1) {
        percentResult = (index + 1) * 10 / [arrMuScores count];
    }
    
    NSLog(@"ARRAY MU SCORE : %@", arrMuScores);
    NSLog(@"Result: %d", percentResult);
    
    return percentResult;
}

+ (NSString *) convertDateTimeToString:(NSDate *) dateInput {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    return [NSString stringWithFormat:@"%@ %@", [dateFormat stringFromDate:dateInput], [timeFormat stringFromDate:dateInput]];
}

+ (void) zoomAnimation:(UIView *) viewZoom withValue:(float) valueZoom completed:(void(^)())block {
    viewZoom.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.3/1.5 animations:^{
        viewZoom.transform = CGAffineTransformScale(CGAffineTransformIdentity, valueZoom + 0.1, valueZoom + 0.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            viewZoom.transform = CGAffineTransformScale(CGAffineTransformIdentity, valueZoom - 0.1, valueZoom - 0.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                viewZoom.transform = CGAffineTransformScale(CGAffineTransformIdentity, valueZoom, valueZoom);
                block();
            }];
        }];
    }];
}

+ (void) zoom1xAnimation:(UIView *) viewZoom {
    viewZoom.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.3/1.5 animations:^{
        viewZoom.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            viewZoom.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                viewZoom.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

@end
