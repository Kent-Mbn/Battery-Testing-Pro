//
//  Define.h
//  benchmark_dispatch
//
//  Created by CHAU HUYNH on 6/4/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//


//API Webservice
#define SERVER_IP
#define SERVER_PORT @"80"

//#define SERVER_IP 
//#define SERVER_PORT @"80"

#define URL_SERVER_API_FULL [NSString stringWithFormat:@"%@", SERVER_IP]
#define URL_SERVER_API(method) [NSString stringWithFormat:@"%@%@",URL_SERVER_API_FULL,method]
#define API_ADD_RESULT @"/results.json"
#define API_GET_LIST_SCORE @"/results/getListScore.json"

#define APP_NAME @"Battery Testing Pro"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define NAME_LOCAL_FILE_SAVE_RESULT_TESTING @"locationResultTesting.plist"
#define NAME_LOCAL_FILE_SAVE_RESULT_TESTING_CARE @"locationResultTestingCare.plist"
#define NAME_LOCAL_FILE_FOR_ENCODE_DECODE @"localEncodeDecode.plist"
#define NAME_LOCA_FILE_LIST_SCORE @"localListScore.plist"

#define URL_DOWN_APP @"https://itunes.apple.com/us/app/battery-testing/id887730232?l=vi&ls=1&mt=8"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//Value for alogrithm bechmark
#define numberA 9991999
#define numberB 64512
#define numberC 678945

//Value percent of battery for checking
#define reducePercentValueBatteryIos8 1
#define reducePercentValueBatteryIos7 5

//Option fasty
#define percentValueBatteryIos8 1
#define percentValueBatteryIos7 5

//Option carefully
#define percentValueBatteryCareIos8 15
#define percentValueBatteryCareIos7 15

//Time default for testing -> for fastly
#define timeDefaultTestingAboveIos8 3
#define timeDefaultTestingIos7 15

//Time for testing -> for carefully
#define timeDefaultTestingCareAboveIos8 30
#define timeDefaultTestingCareIos7 40

#define minBatteryToChecking 0.2
#define widthExiplonCircle 25

//Message
#define MSS_TURN_ON_AIR_PLANE_MODE @"Please turn on Air Plan mode"
#define MSS_PROCESS_TESTING_IS_STOP @"Testing process was stopped"
#define MSS_CURRENT_BATTERY_IS_SMALL @"Battery is less than 20%"
#define MSS_CURRENT_BATTERY_100_PERCENT @"Can't test when battery is about 100%"
#define MSS_CURRENT_BATTERY_IS_CHARGING @"Please unplug the phone charger"
#define MSS_PROCESS_CAN_NOT_START @"Can not start!"
#define MSS_PROCESS_CAN_START @"Press Start button to check the battery"
#define MSS_POST_FACEBOOK_SUCCESS @"Post on Facebook successfully"
#define MSS_POST_FACEBOOK_FAILED @"Posting on Facebook failed"
#define MSS_REMIND_TURN_OFF_BACKGROUND_APP @"Are you sure that you has already turned off all apps running in background?"
#define MSS_TURN_ON_INTERNET @"Please check your internet connection"
#define MSS_HOW_LONG_HISTORY(time) [NSString stringWithFormat:@"Please wait about %ld minutes", time]
#define MSS_HOW_LONG_HISTORY_ONE(time) [NSString stringWithFormat:@"Please wait about %ld minute", time]
#define MSS_HOW_LONG_IOS_7 @"Please wait about 15 minutes"
#define MSS_HOW_LONG_IOS_8_ABOVE @"Please wait about 8 minutes"
#define MSS_CHECKING_ACCOUNT_FACEBOOK @"Please check the facebook account in Setting of Facebook"
#define MSS_CANCEL_PROCESS_TESTING @"Do you really want to cancel testing process?"
#define MSS_OPTIONS_FOR_TESTING(percent1,time1,percent2,time2) [NSString stringWithFormat:@"FASTLY: Your battery is tested in %d%% with %@. The result will be pretty good. \n\n CAREFULLY: Your battery is tested in %d%% with %@. The result will be best.", percent1, time1, percent2, time2]
#define MSS_TURN_OFF_AIR_PLANE_MODE @"* Please turn off air plane mode *"

#define MSS_INTRODUCE_1 @"After finishing process of testing battery, you will get some scores which are used to compare with another battery of the same model."
#define MSS_INTRODUCE_2 @"With Fastly mode, the more times you test, the more exact the score per time is."
#define MSS_INTRODUCE_3 @"This is LITE version.\nThis version is just with purpose to collect the scores over the world.\nWe will release PRO version including new function as valuing whether your battery is good or not."
#define MSS_TESTING_IS_FAILED @"Testing process failed. Please try again."
#define MSS_TEXT_RESULT @"The life of your battery is:"

#define MSS_NAME_IMAGE_INTRODEUCE_1 @"intro_all_screen_1"
#define MSS_NAME_IMAGE_INTRODEUCE_2 @"intro_all_screen_2"
#define MSS_NAME_IMAGE_INTRODEUCE_3 @"intro_all_screen_3"

#define APP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

//#define MASTER_COLOR [UIColor colorWithRed:0.423 green:0.905 blue:1 alpha:1.0]
#define MASTER_COLOR UIColorFromRGB(0xd74d54)
#define MASTER_COLOR_EXTRA UIColorFromRGB(0xe0787d)
#define CHILD_COLOR UIColorFromRGB(0x5CB833)
#define COLOR_WARNING_STATUS UIColorFromRGB(0xfa50fa)
#define COLOR_VALUE_PERCENT UIColorFromRGB(0xc8ed76)
#define COLOR_OUT_PERCENT UIColorFromRGB(0xfca7ac)
//0x6bf03b
#define COLOR_UIPAGE_CONTROLLER_INDEX UIColorFromRGB(0x90ddee)

//Define color of buttons
//#define COLOR_BUTTON_CAN_NOT_START UIColorFromRGB(0x919191)
//#define COLOR_BUTTON_STOP UIColorFromRGB(0xFF722B)
//#define COLOR_BUTTON_START UIColorFromRGB(0x00CE3E)
#define COLOR_BUTTON_CAN_NOT_START [UIColor whiteColor]
#define COLOR_BUTTON_STOP [UIColor whiteColor]
#define COLOR_BUTTON_START [UIColor whiteColor]


//Define status prearing, starting and stop for checking process
#define kStatusPreparing 0
#define kStatusStarting 1
#define kStopAndCanStart 2
#define kStopAndCannotStart 3

//Timer time (seconds)
#define timeCheckingBeginEndTesting 0.1
#define timeCheckingCurrentStatus 1
#define timeTurnOnTurnOffFlashLight 1
#define timeCountTimeMiliseconds 0.001
#define timeFlickerLabel 0.5
#define timeAnimationPercent 0.05
#define timeGetListScoreFromServer 15
#define timePushLastScoreToServer 15

//Result
#define constToCalScore 15
#define constLoseBattery 3600000

//Name of video file
#define nameVideoBG @"VideoLight"

//Key for dictionary result
#define keyNumProcess @"numProcess"
#define keyTotalTime @"numTotalTime"
#define keyCheckingTime @"numCheckingTime"
#define keyCreatedAdd @"createdAdd"
#define keyNumScore @"numScore"

//Key for dictionary for last score local
#define keyLocalLastScore @"keyLastScoreLocal"
#define keyLocalTotalTime @"keyTotalTimeLocal"

//Quality in image captured
#define kQualityCaptureView 0.5

//Number for flicker of label
#define kNumberFlickerLabel 4

//Height of banner ads
#define heightAdsBanner 50
