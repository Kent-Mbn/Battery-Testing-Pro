//
//  HistoryVC.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/10/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryCell.h"
#import "Common.h"
#import "ResultVC.h"
#import <iAd/iAd.h>

@interface HistoryVC : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    int indexSelecting;
    //BOOL _bannerIsVisible;
    //ADBannerView *_adBanner;
}

@property(nonatomic, strong) NSMutableArray *arrData;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalResults;
@property (weak, nonatomic) IBOutlet UIView *viewHeaderTable;
@property (weak, nonatomic) IBOutlet UIView *viewTitleHeader;
- (IBAction)actionCancel:(id)sender;

@end
