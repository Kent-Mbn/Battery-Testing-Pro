//
//  ResultVC.m
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/9/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ResultVC.h"

@interface ResultVC ()

@end

@implementation ResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initGUIs];
}

- (void) initGUIs {
    [Common circleView:_viewPercentOut];
    [self setColorForView];
    [Common addBottomBorderWithColor:_viewHeaderTitle andColor:[UIColor whiteColor] andWidth:2.0f];
}

- (void) initData {
    number_stars = 0;
    counterAnimation = 0;
    percentDecrease = 0;
}

- (void) viewWillAppear:(BOOL)animated {
    //Calculate result
    if (_dicResult != nil) {
        totalProcess = [Common convertFromString:_dicResult[keyNumProcess]];
        totalTime = [Common convertFromString:_dicResult[keyTotalTime]];
        checkingTime = [Common convertFromString:_dicResult[keyCheckingTime]];
        _lblTimeTotal.text = [NSString stringWithFormat:@"%@", [Common returnTimeCounter:checkingTime]];
        _lblPercentBattery.text = @"100%";
        if (_isFromHistory) {
            _lblScore.text = _dicResult[keyNumScore];
            number_stars = [Common calScoreStar:[Common convertFromString:_dicResult[keyNumScore]]];
        } else {
            _lblScore.text = [self calAverangeScoreWithHistory:[Common scoreCalculate:totalProcess andPercentTest:0]];
            _dicResult[keyNumScore] = _lblScore.text;
            
            //Save new score and total time to local
            [Common saveLastScoreLocal:_lblScore.text];
            [Common saveLastTotalTimeLocal:[NSString stringWithFormat:@"%@", [Common returnTimeCounter:totalTime]]];
            
            number_stars = [Common calScoreStar:[Common convertFromString:_lblScore.text]];
            
            //Continue to save data to local
            [Common writeObjToFileSavingResult:_dicResult];
        }
        percentDecrease = [self calPercentDecrease:number_stars];
        if (number_stars > 0) {
            [self setViewHasStars];
        } else {
            [self setViewNoStars];
        }
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    GoogleTrackingBlock(self, NSStringFromClass([self class]));
    [self startTimerPercentAnimation];
}


- (void) viewWillDisappear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - FUNCTIONS
- (void) setColorForView {
    _viewHeaderTitle.backgroundColor = MASTER_COLOR;
    _viewAboveResult.backgroundColor = MASTER_COLOR;
    [_btTryAgain setBackgroundColor:MASTER_COLOR];
}

- (void) setViewHasStars {
    _viewTurnOnInternet.hidden = YES;
    _viewStarts.hidden = NO;
    _indicatorLoading.hidden = YES;
    [Common setStarToview:number_stars andImgView:_imvNumberStars andLabelGoodBad:_lblGoodOrBad];
}

- (void) setViewNoStars {
    _viewTurnOnInternet.hidden = NO;
    _indicatorLoading.hidden = YES;
    _viewStarts.hidden = YES;
}

- (void) startIndicator {
    _indicatorLoading.hidden = NO;
    [_indicatorLoading startAnimating];
}

- (void) stopIndicator {
    _indicatorLoading.hidden = YES;
    [_indicatorLoading stopAnimating];
}

- (void) setPercentEnergyDecreaseOnePercent {
    float heightOf1Percent = 0;
    
    //Height of 1 percent
    heightOf1Percent = _viewEnergy.frame.size.height / 100.0f;
    
    [Common changeHeight:_imgEnergy andHeight:(_imgEnergy.frame.size.height - heightOf1Percent)];
    [Common changeY:_imgEnergy andY:(_imgEnergy.frame.origin.y + heightOf1Percent)];
}

- (void) startTimerPercentAnimation {
    if (_timerAnimationPercent) {
        [_timerAnimationPercent invalidate];
        _timerAnimationPercent = nil;
    }
    _timerAnimationPercent = [NSTimer scheduledTimerWithTimeInterval:timeAnimationPercent target:self selector:@selector(endTimerAnimationPercent) userInfo:nil repeats:YES];
}

- (void) endTimerAnimationPercent {
    if (counterAnimation <= percentDecrease) {
        //Change label percent
        _lblPercentBattery.text = [NSString stringWithFormat:@"%d%%", 100 - counterAnimation];
        
        //Change energy
        [self setPercentEnergyDecreaseOnePercent];
        
    } else {
        if (_timerAnimationPercent) {
            [_timerAnimationPercent invalidate];
            _timerAnimationPercent = nil;
        }
        return;
    }
    counterAnimation++;
}

- (NSString *) calAverangeScoreWithHistory:(unsigned long long) newScore {
    unsigned long long resultScore = 0;
    //Get list score from file local
    NSMutableArray *arrListScore = [Common readFileLocalSavingResult];
    if ([arrListScore count] == 0) {
        resultScore = newScore;
    } else {
        if (newScore > 0) {
            unsigned long long totalScore = newScore;
            
            for (int i = 0; i < [arrListScore count]; i++) {
                NSDictionary *oneRecord = [arrListScore objectAtIndex:i];
                totalScore += [Common convertFromString:oneRecord[keyNumScore]];
            }
            resultScore = totalScore / ([arrListScore count] + 1);
        }
    }
    return [NSString stringWithFormat:@"%llu", resultScore];
}

- (int) calPercentDecrease:(int) scoreStar {
    //0.5 -> 5%
    return (10 - scoreStar) * 5 / 0.5;
}

//- (void) calculateWidthBatteryAgain {
//    float widthScreen = [Common widthScreen];
//    
//    
//    //Calculate battery width
//    
//    
//    //Calculate position X of percent
//    
//    
//}

//#pragma mark - WEBSERVICE
//- (void) callWSSaveResult {
//    [self startIndicator];
//    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
//    NSMutableDictionary *request_param = [@{
//                                            @"name_device" : [[UIDevice currentDevice] name],
//                                            @"model_device" : [Common deviceModel],
//                                            @"country_device" : [Common getCountryName],
//                                            @"version_system_device" : [NSString stringWithFormat:@"%.1f", [[[UIDevice currentDevice] systemVersion] floatValue]],
//                                            @"score" : @"456784",
//                                            @"time_checking" : @"04:56",
//                                            @"created_date" : [NSString stringWithFormat:@"%ld", (long)round([[NSDate date] timeIntervalSince1970])],
//                                            } mutableCopy];
//    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_ADD_RESULT));
//    [manager POST:URL_SERVER_API(API_ADD_RESULT) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self stopIndicator];
//        
//        NSLog(@"response: %@", responseObject);
//        if ([responseObject[@"data"][@"status"] integerValue] == 1) {
//            number_stars = [responseObject[@"data"][@"num_stars"] integerValue];
//            [self setViewHasStars];
//        } else {
//            [self setViewNoStars];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self stopIndicator];
//        [self setViewNoStars];
//        [Common showAlertView:APP_NAME message:MSS_TURN_ON_INTERNET delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
//    }];
//}


#pragma mark - ACTIONS
- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//- (IBAction)actionTryAgain:(id)sender {
//    [self callWSSaveResult];
//    _viewTurnOnInternet.hidden = YES;
//}

- (IBAction)actionShare:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbSLCompse = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSLCompse setInitialText:@"My battery testing result!"];
        if (number_stars > 0) {
            [fbSLCompse addImage:[Common captureAViewToImage:_viewAllResult]];
        } else {
            [fbSLCompse addImage:[Common captureAViewToImage:_viewAboveResult]];
        }
        [fbSLCompse addURL:[NSURL URLWithString:URL_DOWN_APP]];
        [fbSLCompse setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    
                break;
                case SLComposeViewControllerResultDone:
                    [Common showAlertView:APP_NAME message:MSS_POST_FACEBOOK_SUCCESS delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
                break;
                    
                default:
                    break;
            }
        }];
        [self presentViewController:fbSLCompse animated:YES completion:nil];
    }
}

- (IBAction)actionTryAgain:(id)sender {
    
}
@end
