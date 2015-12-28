//
//  HistoryVC.m
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/10/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "HistoryVC.h"

@interface HistoryVC ()

@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init Ads
    //[self initAdsBanner];
    
    //Set shadow for view header
    [Common addBottomBorderWithColor:_viewTitleHeader andColor:[UIColor whiteColor] andWidth:1.0f];
    
    //Set top border for view header
    _viewTitleHeader.backgroundColor = MASTER_COLOR;
    _lblTotalResults.backgroundColor = MASTER_COLOR;
    _viewHeaderTable.backgroundColor = MASTER_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    GoogleTrackingBlock(self, NSStringFromClass([self class]));
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Read data from file
    _arrData = [Common readFileLocalSavingResult];
    
    //Show number of results
    if ([_arrData count] == 1) {
        _lblTotalResults.text = [NSString stringWithFormat:@"%lu result", (unsigned long)[_arrData count]];
    } else {
        _lblTotalResults.text = [NSString stringWithFormat:@"%lu results", (unsigned long)[_arrData count]];
    }
    
    
    //Show data to table view
    if (_arrData != nil && [_arrData count] > 0) {
        NSArray *arrTemp = _arrData;
        _arrData = [[NSMutableArray alloc] initWithArray:[[arrTemp reverseObjectEnumerator] allObjects]];
        [_tblView reloadData];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToResultFromHistory"]) {
        ResultVC *destinationVC = segue.destinationViewController;
        destinationVC.dicResult = [_arrData objectAtIndex:indexSelecting];
        
        //Because indexSelecting of array is reversed.
        destinationVC.isFromHistory = YES;
    }
}

//#pragma mark - FUNCTIONS
//- (void) initAdsBanner {
//    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, [Common widthScreen], heightAdsBanner)];
//    _adBanner.delegate = self;
//}

#pragma mark - TABLE DELEGATE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCellId" forIndexPath:indexPath];
    
    //Get data
    NSDictionary *objDic = [_arrData objectAtIndex:indexPath.row];
    
    //Excute time
    unsigned long long timeNum = [Common convertFromString:objDic[keyCreatedAdd]];
    NSString *strDate = [Common returnStringFromInterval:timeNum];
    NSArray *arrDateString = [strDate componentsSeparatedByString:@" "];
    if ([arrDateString count] > 1) {
        cell.lblTime.text = [NSString stringWithFormat:@"%@\n%@", [arrDateString objectAtIndex:0], [arrDateString objectAtIndex:1]];
    } else {
        cell.lblTime.text = @"";
    }
    cell.lblScore.text = objDic[keyNumScore];
    cell.imvStars.contentMode = UIViewContentModeScaleAspectFit;
    cell.imvStars.image = [UIImage imageNamed:@"star_0"];
    [Common setStarToview:[Common calScoreStar:[Common convertFromString:objDic[keyNumScore]]] andImgView:cell.imvStars andLabelGoodBad:nil];
    cell.btMore.tag = indexPath.row;
    [cell.btMore addTarget:self action:@selector(actionMore:) forControlEvents:UIControlEventTouchUpInside];
    [Common addBottomBorderWithColor:cell.contentView andColor:[UIColor lightGrayColor] andWidth:0.5];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    indexSelecting = (int)indexPath.row;
    [self performSegueWithIdentifier:@"segueToResultFromHistory" sender:nil];
}

#pragma mark - ACTION
- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) actionMore:(UIButton *) bt {
    indexSelecting = (int)bt.tag;
    [self performSegueWithIdentifier:@"segueToResultFromHistory" sender:nil];
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
//        }
//        
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        
//        // Assumes the banner view is just off the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, -heightAdsBanner);
//        [Common changeHeight:_tblView andHeight:_tblView.frame.size.height - heightAdsBanner];
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
//        [Common changeHeight:_tblView andHeight:_tblView.frame.size.height + heightAdsBanner];
//        
//        [UIView commitAnimations];
//        
//        _bannerIsVisible = NO;
//    }
//}

@end
