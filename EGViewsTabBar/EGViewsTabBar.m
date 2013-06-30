//
//  EGViewsTabBar.m
//  deviantAPP
//
//  Created by Eli Ganem on 14/5/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "EGViewsTabBar.h"
#import <QuartzCore/QuartzCore.h>

#define TAB_IMAGES_GAP 30
#define TAB_IMAGES_PADDING 15

@implementation EGViewsTabBar

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<EGViewsTabBarDelegate>)pdelegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = pdelegate;
        selectedTab = -1;
        NSAssert([pdelegate respondsToSelector:@selector(viewsTabBarNumberOfTabs:)], @"Your delegate must respond to the viewsTabBarNumberOfTabs: selector");
        tabAmount = [pdelegate viewsTabBarNumberOfTabs:self];
        
        // this array contains pointers to all our views.
        // value of [NSNull null] means that this view hasn't been loaded yet
        // if there's a memory warning, you should call the clearCache method to clear this array
        tabViews = [[NSMutableArray alloc] initWithCapacity:tabAmount];
        for (int i=0; i<tabAmount; i++)
        {
            tabViews[i] = [NSNull null];
        }
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    // the main view that contains the tab bar, the icons and the user-created views
    [self createContentView];
    
    // the top bar
    [self createTabBar];
    
    // the icons on the bar itself
    [self createTabButtons];
}

// the main view that contains the tab bar, the icons and the user-created views
- (void)createContentView
{
    contentView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:contentView];
}

// the top bar
- (void)createTabBar
{
    CGFloat barHeight = TAB_IMAGES_PADDING * 2 + 30;
    if ([delegate respondsToSelector:@selector(viewsTabBarHeight:)])
    {
        barHeight = [delegate viewsTabBarHeight:self];
    }
    
    // TabsView is the top bar
    CGRect tabBarRect = CGRectMake(0, 0, self.frame.size.width, barHeight);
    tabsView = [[TabsView alloc] initWithFrame:tabBarRect];
    tabsView.backgroundColor = [UIColor clearColor];
    
    // if there's a background image defined, it overrides the background color
    if ([delegate respondsToSelector:@selector(viewsTabBarBackgroundImage:)])
    {
        tabsView.barBackgroundImage = [delegate viewsTabBarBackgroundImage:self];
    }
    else if ([delegate respondsToSelector:@selector(viewsTabBarBackgroundColor:)])
    {
        tabsView.barBackgroundColor = [delegate viewsTabBarBackgroundColor:self];
    }
    
    tabsView.layer.shadowOffset = CGSizeMake(0, 2);
    tabsView.layer.shadowOpacity = 0.8;
    [self addSubview:tabsView];
}

// the icons on the bar itself
- (void)createTabButtons
{
    CGFloat imageSize = tabsView.frame.size.height - TAB_IMAGES_PADDING*2;
    CGFloat tabsImagesWidth = imageSize*tabAmount + TAB_IMAGES_GAP*(tabAmount-1);
    CGFloat xValue = (self.frame.size.width - tabsImagesWidth) / 2;
    
    // get the initial selected tab from the delegate. if none defined, then its zero
    int initialTab = 0;
    if ([delegate respondsToSelector:@selector(viewsTabBarInitialTab:)])
    {
        initialTab = [delegate viewsTabBarInitialTab:self];
    }
    
    // create the buttons that causes the tabs to change
    NSAssert([delegate respondsToSelector:@selector(viewsTabBar:imageForTabIndex:)], @"The delegate must respond to the viewsTabBar:imageForTabIndex: selector");
    for (int i=0; i<tabAmount; i++)
    {
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.frame = CGRectMake(xValue, TAB_IMAGES_PADDING, imageSize, imageSize);
        tabButton.tag = i;
        [tabButton setBackgroundImage:[delegate viewsTabBar:self imageForTabIndex:i] forState:UIControlStateNormal];
        [tabButton addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tabsView addSubview:tabButton];
        xValue += imageSize+TAB_IMAGES_GAP;
        if (i==initialTab)
        {
            [self tabClicked:tabButton];
        }
    }
}

- (void)tabClicked:(UIButton*)button
{
    NSAssert([delegate respondsToSelector:@selector(viewsTabBar:viewForTabIndex:)], @"The delegate must respond to the viewsTabBar:viewForTabIndex: selector");
    int newTabIndex = button.tag;
    if (selectedTab != newTabIndex)
    {
        // make the "selection frame" surround the selected button
        tabsView.selectedRect = button.frame;
        
        // remove the previous view
        if (selectedTab != -1)
            [tabViews[selectedTab] removeFromSuperview];
        
        // if the new view is already in our cache - present it. if not, ask for it from the delegate
        if (tabViews[newTabIndex] != [NSNull null])
        {
            [contentView insertSubview:tabViews[newTabIndex] atIndex:0];
        }
        else
        {
            tabViews[newTabIndex] = [delegate viewsTabBar:self viewForTabIndex:newTabIndex];
            [contentView addSubview:tabViews[newTabIndex]];
        }
        
        // update the currently selected tab, so if it's clicked again nothing will happen
        selectedTab = newTabIndex;
    }
    
    if ([self respondsToSelector:@selector(viewsTabBar:didSelectTabNumber:)])
    {
        [delegate viewsTabBar:self didSelectTabNumber:newTabIndex];
    }
}

// this method should be called if there's a memory warning. it removes all the previous views from the cache.
// and can also be called if you want to force a view to reload
- (void)clearCache
{
    for (int i=0; i<tabViews.count; i++)
    {
        if (i != selectedTab)
            tabViews[i] = [NSNull null];
    }
}

@end

@implementation TabsView

@synthesize barBackgroundImage, barBackgroundColor, selectedRect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        barBackgroundImage = nil;
        barBackgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

// this creates the surrounding frame around the selected tab
- (CGMutablePathRef)makeTabsPath:(CGRect)rect
{
    CGMutablePathRef path = CGPathCreateMutable();
    int left = rect.origin.x;
    int top = rect.origin.y;
    int w = rect.size.width;
    int h = rect.size.height;
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0, h);
    CGPathAddLineToPoint(path, NULL, left, h);
    
    CGPathAddArcToPoint(path, NULL, left+5, h, left+5, h-5, 8);
    CGPathAddLineToPoint(path, NULL, left+5, top+5);
    CGPathAddArcToPoint(path, NULL, left+5, top, left+10, top, 12);
    CGPathAddLineToPoint(path, NULL, left+w-10, top);
    CGPathAddArcToPoint(path, NULL, left+w-5, top, left+w-5, top+5, 12);
    CGPathAddLineToPoint(path, NULL, left+w-5, h-5);
    CGPathAddArcToPoint(path, NULL, left+w-5, h, left+w, h, 8);
    
    CGPathAddLineToPoint(path, NULL, self.frame.size.width, h);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width, 0);
    CGPathAddLineToPoint(path, NULL, 0, 0);
    CGPathCloseSubpath(path);
    return path;
}

- (void)drawRect:(CGRect)rect
{
    if (barBackgroundImage != nil)
    {
        barBackgroundColor = [UIColor colorWithPatternImage:barBackgroundImage];
    }
    
    CGPathRef path = [self makeTabsPath:CGRectMake(selectedRect.origin.x - TAB_IMAGES_GAP*0.65,
                                                   selectedRect.origin.y - 10,
                                                   selectedRect.size.width + TAB_IMAGES_GAP*1.3,
                                                   rect.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, barBackgroundColor.CGColor);
    CGContextEOFillPath(context);
    CGContextRestoreGState(context);
    CFRelease(path);
}

// if a new tab is selected, be call "setNeedsDisplay" to redraw the top bar, and show the new tab as clicked
- (void)setSelectedRect:(CGRect)pselectedRect
{
    selectedRect = pselectedRect;
    [self setNeedsDisplay];
}

@end