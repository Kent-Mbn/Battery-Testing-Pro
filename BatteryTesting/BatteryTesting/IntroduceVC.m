//
//  IntroduceVC.m
//  BatteryTesting
//
//  Created by CHAU HUYNH on 7/14/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "IntroduceVC.h"

@interface IntroduceVC ()

@end

@implementation IntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageContents = @[MSS_INTRODUCE_1, MSS_INTRODUCE_2, MSS_INTRODUCE_3];
    _pageNameImgs = @[MSS_NAME_IMAGE_INTRODEUCE_1, MSS_NAME_IMAGE_INTRODEUCE_2, MSS_NAME_IMAGE_INTRODEUCE_3];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewIntroduceController"];
    self.pageViewController.dataSource = self;
    
    PageIntroduceContent *pageIntroViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[pageIntroViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.backgroundColor = MASTER_COLOR;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view addSubview:_btSkip];
    [self.view addSubview:_imvHeader];
    [self.view bringSubviewToFront:_btSkip];
    [self.view bringSubviewToFront:_imvHeader];
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

- (PageIntroduceContent *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_pageContents count] == 0) || (index >= [_pageContents count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageIntroduceContent *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageIntroduceContent"];
    pageContentViewController.strContent = _pageContents[index];
    pageContentViewController.nameImg = _pageNameImgs[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageIntroduceContent*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageIntroduceContent*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_pageContents count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_pageContents count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - ACTIONS

- (IBAction)actionSkip:(id)sender {
    AppDelegate *delegate = APP_DELEGATE;
    [delegate setRootViewHomeWithCompletion:^{
        
    }];
}
@end
