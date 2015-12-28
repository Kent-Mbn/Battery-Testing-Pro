//
//  DetailResultVC.m
//  BatteryTesting
//
//  Created by CHAU HUYNH on 10/22/15.
//  Copyright © 2015 CHAU HUYNH. All rights reserved.
//

#import "DetailResultVC.h"

@interface DetailResultVC ()

@end

@implementation DetailResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGUIs];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - FUNCTIONS
- (void) initData {
    
}

- (void) initGUIs {
    //Set background color for super view
    self.view.backgroundColor = MASTER_COLOR;
    _viewHeader.backgroundColor = MASTER_COLOR;
    
    //Set frame for Percent View
    int heightOfLabelHeader = 60;
    int heightViewVideo = ([Common heightScreen] - _viewHeader.frame.size.height - _viewBottomInfor.frame.size.height - heightOfLabelHeader);
    
    [Common changeHeight:_viewPercentOut andHeight:heightViewVideo/1.2];
    [Common changeWidth:_viewPercentOut andWidth:heightViewVideo/1.2];
    
    float heightForPercent = ((([Common heightScreen] - _viewBottomInfor.frame.size.height) - 64 - heightOfLabelHeader) - _viewPercentOut.frame.size.height) / 2;
    [Common changeY:_viewPercentOut andY:heightForPercent + 64 + heightOfLabelHeader];
    [Common changeX:_viewPercentOut andX:[Common widthScreen]/2 - _viewPercentOut.frame.size.width/2];
    [Common circleView:_viewPercentOut];
    
    //Set frame of label header
    [Common changeY:_lblHeader andY:64];
    [Common changeHeight:_lblHeader andHeight:heightOfLabelHeader + heightForPercent];
    [Common addBottomBorderWithColor:_viewHeader andColor:[UIColor whiteColor] andWidth:1.0f];
    
    //Set position for indicator
    [Common changeY:_indicatorLoadPercent andY:(([Common heightScreen] - 64 - _viewBottomInfor.frame.size.height)/2 + 64 - (_indicatorLoadPercent.frame.size.height/2))];
    
    //Set color for percent value
    _viewPercentIn.backgroundColor = COLOR_VALUE_PERCENT;
    _viewPercentOut.backgroundColor = [UIColor whiteColor];
    
    //Set 0%
    [Common changeHeight:_viewPercentIn andHeight:0];
    [Common changeY:_viewPercentIn andY:_viewPercentOut.frame.size.height - ([Common widthScreen] / widthExiplonCircle)];
    
    //Hide all percent and stars
    _lblHeader.hidden = true;
    _viewPercentOut.hidden = true;
    _lblStarsText.hidden = true;
    _imvStars.hidden = true;
    [_indicatorLoadPercent startAnimating];
    [_indicatorLoadStars startAnimating];

}

- (void) setViewAnimation:(int) percentValue {
    
    _indicatorLoadPercent.hidden = true;
    _viewPercentOut.hidden = false;
    
    float heightOfFrame = (_viewPercentOut.frame.size.height - ([Common widthScreen] / widthExiplonCircle * 2)) * percentValue / 100;
    [UIView animateWithDuration:2 animations:^{
        [Common changeHeight:_viewPercentIn andHeight:heightOfFrame];
        [Common changeY:_viewPercentIn andY:(_viewPercentOut.frame.size.height - ([Common widthScreen] / widthExiplonCircle) - heightOfFrame)];
    } completion:^(BOOL finished) {
        _lblHeader.hidden = false;
        _lblHeader.text = [NSString stringWithFormat:@"%@ %d%%", MSS_TEXT_RESULT, percentValue];
        [Common zoom1xAnimation:_lblHeader];
        
        _indicatorLoadStars.hidden = true;
        _imvStars.hidden = false;
        _lblStarsText.hidden = false;
        [Common setStarToview:5 andImgView:_imvStars andLabelGoodBad:_lblStarsText];
        [Common zoom1xAnimation:_imvStars];
        [Common zoom1xAnimation:_lblStarsText];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)actionShare:(id)sender {
    [self setViewAnimation:70];
}
@end
