//
//  ResultVC.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/9/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "Define.h"
#import <Social/Social.h>

@interface ResultVC : UIViewController {
    unsigned long long totalProcess;
    unsigned long long totalTime;
    unsigned long long checkingTime;
    unsigned int percentDecrease;
    unsigned short counterAnimation;
    int number_stars;
}

#pragma mark - PROPERTY
//Index object in array in local file
@property (nonatomic) BOOL isFromHistory;
@property (nonatomic) NSMutableDictionary *dicResult;
@property (nonatomic) NSTimer *timerAnimationPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentBattery;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UIView *viewTurnOnInternet;
@property (weak, nonatomic) IBOutlet UIView *viewStarts;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodOrBad;
@property (weak, nonatomic) IBOutlet UIImageView *imvNumberStars;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoading;
@property (weak, nonatomic) IBOutlet UIView *viewAllResult;
@property (weak, nonatomic) IBOutlet UIView *viewAboveResult;
@property (weak, nonatomic) IBOutlet UIView *viewBottomResult;
@property (weak, nonatomic) IBOutlet UIView *viewHeaderTitle;
@property (weak, nonatomic) IBOutlet UIButton *btTryAgain;
@property (weak, nonatomic) IBOutlet UIView *viewEnergy;
@property (weak, nonatomic) IBOutlet UIImageView *imgEnergy;
@property (weak, nonatomic) IBOutlet UIView *viewContainBaterry;
@property (weak, nonatomic) IBOutlet UIView *viewPercentLabel;
@property (weak, nonatomic) IBOutlet UIView *viewBottomResultInfor;
@property (weak, nonatomic) IBOutlet UIView *viewPercentOut;
@property (weak, nonatomic) IBOutlet UIView *viewPercentMaskOut;
@property (weak, nonatomic) IBOutlet UIView *viewPercentMaskIn;

#pragma mark - ACTION
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionTryAgain:(id)sender;
- (IBAction)actionShare:(id)sender;

@end
