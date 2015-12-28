//
//  HomeVC.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/4/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "ProcessClass.h"
#import "ResultVC.h"
#import "HistoryVC.h"
#import <iAd/iAd.h>
#import "AppDelegate.h"
#import "Define.h"


@interface HomeVC : UIViewController<UIAlertViewDelegate> {
    float currentBatteryValueAtStart;
    int beginBatteryValue;
    int endBatteryValue;
    int countFlicker;
    
    //BOOL for options testing
    BOOL isFastly;
    
    //Number of percent for testing;
    int percentTesting;
    
    //All time for preparing and checking (miliseconds)
    unsigned long long timeTotalChecking;
    
    //Time only for checking (miliseconds)
    unsigned long long timeChecking;
    
    //Banner Ads
    BOOL _bannerIsVisible;
    //ADBannerView *_adBanner;
    
    //NSArray to share
    NSMutableArray *arrayItemsToShare;
}

#pragma mark PROPERTY
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblLastScore;
@property (weak, nonatomic) IBOutlet UIButton *btStartStop;
@property (nonatomic, strong) ProcessClass *instanceProcess;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UIView *viewStatus;
@property (weak, nonatomic) IBOutlet UIView *viewLastScore;
@property (weak, nonatomic) IBOutlet UILabel *lblLastDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLastTime;
@property (weak, nonatomic) IBOutlet UIButton *btHistory;
@property (weak, nonatomic) IBOutlet UIView *viewBottomStatusBar;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeChecking;
@property (weak, nonatomic) IBOutlet UIView *viewChildButtonOk;
@property (weak, nonatomic) IBOutlet UILabel *lblModelDeviceResult;
@property (weak, nonatomic) IBOutlet UIButton *btInfo;

//View result
@property (weak, nonatomic) IBOutlet UIView *viewResultScoreAll;
@property (weak, nonatomic) IBOutlet UIView *viewButtonOk;
@property (weak, nonatomic) IBOutlet UIView *viewBGResultScore;
@property (weak, nonatomic) IBOutlet UILabel *lblResultScore;
@property (weak, nonatomic) IBOutlet UIView *viewLblScore;
@property (weak, nonatomic) IBOutlet UILabel *lblPleaseConnect;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorPleaseConnect;


//Timer for checking preparing or checking status
@property(nonatomic) NSTimer *timeCheckBattery;

//Timer for checking current status of process checking to notify to user
@property(nonatomic) NSTimer *timeCheckCurrentStatus;

//Timer for turn on/off flash light
@property(nonatomic) NSTimer *timeTurnOnOffFlashLight;

//Timer for count time
@property(nonatomic) NSTimer *timeCountTime;

//Timer for flicker label
@property(nonatomic) NSTimer *timeFlicker;

//Timer for call WS get result
@property(nonatomic) NSTimer *timerGetResultFromServer;

@property(nonatomic, strong) AVPlayer *avPlayer;
@property(nonatomic, strong) AVPlayerLayer *avLayer;

#pragma mark ACTIONS
- (IBAction)actionStartStop:(id)sender;
- (IBAction)actionHistory:(id)sender;
- (IBAction)actionHideViewResultScore:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionGoInfo:(id)sender;


@end
