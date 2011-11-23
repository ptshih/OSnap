//
//  ProfileViewController.m
//  Rolodex
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark - View Config
- (UIView *)backgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundBlueprint.jpg"]] autorelease];
  return bgView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu.png"] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(slide)];
  
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"LOL" style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(slide)];
}

@end
