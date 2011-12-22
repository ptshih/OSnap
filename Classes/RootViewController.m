//
//  RootViewController.m
//  OSnap
//
//  Created by Peter Shih on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MenuViewController.h"
#import "DashboardViewController.h"
#import "LoginViewController.h"

@implementation RootViewController

- (void)viewDidUnload {
  RELEASE_SAFELY(_drawerController);
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_drawerController);
  [super dealloc];
}

- (void)loadView {
  // View Controllers
  MenuViewController *lvc = [[[MenuViewController alloc] initWithNibName:nil bundle:nil] autorelease];
  MenuViewController *rvc = [[[MenuViewController alloc] initWithNibName:nil bundle:nil] autorelease];
  DashboardViewController *dvc = [[[DashboardViewController alloc] initWithNibName:nil bundle:nil] autorelease];
  
  // PS Navigation Controller
//  UINavigationController *nc = [[[[[NSBundle mainBundle] loadNibNamed:@"PSNavigationController" owner:self options:nil] lastObject] retain] autorelease];
//  nc.viewControllers = [NSArray arrayWithObject:dvc];
  
  PSNavigationController *nc = [[PSNavigationController alloc] initWithRootViewController:dvc];
  
  _drawerController = [[PSDrawerController alloc] initWithRootViewController:nc leftViewController:lvc rightViewController:rvc];
  
  [nc release];
  
  _drawerController.view.frame = APP_BOUNDS;
  self.view = _drawerController.view;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (!self.childViewControllers) {
    [_drawerController viewWillAppear:animated];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (!self.childViewControllers) {
    [_drawerController viewDidAppear:animated];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  if (!self.childViewControllers) {
    [_drawerController viewWillDisappear:animated];
  }
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  if (!self.childViewControllers) {
    [_drawerController viewDidDisappear:animated];
  }
}

@end
