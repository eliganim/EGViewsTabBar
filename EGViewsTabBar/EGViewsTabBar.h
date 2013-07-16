//
//  EGViewsTabBar.h
//  deviantAPP
//
//  Created by Eli Ganem on 14/5/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGViewsTabBar, TabsView;

@protocol EGViewsTabBarDelegate <NSObject>

@required
// Self explenatory. The number of tabs in the tab bar
- (NSInteger)viewsTabBarNumberOfTabs:(EGViewsTabBar*)viewsTabBar;

// Should return the image to show inside the tab button at the specified index
- (UIImage*)viewsTabBar:(EGViewsTabBar*)viewsTabBar imageForTabIndex:(NSInteger)index;

// Should return the view that is connected to the tab at the specified index
- (UIView*)viewsTabBar:(EGViewsTabBar*)viewsTabBar viewForTabIndex:(NSInteger)index;

@optional
// The initial tab to present when the tab bar is loaded. Default is 0 (first tab)
- (NSInteger)viewsTabBarInitialTab:(EGViewsTabBar *)viewsTabBar;

// You can specify a background color to the tab bar. Default is lightGrayColor
- (UIColor*)viewsTabBarBackgroundColor:(EGViewsTabBar*)viewsTabBar;

// You can specify more than one background colors to be used as a gradient
// If this is defined, it will ignore the viewsTabBarBackgroundColor: selector
- (NSArray*)viewsTabBarBackgroundGradient:(EGViewsTabBar*)viewsTabBar;

// You can specify a background image to the tab bar.
// If this is defined, it will ignore the viewsTabBarBackgroundGradient and viewsTabBarBackgroundColor: selectors
- (UIImage*)viewsTabBarBackgroundImage:(EGViewsTabBar*)viewsTabBar;

// The tab bar height. This will affect the size of the tab bar image. Default is 60
- (CGFloat)viewsTabBarHeight:(EGViewsTabBar*)viewsTabBar;

// Notifies the delegate after a tab has been clicked
- (void)viewsTabBar:(EGViewsTabBar*)viewsTabBar didSelectTabNumber:(NSInteger)tabNumber;

@end

@interface EGViewsTabBar : UIView
{
    TabsView *tabsView;
    UIView *contentView;
    NSMutableArray *tabViews;
    int tabAmount, selectedTab;
}

@property (nonatomic, assign) id<EGViewsTabBarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<EGViewsTabBarDelegate>)delegate;
- (void)clearCache;

@end


@interface TabsView : UIView
@property (nonatomic, strong) NSArray *gradientColors;
@property (nonatomic, strong) UIImage *barBackgroundImage;
@property (nonatomic, strong) UIColor *barBackgroundColor;
@property (nonatomic, assign) CGRect selectedRect;
@end