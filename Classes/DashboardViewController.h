//
//  DashboardViewController.h
//  OSnap
//
//  Created by Peter Shih on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PSBaseViewController.h"

@interface DashboardViewController : PSBaseViewController {
  UIScrollView *_centerView;
  UIView *_leftView;
  UIView *_rightView;
  
  NSMutableArray *_featuredItems;
}

@end
