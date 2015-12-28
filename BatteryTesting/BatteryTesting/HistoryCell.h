//
//  HistoryCell.h
//  BatteryTesting
//
//  Created by CHAU HUYNH on 6/10/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UIButton *btMore;
@property (weak, nonatomic) IBOutlet UIImageView *imvStars;


@end
