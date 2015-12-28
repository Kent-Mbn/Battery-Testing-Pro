//
//  PageIntroduceContent.m
//  BatteryTesting
//
//  Created by CHAU HUYNH on 7/14/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "PageIntroduceContent.h"

@interface PageIntroduceContent ()

@end

@implementation PageIntroduceContent

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lblContent.text = self.strContent;
    _imgIntro.image = [UIImage imageNamed:self.nameImg];
    self.view.backgroundColor = MASTER_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionSkip:(id)sender {
}
@end
