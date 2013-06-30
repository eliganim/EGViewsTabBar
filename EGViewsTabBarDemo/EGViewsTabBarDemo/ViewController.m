//
//  ViewController.m
//  EGViewsTabBarDemo
//
//  Created by Eli Ganem on 30/6/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    EGViewsTabBar *tabbar = [[EGViewsTabBar alloc] initWithFrame:self.view.frame delegate:self];
    [self.view addSubview:tabbar];
}

- (NSInteger)viewsTabBarNumberOfTabs:(EGViewsTabBar*)viewsTabBar
{
    return 3;
}

- (UIImage*)viewsTabBar:(EGViewsTabBar*)viewsTabBar imageForTabIndex:(NSInteger)index
{
    NSString *imageName = [NSString stringWithFormat:@"pic%d.png", index];
    return [UIImage imageNamed:imageName];
}

- (UIView*)viewsTabBar:(EGViewsTabBar*)viewsTabBar viewForTabIndex:(NSInteger)index
{
    UIView *viewToShow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    if (index == 0)
    {
        viewToShow.backgroundColor = [UIColor blueColor];
    }
    else if (index == 1)
    {
        viewToShow.backgroundColor = [UIColor brownColor];
    }
    else
    {
        viewToShow.backgroundColor = [UIColor darkGrayColor];
    }
    return viewToShow;
}

- (void)viewsTabBar:(EGViewsTabBar *)viewsTabBar didSelectTabNumber:(NSInteger)tabNumber
{
    NSLog(@"Selected tab number %d", tabNumber);
}

- (UIColor*)viewsTabBarBackgroundColor:(EGViewsTabBar*)viewsTabBar
{
    return [UIColor lightGrayColor];
}

@end
