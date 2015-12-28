//
//  IntroduceVC.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 7/14/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageIntroduceContent.h"
#import "Define.h"
#import "AppDelegate.h"

@interface IntroduceVC : UIViewController<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageContents;
@property (strong, nonatomic) NSArray *pageNameImgs;
@property (weak, nonatomic) IBOutlet UIImageView *imvHeader;
@property (weak, nonatomic) IBOutlet UIButton *btSkip;

- (IBAction)actionSkip:(id)sender;

@end
