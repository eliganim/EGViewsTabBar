EGViewsTabBar
=============
EGViewsTabBar is a Tab Bar that works with UIViews instead of UIViewControllers. It looks like this:
<img width=320 src="https://raw.github.com/ganem/EGViewsTabBar/master/Screenshots/screenshot1.png"/>&nbsp;&nbsp;
<img width=320 src="https://raw.github.com/ganem/EGViewsTabBar/master/Screenshots/screenshot2.png"/>

You can customize the amount of tabs, their size, the tab bar height and background color.

Usage
-----
- Add EGViewsTabBar.h and EGViewsTabBar.m to your project
- Import "EGViewsTabBar.h" and conform to the EGViewsTabBarDelegate protocol
- Create a new instance and add it to your view
```ObjectiveC
	EGViewsTabBar *tabbar = [[EGViewsTabBar alloc] initWithFrame:self.view.frame delegate:self];
	[self.view addSubview:tabbar];
```
 
- Implement the required delegate methods

```ObjectiveC
	- (NSInteger)viewsTabBarNumberOfTabs:(EGViewsTabBar*)viewsTabBar;
	- (UIImage*)viewsTabBar:(EGViewsTabBar*)viewsTabBar imageForTabIndex:(NSInteger)index;
	- (UIView*)viewsTabBar:(EGViewsTabBar*)viewsTabBar viewForTabIndex:(NSInteger)index;
```

And you're done!

Additional Info
---------------
- EGViewsTabBar has 2 methods:

This is the only method you should use to create a new instance of EGViewsTabBar
```ObjectiveC
	- (id)initWithFrame:(CGRect)frame delegate:(id<EGViewsTabBarDelegate>)delegate;
```
<br>
EGViewsTabBar caches your views and only asks for them the first time a tab is clicked. The next time you click a tab, the correct view will be loaded from the cache.
You can use this method in order to clear the cache and enforce a reload of all the views.
```ObjectiveC
	- (void)clearCache;
```

- Please note that the views that are returned by viewsTabBar:viewForTabIndex: should have the same frame as the EGViewsTabBar.

License
-------
EGViewsTabBar is available under the MIT license.

Contact
-------
If you find any issues or want to ask for any features, please use GitHub's issues module.
If you're using this control, please let me know: movingapp@gmail.com