//
//  DashboardViewController.m
//  OSnap
//
//  Created by Peter Shih on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashboardViewController.h"

#define MARGIN 10.0

@implementation DashboardViewController

#pragma mark - Init
- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _featuredItems = [[NSMutableArray alloc] initWithCapacity:1];
    self.title = @"Dashboard";
  }
  return self;
}

- (void)viewDidUnload {
  // Views
  RELEASE_SAFELY(_centerView);
  RELEASE_SAFELY(_leftView);
  RELEASE_SAFELY(_rightView);
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_featuredItems);
  
  // Views
  RELEASE_SAFELY(_centerView);
  RELEASE_SAFELY(_leftView);
  RELEASE_SAFELY(_rightView);
  [super dealloc];
}

#pragma mark - View Config
- (UIColor *)baseBackgroundColor {
  return [UIColor whiteColor];
}

#pragma mark - View
- (void)loadView {
  UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 416.0)] autorelease];
  [self setView:view];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [(PSNavigationBar *)[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"BackgroundNavigationBar.png"]];
  
   self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithImage:[UIImage imageNamed:@"ButtonNavList.png"] highlightedImage:[UIImage imageNamed:@"ButtonNavListHighlighted.png"] withTarget:self.drawerController action:@selector(slideFromLeft) width:40.0 height:30.0 buttonType:BarButtonTypeNone];
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonWithImage:[UIImage imageNamed:@"ButtonNavList.png"] highlightedImage:[UIImage imageNamed:@"ButtonNavListHighlighted.png"] withTarget:self.drawerController action:@selector(slideFromRight) width:40.0 height:30.0 buttonType:BarButtonTypeNone];

  // Setup Views
  [self setupSubviews];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadDataSource];
}

#pragma mark - Config Subviews
- (void)setupSubviews {
  CGFloat topHeight = 200.0;
  CGFloat bottomHeight = 186.0;
  _centerView = [[[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, 300.0, topHeight)] autorelease];
  _centerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
  _centerView.layer.borderWidth = 1.0;
  _leftView = [[[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN + topHeight + MARGIN, 145.0, bottomHeight)] autorelease];
  _leftView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
  _leftView.layer.borderWidth = 1.0;
  _rightView = [[[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN + 145.0 + MARGIN, MARGIN + topHeight + MARGIN, 145.0, bottomHeight)] autorelease];
  _rightView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
  _rightView.layer.borderWidth = 1.0;
  
  [self.view addSubview:_centerView];
  [self.view addSubview:_leftView];
  [self.view addSubview:_rightView];
  
  // Center View
  UIImageView *centerImageView = [[[UIImageView alloc] initWithFrame:_centerView.bounds] autorelease];
  centerImageView.autoresizingMask = _centerView.autoresizingMask;
  centerImageView.contentMode = UIViewContentModeScaleAspectFill;
  [_centerView addSubview:centerImageView];
  
  // Left View
  UIImageView *leftImageView = [[[UIImageView alloc] initWithFrame:_leftView.bounds] autorelease];
  leftImageView.autoresizingMask = _leftView.autoresizingMask;
  leftImageView.contentMode = UIViewContentModeScaleAspectFill;
  [_leftView addSubview:leftImageView];
  
  // Right View
  UIImageView *rightImageView = [[[UIImageView alloc] initWithFrame:_rightView.bounds] autorelease];
  rightImageView.autoresizingMask = _rightView.autoresizingMask;
  rightImageView.contentMode = UIViewContentModeScaleAspectFill;
  [_rightView addSubview:rightImageView];
  
  UITapGestureRecognizer *gr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testPush)] autorelease];
  [centerImageView addGestureRecognizer:gr];
  centerImageView.userInteractionEnabled = YES;
  
  UITapGestureRecognizer *grpop = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testPop)] autorelease];
  [rightImageView addGestureRecognizer:grpop];
  rightImageView.userInteractionEnabled = YES;
}

- (void)testPush {
  DashboardViewController *vc = [[DashboardViewController alloc] initWithNibName:nil bundle:nil];
  [self.navController pushViewController:vc animated:YES];
}

- (void)testPop {
  [self.navController popViewControllerAnimated:YES];
}

#pragma mark - Data Source
- (void)loadDataSource {
  [super loadDataSource];
  
  PFQuery *snapsQuery = [PFQuery queryWithClassName:@"Snap"];
  snapsQuery.limit = [NSNumber numberWithInteger:3];
  [snapsQuery orderByDescending:@"score"];

  [snapsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      NSLog(@"Successfully retrieved %d scores.", objects.count);
      [_featuredItems addObjectsFromArray:objects];
      [self dataSourceDidLoad];
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
      [self dataSourceDidError];
    }
  }];
}

- (void)dataSourceDidLoad {
  [super dataSourceDidLoad];
  
  // Update the view
  if ([self dataIsAvailable]) {
    // Make sure we have at least 3 snaps
    if ([_featuredItems count] == 3) {
       [_featuredItems enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop) {
         switch (idx) {
           case 0:
           {
             NSString *centerSource = [obj objectForKey:@"source"];
             if (centerSource) {
               UIImageView *centerImageView = [_centerView.subviews firstObject];
               [centerImageView setImageWithURL:[NSURL URLWithString:centerSource] placeholderImage:nil];
             }
             break;
           }
           case 1:
           {
             NSString *leftSource = [obj objectForKey:@"source"];
             if (leftSource) {
               UIImageView *leftImageView = [_leftView.subviews firstObject];
               [leftImageView setImageWithURL:[NSURL URLWithString:leftSource] placeholderImage:nil];
             }
             break;
           }
           case 2:
           {
             NSString *rightSource = [obj objectForKey:@"source"];
             if (rightSource) {
               UIImageView *rightImageView = [_rightView.subviews firstObject];
               [rightImageView setImageWithURL:[NSURL URLWithString:rightSource] placeholderImage:nil];
             }
             break;
           }
           default:
             break;
         }
       }];
    }
  }
}

- (BOOL)dataIsAvailable {
  return ([_featuredItems count] > 0);
}

@end
