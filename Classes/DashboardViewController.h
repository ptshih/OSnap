//
//  DashboardViewController.h
//  OSnap
//
//  Created by Peter Shih on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PSBaseViewController.h"

@class DashView;

@interface DashboardViewController : PSBaseViewController {
  UIScrollView *_scrollView;
  DashView *_featuredView;
  DashView *_funnyView;
  DashView *_cuteView;
  DashView *_coolView;
  
  NSMutableArray *_featuredItems;
}

@end
