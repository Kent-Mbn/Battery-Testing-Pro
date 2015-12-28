//
//  PageIntroduceContent.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 7/14/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface PageIntroduceContent : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgIntro;
@property NSUInteger pageIndex;
@property NSString *strContent;
@property NSString *nameImg;

@end
