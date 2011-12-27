//
//  DashboardViewController.h
//  OSnap
//
//  Created by Peter Shih on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PSBaseViewController.h"

@class DashSingleView;
@class DashMultiView;

@interface DashboardViewController : PSBaseViewController {
  UIScrollView *_scrollView;
  DashSingleView *_featuredView;
  DashMultiView *_funnyView;
  DashMultiView *_cuteView;
  DashMultiView *_coolView;
  
  NSMutableArray *_featuredItems;
}

@end
