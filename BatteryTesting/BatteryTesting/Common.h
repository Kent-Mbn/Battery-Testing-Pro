//
//  Common.h
//  ParentalControlChildren
//
//  Created by CHAU HUYNH on 5/8/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "Define.h"
//#import "UserDefault.h"
#import <mach/mach_time.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/utsname.h>
#import "GAITrackingMethod.h"

@interface Common : NSObject

+(void)roundView:(UIView *)uView andRadius:(float) radius andBorderWidth:(float)borderWidth andColorBorder:(UIColor *) bColor;
+(void) showAlertView:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle arrayTitleOtherButtons:(NSArray *)arrayTitleOtherButtons tag:(int)tag;
+ (void) circleImageView:(UIView *) imgV;
+ (void) updateDeviceToken:(NSString *) newDeviceToken;
+ (NSString *) getDeviceToken;
+ (BOOL) isValidEmail:(NSString *)checkString;

+ (void) showNetworkActivityIndicator;
+ (void) hideNetworkActivityIndicator;

+ (CGFloat) heightScreen;
+ (CGFloat) widthScreen;

+ (int) returnIntBattery:(float)floatBattery;

#pragma mark - SECTION FOR ENCODE DECODE
+ (void) initDataFileLocalForEncodeDecode;
+ (NSArray *) arrayForEncodeDecode;
+ (NSString *) pathOfFileLocalForDecodeEncode;
+ (void) writeArrayToFileLocalForDecodeEncode:(NSMutableArray *) arrToWrite;
+ (NSMutableArray *) readFileLocalForDecodeEncode;
+ (void) writeObjToFileForDecodeEncode:(NSDictionary *) dicObj;
+ (void) removeFileLocalForDecodeEncode;
+ (NSString *) encodeBase64:(NSString *) strDecode;
+ (NSString *) decodeBase64:(NSString *) strEncode;

#pragma mark - SECTION FOR SAVE RESULT LOCAL
+ (NSString *) pathOfFileLocalSavingResult;
+ (NSMutableArray *) readFileLocalSavingResult;
+ (void) writeObjToFileSavingResult:(NSDictionary *) dicObj;
+ (void) writeArrayToFileSavingResult:(NSMutableArray *) arrToWrite;
+ (void) removeFileLocalSavingResult;

#pragma mark - SECTION FOR SAVE RESULT CARE LOCAL
+ (NSString *) pathOfFileLocalSavingResultCare;
+ (NSMutableArray *) readFileLocalSavingResultCare;
+ (void) writeObjToFileSavingResultCare:(NSDictionary *) dicObj;
+ (void) writeArrayToFileSavingResultCare:(NSMutableArray *) arrToWrite;
+ (void) removeFileLocalSavingResultCare;

#pragma mark - SECTION FOR GET LIST SCORE OF SERVER
+ (NSString *) pathOfFileListScoreFromServer;
+ (NSMutableArray *) readFileListScoreFromServer;
+ (void) writeArrayToFileListScoreFromServer:(NSMutableArray *) arrToWrite;
+ (void) removeFileListScoreFromServer;

+ (BOOL) isValidString:(NSString *) strCheck;
+ (float) getBatteryLevel;
+ (BOOL) checkingAirPlaneMode;

+ (NSString *) returnTimeCounter:(unsigned long long) numMiliSeconds;
+ (unsigned long long) convertFromString:(NSString *) strLlu;
+ (int) convertToIntFromString:(NSString *) strInt;
+ (void) circleView:(UIView *) viewInput;

+ (NSString *) returnStringFromInterval:(unsigned long long) numInterval;
+ (NSDictionary *) dicLastResultLocal:(BOOL)isFastly;

+ (NSString *) getCountryName;
+ (NSString*) deviceModel;

+ (void) changeY:(UIView *) viewChange andY:(float) y;
+ (void) changeX:(UIView *) viewChange andX:(float) x;
+ (void) changeWidth:(UIView *) viewChange andWidth:(float) width;
+ (void) changeHeight:(UIView *) viewChange andHeight:(float) height;

+ (AFHTTPRequestOperationManager *)AFHTTPRequestOperationManagerReturn;
+ (unsigned long long) scoreCalculate:(unsigned long long) totalProcess andPercentTest:(int) percentInt;
+ (NSString *) percentDecrease:(unsigned long long) checkingTime;

+ (void) setStarToview:(int) numStars andImgView:(UIImageView *) imgV andLabelGoodBad:(UILabel *) lblGoodBad;

+ (void) editDataSaveResultLocal:(long)indexObj andNumProcess:(NSString *) newNumProcess andTotalTime:(NSString *) newTotalTime andCheckingTime:(NSString *) newCheckingTime;
+ (UIImage *) captureAViewToImage:(UIView *) viewCaptured;
+ (BOOL) checkingAppIsCharging;
+ (BOOL) validAllConditionsBeforeStart;
+ (void)addBottomBorderWithColor:(UIView *)viewAdd andColor:(UIColor *)color andWidth:(CGFloat) borderWidth;
+ (void)addTopBorderWithColor:(UIView *)viewAdd andColor:(UIColor *)color andWidth:(CGFloat) borderWidth;
+ (void)addRightBorderWithColor:(UIView *)viewAdd andColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

+ (void) addShadowUnderView:(UIView*) viewAdded;

+ (void) setSavedLocalToServer:(NSString *) isSaved;
+ (NSString *) getSavedLocalToServer;
+ (void) saveLastScoreLocal:(NSString *) lastScore;
+ (NSString *) getLastScoreLocal;
+ (void) saveLastTotalTimeLocal:(NSString *) lastTotal;
+ (NSString *) getLastTotalTimeLocal;
+ (void) saveLastTimeInterval:(NSString *) lastTimeInterval;
+ (NSString *) getLastTimeInterval;


+ (int) calScoreStar:(unsigned long long) lastScore;
+ (NSString *) convertDateTimeToString:(NSDate *) dateInput;

+ (void) zoomAnimation:(UIView *) viewZoom withValue:(float) valueZoom completed:(void(^)())block;
+ (void) zoom1xAnimation:(UIView *) viewZoom;

@end
