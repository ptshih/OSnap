//
//  RootViewController.m
//  OSnap
//
//  Created by Peter Shih on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "PSNavigationController.h"
#import "MenuViewController.h"
#import "DashboardViewController.h"
#import "LoginViewController.h"

#import "TimelineViewController.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.wantsFullScreenLayout = YES;
  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_psNavigationController);
  [super dealloc];
}

- (void)loadView {
  // Setup the main container view
  CGRect frame = [[UIScreen mainScreen] applicationFrame];
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.backgroundColor = [UIColor blackColor];
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = view;
  [view release];
  
  // View Controllers
  MenuViewController *lvc = [[[MenuViewController alloc] initWithNibName:nil bundle:nil] autorelease];
  MenuViewController *rvc = [[[MenuViewController alloc] initWithNibName:nil bundle:nil] autorelease];
  DashboardViewController *dvc = [[[DashboardViewController alloc] initWithNibName:nil bundle:nil] autorelease];
  TimelineViewController *tvc = [[[TimelineViewController alloc] initWithNibName:nil bundle:nil] autorelease];
  
  // PS Navigation Controller
//  UINavigationController *nc = [[[[[NSBundle mainBundle] loadNibNamed:@"PSNavigationController" owner:self options:nil] lastObject] retain] autorelease];
//  nc.viewControllers = [NSArray arrayWithObject:dvc];
  
  _psNavigationController = [[PSNavigationController alloc] initWithRootViewController:tvc];
  [self.view addSubview:_psNavigationController.view];


}

- (void)test {
  BOOL sb = [UIApplication sharedApplication].statusBarHidden;
  [[UIApplication sharedApplication] setStatusBarHidden:!sb];
}


//- (void)viewWillAppear:(BOOL)animated
//{
//  [super viewWillAppear:animated];
//  if (!self.childViewControllers) {
//    [_drawerController viewWillAppear:animated];
//  }
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//  [super viewDidAppear:animated];
//  if (!self.childViewControllers) {
//    [_drawerController viewDidAppear:animated];
//  }
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//  [super viewWillDisappear:animated];
//  if (!self.childViewControllers) {
//    [_drawerController viewWillDisappear:animated];
//  }
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//  [super viewDidDisappear:animated];
//  if (!self.childViewControllers) {
//    [_drawerController viewDidDisappear:animated];
//  }
//}

@end
