//
//  HomeVC.m
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/4/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self initAdsBanner];
    [self initConfigure];
    
    //Register notification detect background mode
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeBackgroundMode:) name:UIApplicationWillResignActiveNotification object:nil];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    [self removeNotificationBecomeActive];
}

- (void) viewWillAppear:(BOOL)animated {
    //[self setupLastInforLocal];
    [self initLastScoreToScreen];
    [self initViews];
    [self addNotificationBecomeActive];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    GoogleTrackingBlock(self, NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) initConfigure {
    beginBatteryValue = currentBatteryValueAtStart = endBatteryValue = [Common returnIntBattery:[Common getBatteryLevel]];
    _instanceProcess = [ProcessClass sharedProcessObject];
    
    timeTotalChecking = 0;
    timeChecking = 0;
    countFlicker = 0;
    
    //Default option testing is Fastly
    isFastly = YES;
    
    //Percent for testing. Default is for Fastly option
    if (IS_OS_8_OR_LATER) {
        percentTesting = percentValueBatteryIos8;
    } else {
        percentTesting = percentValueBatteryIos7;
    }
    
    //Prepare for process read write file
    [Common removeFileLocalForDecodeEncode];
    [Common initDataFileLocalForEncodeDecode];
    
    //UIColor *colorBgView = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    //[_viewStatus setBackgroundColor:colorBgView];
    _viewStatus.backgroundColor = [UIColor redColor];
    
    //Init button start stop
    [self changeButtonStartStop];
    
    //Start timer checking current status
    [self startTimerCheckingCurrentStatus];
    
    //Init NSArray to share
    arrayItemsToShare = [[NSMutableArray alloc] init];
}

- (void) initViews {
    
    //init Video view
    [self initVideo];
    
    //Set bottom border for view status
    [Common addBottomBorderWithColor:_viewStatus andColor:[UIColor whiteColor] andWidth:1.0];
    
    //Move button and label to in front of video
    [self.view addSubview:_viewBottomStatusBar];
    [self.view addSubview:_btStartStop];
    [self.view addSubview:_viewStatus];
    [self.view addSubview:_viewLastScore];
    [_viewBottomStatusBar bringSubviewToFront:self.view];
    [_btStartStop bringSubviewToFront:self.view];
    [_viewLastScore bringSubviewToFront:self.view];
    [_viewStatus bringSubviewToFront:self.view];
    
    //Bring view result to font
    _viewBGResultScore.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:_viewBGResultScore];
    [_viewBGResultScore bringSubviewToFront:self.view];
    [Common roundView:_viewResultScoreAll andRadius:10.0f andBorderWidth:5.0f andColorBorder:MASTER_COLOR_EXTRA];
    [Common addBottomBorderWithColor:_viewLblScore andColor:MASTER_COLOR_EXTRA andWidth:1.0f];
    [Common addTopBorderWithColor:_viewButtonOk andColor:MASTER_COLOR_EXTRA andWidth:1.0f];
    [Common addRightBorderWithColor:_viewChildButtonOk andColor:MASTER_COLOR_EXTRA andWidth:1.0f];
    _lblModelDeviceResult.text = [Common deviceModel];
    [self hidePopupResult];
    
    //Set position and height of button start stop again
    int heightViewVideo = ([Common heightScreen] - _viewStatus.frame.size.height - _viewLastScore.frame.size.height -20);
    [Common changeHeight:_btStartStop andHeight:heightViewVideo/1.2];
    [Common changeWidth:_btStartStop andWidth:heightViewVideo/1.2];
    
    [Common changeY:_btStartStop andY:_viewStatus.frame.size.height + ([Common heightScreen] - _viewStatus.frame.size.height - _viewLastScore.frame.size.height)/2 - _btStartStop.frame.size.height / 2 + 10];
    [Common changeX:_btStartStop andX:[Common widthScreen]/2 - _btStartStop.frame.size.width/2];
    
    [Common circleView:_btStartStop];
    
    //Change color for views
    [_btStartStop setTitleColor:MASTER_COLOR forState:UIControlStateNormal];
    _viewStatus.backgroundColor = MASTER_COLOR;
    self.view.backgroundColor = MASTER_COLOR;
    _btHistory.backgroundColor = MASTER_COLOR;
}

- (void) addNotificationBecomeActive {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionAppBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) removeNotificationBecomeActive {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"modalToResult"]) {
//        ResultVC *destinaVC = (ResultVC *)segue.destinationViewController;
//        if (destinaVC != nil) {
//            NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"%llu", _instanceProcess.numberFinished], [NSString stringWithFormat:@"%llu",timeChecking], [NSString stringWithFormat:@"%llu",timeTotalChecking], [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]] forKeys:@[keyNumProcess, keyCheckingTime,keyTotalTime,keyCreatedAdd]];
//            destinaVC.dicResult = dicData;
//            
//            //New object to save local file
//            //destinaVC.indexObject = -1;
//        }
//    }
}

- (void) calScoreAndShowPopup {
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"%llu", _instanceProcess.numberFinished], [NSString stringWithFormat:@"%llu",timeChecking], [NSString stringWithFormat:@"%llu",timeTotalChecking], [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]] forKeys:@[keyNumProcess, keyCheckingTime,keyTotalTime,keyCreatedAdd]];
    NSString *strScore = @"";
    
    strScore = [self calAverangeScoreWithHistory:[Common scoreCalculate:_instanceProcess.numberFinished andPercentTest:percentTesting]];
    dicData[keyNumScore] = strScore;
            
    //Continue to save data to local
    if (![strScore isEqualToString:@"0"]) {
        //Save new score and total time to local
        [Common setSavedLocalToServer:@"false"];
        [Common saveLastScoreLocal:strScore];
        [Common saveLastTotalTimeLocal:[NSString stringWithFormat:@"%@", [Common returnTimeCounter:timeTotalChecking]]];
        [Common saveLastTimeInterval:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]];
        if (isFastly) {
            [Common writeObjToFileSavingResult:dicData];
        } else {
            [Common writeObjToFileSavingResultCare:dicData];
        }
    } else {
        [Common showAlertView:APP_NAME message:MSS_TESTING_IS_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:5];
        return;
    }
    
    //Save string Score to array share
    [arrayItemsToShare removeAllObjects];
    [arrayItemsToShare addObject:[NSString stringWithFormat:@"%@ \n Name: %@ \n Model: %@ \n Version OS: %@ \n Battery Score: %@", APP_NAME, [[UIDevice currentDevice] name], [Common deviceModel], [NSString stringWithFormat:@"%.1f", [[[UIDevice currentDevice] systemVersion] floatValue]] ,strScore]];
    NSURL *linkDownload = [NSURL URLWithString:URL_DOWN_APP];
    [arrayItemsToShare addObject:linkDownload];
    
    [self showPopupResult:strScore];
}


#pragma mark - TIMER
//Begin timer checking for status preparing or checking
- (void) startTimerCheckingStatus {
    if (_timeCheckBattery) {
        [_timeCheckBattery invalidate];
        _timeCheckBattery = nil;
    }
    _timeCheckBattery = [NSTimer scheduledTimerWithTimeInterval:timeCheckingBeginEndTesting target:self selector:@selector(endCheckBattery) userInfo:nil repeats:YES];
}

//Start timer checking current status of process
- (void) startTimerCheckingCurrentStatus {
    if (_timeCheckCurrentStatus) {
        [_timeCheckCurrentStatus invalidate];
        _timeCheckCurrentStatus = nil;
    }
    _timeCheckCurrentStatus = [NSTimer scheduledTimerWithTimeInterval:timeCheckingCurrentStatus target:self selector:@selector(endTimerCheckingCurrentStatus) userInfo:nil repeats:YES];
}

//Timer for turn on/off flash light
- (void) startTimeTurnOnOffFlashLight {
    if (_timeTurnOnOffFlashLight) {
        [_timeTurnOnOffFlashLight invalidate];
        _timeTurnOnOffFlashLight = nil;
    }
    _timeTurnOnOffFlashLight = [NSTimer scheduledTimerWithTimeInterval:timeTurnOnTurnOffFlashLight target:self selector:@selector(endTimeTurnOnOffFlashLight) userInfo:nil repeats:YES];
}

//Timer for count time
- (void) startTimeCountTime {
    timeChecking = 0;
    timeTotalChecking = 0;
    
    if (_timeCountTime) {
        [_timeCountTime invalidate];
        _timeCountTime = nil;
    }
    _timeCountTime = [NSTimer scheduledTimerWithTimeInterval:timeCountTimeMiliseconds target:self selector:@selector(endTimeCountTime) userInfo:nil repeats:YES];
}

//Timer flicker uilabel
- (void) startTimeFlickerLabel {
    if (_timeFlicker) {
        [_timeFlicker invalidate];
        _timeFlicker = nil;
    }
    _timeFlicker = [NSTimer scheduledTimerWithTimeInterval:timeFlickerLabel target:self selector:@selector(endTimeFlickerLabel) userInfo:nil repeats:YES];
}

//Timer get result from server
- (void) startGetResultFromServer {
    [self stopTimerGetResultFromServer];
    _timerGetResultFromServer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(endTimeGetResultFromServer) userInfo:nil repeats:YES];
}

- (void) stopTimerCheckingStatus {
    if (_timeCheckBattery) {
        [_timeCheckBattery invalidate];
        _timeCheckBattery = nil;
    }
}

- (void) stopTimerCheckingCurrentStatus {
    if (_timeCheckCurrentStatus) {
        [_timeCheckCurrentStatus invalidate];
        _timeCheckCurrentStatus = nil;
    }
}

- (void) stopTimeTurnOnOffFlashLight {
    if (_timeTurnOnOffFlashLight) {
        [_timeTurnOnOffFlashLight invalidate];
        _timeTurnOnOffFlashLight = nil;
    }
    
    //Turn off light
    AVCaptureDevice *capDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([capDevice hasFlash] && [capDevice hasTorch]) {
        if (capDevice.torchMode == AVCaptureTorchModeOn) {
            [capDevice lockForConfiguration:nil];
            [capDevice setTorchMode:AVCaptureTorchModeOff];
            [capDevice unlockForConfiguration];
        }
    }
}

- (void) stopTimeCountTime {
    if (_timeCountTime) {
        [_timeCountTime invalidate];
        _timeCountTime = nil;
    }
}

- (void) stopTimerFlickerLabel {
    if (_timeFlicker) {
        [_timeFlicker invalidate];
        _timeFlicker = nil;
    }
}

- (void) stopTimerGetResultFromServer {
    if (_timerGetResultFromServer) {
        [_timerGetResultFromServer invalidate];
        _timerGetResultFromServer = nil;
    }
}

- (void) endCheckBattery {
     float currentBattery = [Common getBatteryLevel];
     if ([Common returnIntBattery:currentBattery] == beginBatteryValue) {
         //To Starting status
         _instanceProcess.isStatusNow = kStatusStarting;
     } else if ([Common returnIntBattery:currentBattery] <= endBatteryValue) {
         //End checking battery
         [self stopProcessCheckingBattery];
         //[self performSegueWithIdentifier:@"modalToResult" sender:nil];
         [self calScoreAndShowPopup];
     }
    //_lblStatus.text = [NSString stringWithFormat:@"C: %d B: %d E: %d \n N: %llu", [Common returnIntBattery:currentBattery], beginBatteryValue, endBatteryValue, _instanceProcess.numberFinished];
}

- (void) endTimerCheckingCurrentStatus{
    if (_instanceProcess.isStatusNow != kStatusStarting && _instanceProcess.isStatusNow != kStatusPreparing) {
        if ([Common validAllConditionsBeforeStart]) {
            _instanceProcess.isStatusNow = kStopAndCanStart;
        } else {
            _instanceProcess.isStatusNow = kStopAndCannotStart;
        }
    }
    [self changeButtonStartStop];
    [self changeLabelStatus];
}

- (void) endTimeTurnOnOffFlashLight {
    AVCaptureDevice *capDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([capDevice hasFlash] && [capDevice hasTorch]) {
        if (capDevice.torchMode == AVCaptureTorchModeOff) {
            [capDevice lockForConfiguration:nil];
            [capDevice setTorchMode:AVCaptureTorchModeOn];
            [capDevice unlockForConfiguration];
        } else {
            [capDevice lockForConfiguration:nil];
            [capDevice setTorchMode:AVCaptureTorchModeOff];
            [capDevice unlockForConfiguration];
        }
    }
}

- (void) endTimeCountTime {
    timeTotalChecking ++;
    
    //If checking change status change from preparing to starting -> begin count time for checking.
    if (_instanceProcess.isStatusNow == kStatusStarting) {
        timeChecking ++;
    }
}

- (void) endTimeFlickerLabel {
    countFlicker++;
    if (countFlicker % 2 == 0) {
        _lblStatus.textColor = COLOR_WARNING_STATUS;
    } else {
        _lblStatus.textColor = [UIColor whiteColor];
    }
    
    if (countFlicker > kNumberFlickerLabel) {
        [self stopTimerFlickerLabel];
        _lblStatus.textColor = [UIColor whiteColor];
    }
}

- (void) endTimeGetResultFromServer {
    NSLog(@"endTimeGetResultFromServer");
    if (![Common checkingAirPlaneMode]) {
        [self stopTimerGetResultFromServer];
        
        //Animation for hide _viewResultScoreAll
        [UIView transitionWithView:_viewResultScoreAll duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:NULL completion:NULL];
        _viewResultScoreAll.hidden = YES;
        
        [self performSegueWithIdentifier:@"modalToResult" sender:nil];
    }
}

#pragma mark - FUNCTIONS
//- (void) initAdsBanner {
//    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, [Common widthScreen], heightAdsBanner)];
//    _adBanner.delegate = self;
//}

- (void) initVideo {
    _avPlayer = [AVPlayer playerWithURL:[[NSBundle mainBundle] URLForResource:nameVideoBG withExtension:@"mp4"]];
    _avLayer = [AVPlayerLayer layer];
    [_avLayer setPlayer:_avPlayer];
    
    [_avLayer setFrame:CGRectMake(0, 20 + _viewStatus.frame.size.height, [Common widthScreen], ([Common heightScreen] - _viewStatus.frame.size.height - _viewLastScore.frame.size.height -20))];
    [_avLayer setBackgroundColor:[UIColor grayColor].CGColor];
    [_avLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlayVideEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_avPlayer currentItem]];
    
    [self.view.layer addSublayer:_avLayer];
    _avLayer.hidden = YES;
    //[_avPlayer play];
}

- (void) playerPlayVideEnd:(NSNotification *) notification {
    AVPlayerItem *p = [_avPlayer currentItem];
    [p seekToTime:kCMTimeZero];
    //[_avPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_avPlayer play];
    });
}

//Calculate begin time and end time for checking battery
- (void) calEndBeginBatteryForTesting {
    currentBatteryValueAtStart = [Common getBatteryLevel];
    if (IS_OS_8_OR_LATER) {
        //Reduce 1% before begin testing
        beginBatteryValue = [Common returnIntBattery:currentBatteryValueAtStart] - reducePercentValueBatteryIos8;
    } else {
        //Reduce 5% before begin testing
        beginBatteryValue = [Common returnIntBattery:currentBatteryValueAtStart] - reducePercentValueBatteryIos7;
    }
    
    endBatteryValue = beginBatteryValue - percentTesting;
    
    /*
    if (IS_OS_8_OR_LATER) {
        endBatteryValue = beginBatteryValue - percentValueBatteryIos8;
    } else {
        endBatteryValue = beginBatteryValue - percentValueBatteryIos7;
    }
     */
}
                           
- (void) changeButtonStartStop {
    switch (_instanceProcess.isStatusNow) {
        case kStatusPreparing:
        case kStatusStarting:
        {
            //[_btStartStop setBackgroundImage:[UIImage imageNamed:@"bt_stop@2x.png"] forState:UIControlStateNormal];
            [self buttonSetupForStop];
            //_btStartStop.enabled = YES;
            _btHistory.enabled = NO;
            _btInfo.enabled = NO;
            _btHistory.backgroundColor = [UIColor lightGrayColor];
        }
        break;
        case kStopAndCanStart:
        {
            //[_btStartStop setBackgroundImage:[UIImage imageNamed:@"bt_start@2x.png"] forState:UIControlStateNormal];
            [self buttonSetupForStart];
            //_btStartStop.enabled = YES;
            _btHistory.enabled = YES;
            _btInfo.enabled = YES;
            _btHistory.backgroundColor = MASTER_COLOR;
        }
        break;
        case kStopAndCannotStart:
        {
            //[_btStartStop setBackgroundImage:[UIImage imageNamed:@"bt_cannot_start@2x.png"] forState:UIControlStateNormal];
            [self buttonSetupForCanNotStart];
            //_btStartStop.enabled = NO;
            _btHistory.enabled = YES;
            _btInfo.enabled = YES;
            _btHistory.backgroundColor = MASTER_COLOR;
        }
        break;
        default:
            break;
    }
}

- (void) changeLabelStatus {
    switch (_instanceProcess.isStatusNow) {
        case kStatusPreparing:
        {
            //_lblStatus.text = MSS_PROCESS_PREPARING;
        }
        case kStatusStarting:
        {
            //_lblStatus.text = MSS_PROCESS_CHECKING;
            if (timeTotalChecking > 0) {
                //Calculate time count down for estimate time
                long minutesCount = [self timeHistoryForTestingWithOption:isFastly] - lroundl(timeTotalChecking/60000);
                if (!(minutesCount > 1)) {
                    minutesCount = 1;
                }
                if (minutesCount > 1) {
                    _lblStatus.text = [NSString stringWithFormat:@"%@\n%@",MSS_HOW_LONG_HISTORY(minutesCount), [NSString stringWithFormat:@"%@",[Common returnTimeCounter:timeTotalChecking]]];
                } else {
                    _lblStatus.text = [NSString stringWithFormat:@"%@\n%@",MSS_HOW_LONG_HISTORY_ONE(minutesCount), [NSString stringWithFormat:@"%@",[Common returnTimeCounter:timeTotalChecking]]];
                }
                //_lblTimeChecking.text = [NSString stringWithFormat:@"%@",[Common returnTimeCounter:timeTotalChecking]];
            }
        }
        break;
        case kStopAndCanStart:
        {
            _lblStatus.text = MSS_PROCESS_CAN_START;
        }
            break;
        case kStopAndCannotStart:
        {
            if ([Common checkingAppIsCharging]) {
                _lblStatus.text = MSS_CURRENT_BATTERY_IS_CHARGING;
            } else if ([Common getBatteryLevel] < minBatteryToChecking) {
                _lblStatus.text = MSS_CURRENT_BATTERY_IS_SMALL;
            } else if ([Common getBatteryLevel] == 1.0) {
                _lblStatus.text = MSS_CURRENT_BATTERY_100_PERCENT;
            } else if (![Common checkingAirPlaneMode]) {
                _lblStatus.text = MSS_TURN_ON_AIR_PLANE_MODE;
            } else {
                _lblStatus.text = MSS_PROCESS_CAN_NOT_START;
            }
        }
            break;
        default:
            break;
    }
}

- (void) buttonSetupForStart {
    [_btStartStop setTitle:@"START" forState:UIControlStateNormal];
    _btStartStop.backgroundColor = COLOR_BUTTON_START;
}

- (void) buttonSetupForCanNotStart {
    [_btStartStop setTitle:@"START" forState:UIControlStateNormal];
    _btStartStop.backgroundColor = COLOR_BUTTON_CAN_NOT_START;
}

- (void) buttonSetupForStop {
    [_btStartStop setTitle:@"STOP" forState:UIControlStateNormal];
    _btStartStop.backgroundColor = COLOR_BUTTON_STOP;
}

//Setup last score when screen Init
- (void) initLastScoreToScreen {
    NSString *strLastScore = [Common getLastScoreLocal];
    NSString *strLastTimeInterval = [Common getLastTimeInterval];
    
    if (strLastScore.length > 0 && strLastTimeInterval.length > 0) {
        _lblLastScore.text = strLastScore;
        unsigned long long timeNum = [Common convertFromString:strLastTimeInterval];
        NSString *strDate = [Common returnStringFromInterval:timeNum];
        NSArray *arrDateString = [strDate componentsSeparatedByString:@" "];
        _lblLastDate.text = [arrDateString objectAtIndex:0];
        _lblLastTime.text = [arrDateString objectAtIndex:1];
    } else {
        _lblLastScore.text = @"0";
        _lblLastDate.text = @"00/00/00";
        _lblLastTime.text = @"00:00:00";
    }
}

- (void) setupLastInforLocal {
    NSDictionary *dicLast = [Common dicLastResultLocal:isFastly];
    if (dicLast != nil) {
        _lblLastScore.text = dicLast[keyNumScore];
        unsigned long long timeNum = [Common convertFromString:dicLast[keyCreatedAdd]];
        NSString *strDate = [Common returnStringFromInterval:timeNum];
        NSLog(@"StrDate: %@", strDate);
        NSArray *arrDateString = [strDate componentsSeparatedByString:@" "];
        _lblLastDate.text = [arrDateString objectAtIndex:0];
        _lblLastTime.text = [arrDateString objectAtIndex:1];
    } else {
        _lblLastScore.text = @"0";
        _lblLastDate.text = @"00/00/00";
        _lblLastTime.text = @"00:00:00";
    }
}

- (void) startProcessCheckingBattery {
    _avLayer.hidden = NO;
    [_avPlayer play];
    //_adBanner.hidden = YES;
    _lblTimeChecking.hidden = NO;
    
    [self calEndBeginBatteryForTesting];
    [self startTimerCheckingStatus];
    [self startTimerCheckingCurrentStatus];
    //[self startTimeTurnOnOffFlashLight];
    [self startTimeCountTime];
    [_instanceProcess startRunningProcess];
}

- (void) stopProcessCheckingBattery {
    _avLayer.hidden = YES;
    [_avPlayer pause];
    //Set to 0 seek time
    AVPlayerItem *p = [_avPlayer currentItem];
    [p seekToTime:kCMTimeZero];
    [self stopTimerCheckingStatus];
    [self stopTimeCountTime];
    [_instanceProcess stopRunningProcess];
    //[self stopTimeTurnOnOffFlashLight];
}

- (void) flickerLabelStatus {
    //countFlicker = 0;
    //[self startTimeFlickerLabel];
    [Common zoom1xAnimation:_lblStatus];
}

- (int) timeHistoryForTestingWithOption:(BOOL) isFast {
    NSMutableArray *arrHistory = [[NSMutableArray alloc] init];
    if (isFast) {
        arrHistory = [Common readFileLocalSavingResult];
    } else {
        arrHistory = [Common readFileLocalSavingResultCare];
    }
    if ([arrHistory count] > 0) {
        //Miliseconds
        unsigned long long totalTime = 0;
        for (int i = 0; i < [arrHistory count]; i++) {
            NSDictionary *obj = [arrHistory objectAtIndex:i];
            totalTime += [Common convertFromString:obj[keyTotalTime]];
        }
        return round(totalTime/[arrHistory count]/60000);
    }
    
    if (isFast) {
        if (IS_OS_8_OR_LATER) {
            return timeDefaultTestingAboveIos8;
        }
        return timeDefaultTestingIos7;
    } else {
        if (IS_OS_8_OR_LATER) {
            return timeDefaultTestingCareAboveIos8;
        }
        return timeDefaultTestingCareIos7;
    }
}

- (void) showPopupResult:(NSString *) strScore {
    _viewBGResultScore.hidden = NO;
    _viewResultScoreAll.hidden = YES;
    _lblResultScore.text = strScore;
    
    //Animation for show _viewResultScoreAll
    [UIView transitionWithView:_viewResultScoreAll duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:NULL completion:NULL];
    _viewResultScoreAll.hidden = NO;
    
    //Save new Score to local
    [self setupLastInforLocal];
    
    //Capture and add image
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [arrayItemsToShare addObject:[Common captureAViewToImage:self.view]];
    });
}

- (void) hidePopupResult {
    _viewBGResultScore.hidden = YES;
}

- (NSString *) calAverangeScoreWithHistory:(unsigned long long) newScore {
    unsigned long long resultScore = 0;
    //Get list score from file local
    NSMutableArray *arrListScore = [[NSMutableArray alloc] init];
    if (isFastly) {
        arrListScore = [Common readFileLocalSavingResult];
    } else {
        arrListScore = [Common readFileLocalSavingResultCare];
    }
    
    //[Common showAlertView:APP_NAME message:[NSString stringWithFormat:@"%@ and %llu", arrListScore,newScore] delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    
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

- (void) appBecomeBackgroundMode:(NSNotification *) note {
    //When app go to background mode -> stop process testing
    [self stopProcessCheckingBattery];
}

//TODO: remove
- (void) addTempDataToFile {
    NSDictionary *dicObj = [[NSDictionary alloc] initWithObjects:@[@"360000", [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]], @"12345788", @"7", @"15467864"] forKeys:@[keyCheckingTime, keyCreatedAdd, keyNumProcess, keyTotalTime]];
    for (int i = 0; i < 10 ; i++) {
        [Common writeObjToFileSavingResult:dicObj];
    }
}

#pragma mark - ACTIONS
- (IBAction)actionStartStop:(id)sender {
    
//    if (_instanceProcess.isStatusNow == kStatusPreparing || _instanceProcess.isStatusNow == kStatusStarting) {
//        [Common showAlertView:APP_NAME message:MSS_CANCEL_PROCESS_TESTING delegate:self cancelButtonTitle:@"No" arrayTitleOtherButtons:@[@"Yes"] tag:2];
//    } else if (_instanceProcess.isStatusNow == kStopAndCannotStart) {
//        [self flickerLabelStatus];
//    } else {
//        int minuteEstimateFast = [self timeHistoryForTestingWithOption:YES];
//        NSString *strMinuteEstimateFast = @"";
//        int minuteEstimateCare = [self timeHistoryForTestingWithOption:NO];
//        NSString *strMinuteEstimateCare = @"";
//        
//        if (minuteEstimateFast > 1) {
//            strMinuteEstimateFast = [NSString stringWithFormat:@"%d minutes", minuteEstimateFast];
//        } else {
//            strMinuteEstimateFast = @"1 minute";
//        }
//        
//        if (minuteEstimateCare > 1) {
//            strMinuteEstimateCare = [NSString stringWithFormat:@"%d minutes", minuteEstimateCare];
//        } else {
//            strMinuteEstimateCare = @"1 minute";
//        }
//        
//        if (IS_OS_8_OR_LATER) {
//            [Common showAlertView:APP_NAME message:MSS_OPTIONS_FOR_TESTING(percentValueBatteryIos8, strMinuteEstimateFast, percentValueBatteryCareIos8, strMinuteEstimateCare) delegate:self cancelButtonTitle:@"Cancel" arrayTitleOtherButtons:@[@"Fastly",@"Carefully"] tag:3];
//        } else {
//            [Common showAlertView:APP_NAME message:MSS_OPTIONS_FOR_TESTING(percentValueBatteryIos7, strMinuteEstimateFast, percentValueBatteryCareIos7, strMinuteEstimateCare) delegate:self cancelButtonTitle:@"Cancel" arrayTitleOtherButtons:@[@"Fastly",@"Carefully"] tag:3];
//        }
//        
//    }
    
    //Show popup result
//    _viewBGResultScore.hidden = NO;
//    _viewResultScoreAll.hidden = YES;
//    _lblResultScore.text = @"123";
    
    //Animation for show _viewResultScoreAll
//    [UIView transitionWithView:_viewResultScoreAll duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:NULL completion:^(BOOL finished) {
//        [_indicatorPleaseConnect startAnimating];
//    }];
//    _viewResultScoreAll.hidden = NO;
    
    
    
    //Show result screen
    //Animation for hide _viewResultScoreAll
//    [UIView transitionWithView:_viewResultScoreAll duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:NULL completion:NULL];
//    _viewResultScoreAll.hidden = YES;
    [self performSegueWithIdentifier:@"modalToResult" sender:nil];
    
    
    
}

- (IBAction)actionHistory:(id)sender {
    [self performSegueWithIdentifier:@"modalToHistory" sender:nil];
    //[self performSegueWithIdentifier:@"modalToResult" sender:nil];
}

- (IBAction)actionHideViewResultScore:(id)sender {
    [self hidePopupResult];
}

- (IBAction)actionShare:(id)sender {
    /*
    UIActivityViewController *viewShare = [[UIActivityViewController alloc] initWithActivityItems:arrayItemsToShare applicationActivities:nil];
    [self presentViewController:viewShare animated:YES completion:nil];
     */
    
    /* Redirect to Settings App */
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
}

- (IBAction)actionGoInfo:(id)sender {
    AppDelegate *delegate = APP_DELEGATE;
    [delegate setRootViewIntroduceWithCompletion:^{
        
    }];
}

- (void) actionAppBecomeActive:(id) sender {
    NSLog(@"+++++ Become active!");
    if (_viewBGResultScore.hidden == NO) {
        [self startGetResultFromServer];
    }
}

#pragma mark - UITEXTFIELD DELEGATE
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1:
        {
            if (buttonIndex == 1) {
                //Start process now!
                [self startProcessCheckingBattery];
            }
        }
            break;
        case 2:
        {
            if (buttonIndex == 1) {
                //Stop process now!
                [self stopProcessCheckingBattery];
            }
        }
            break;
        case 3:
        {
            if (buttonIndex == 1) {
                //Option Fastly
                isFastly = YES;
                if (IS_OS_8_OR_LATER) {
                    percentTesting = percentValueBatteryIos8;
                } else {
                    percentTesting = percentValueBatteryIos7;
                }
                //[Common showAlertView:APP_NAME message:MSS_REMIND_TURN_OFF_BACKGROUND_APP delegate:self cancelButtonTitle:@"Not sure" arrayTitleOtherButtons:@[@"Sure"] tag:1];
                [self startProcessCheckingBattery];
            }
            if (buttonIndex == 2) {
                //Option Carefully
                isFastly = NO;
                if (IS_OS_8_OR_LATER) {
                    percentTesting = percentValueBatteryCareIos8;
                } else {
                    percentTesting = percentValueBatteryCareIos7;
                }
                //[Common showAlertView:APP_NAME message:MSS_REMIND_TURN_OFF_BACKGROUND_APP delegate:self cancelButtonTitle:@"Not sure" arrayTitleOtherButtons:@[@"Sure"] tag:1];
                [self startProcessCheckingBattery];
            }
        }
            break;
        case 5:
        {
            [self stopProcessCheckingBattery];
        }
            break;
        default:
            break;
    }
}

//#pragma mark - ADS BANNER DELEGATE
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner
//{
//    if (!_bannerIsVisible)
//    {
//        // If banner isn't part of view hierarchy, add it
//        if (_adBanner.superview == nil)
//        {
//            [self.view addSubview:_adBanner];
//            [_adBanner bringSubviewToFront:self.view];
//        }
//        
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        
//        // Assumes the banner view is just off the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, -heightAdsBanner);
//        banner.hidden = NO;
//        
//        //Hide label time checking
//        //_lblTimeChecking.hidden = YES;
//        
//        [UIView commitAnimations];
//        
//        _bannerIsVisible = YES;
//    }
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    NSLog(@"Failed to retrieve ad");
//    
//    if (_bannerIsVisible)
//    {
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        
//        // Assumes the banner view is placed at the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
//        
//        //Show label time checking
//        //_lblTimeChecking.hidden = NO;
//        
//        [UIView commitAnimations];
//        
//        _bannerIsVisible = NO;
//    }
//}

                           
@end
