//
//  DetailResultVC.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 10/22/15.
//  Copyright © 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "Common.h"

@interface DetailResultVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewPercentOut;
@property (weak, nonatomic) IBOutlet UIView *viewPercentIn;

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

@property (weak, nonatomic) IBOutlet UIView *viewBottomInfor;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoadPercent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoadStars;
@property (weak, nonatomic) IBOutlet UILabel *lblStarsText;
@property (weak, nonatomic) IBOutlet UIImageView *imvStars;


- (IBAction)actionCancel:(id)sender;
- (IBAction)actionShare:(id)sender;


@end
