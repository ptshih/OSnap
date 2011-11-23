//
//  MenuViewController.m
//  Rolodex
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
  RELEASE_SAFELY(_searchField);
}

- (void)dealloc {
  [super dealloc];
  
  // Views
  RELEASE_SAFELY(_searchField);
}

#pragma mark - View Config
- (UIView *)backgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundLeather.jpg"]] autorelease];
  return bgView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Search
  UIView *searchView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0)] autorelease];
  searchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  UIImageView *searchBgView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BackgroundNavigationBar.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]] autorelease];
  searchBgView.autoresizingMask = searchView.autoresizingMask;
  [searchView addSubview:searchBgView];
  
  CGFloat searchWidth = searchView.width - 20;
  _searchField = [[PSSearchField alloc] initWithFrame:CGRectMake(10, 7, searchWidth, 30) style:PSSearchFieldStyleBlack];
  _searchField.delegate = self;
  _searchField.placeholder = @"Search People";
//  [_searchField addTarget:self action:@selector(searchTermChanged:) forControlEvents:UIControlEventEditingChanged];
  [searchView addSubview:_searchField];
  
  [self.view addSubview:searchView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if ([_searchField isFirstResponder]) {
    [_searchField resignFirstResponder];
  }
}

@end
