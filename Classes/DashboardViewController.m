//
//  DashboardViewController.m
//  OSnap
//
//  Created by Peter Shih on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashboardViewController.h"
#import "FilmViewController.h"

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

//- (UIView *)baseBackgroundView {
//  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundCloth.jpg"]] autorelease];
//  return bgView;
//}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Setup Views
  [self setupHeader];
  [self setupSubviews];
}

- (void)test {
  [self.drawerController slideFromLeft];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadDataSource];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

#pragma mark - Config Subviews
- (void)setupHeader {
  UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0)];
  headerView.userInteractionEnabled = YES;
  [headerView setImage:[UIImage stretchableImageNamed:@"BackgroundNavigationBar" withLeftCapWidth:0.0 topCapWidth:1.0]];
  
  UIButton *leftButton = [UIButton buttonWithFrame:CGRectMake(10.0, 6.0, 30.0, 30.0) andStyle:nil target:self action:@selector(test)];
  [leftButton setImage:[UIImage imageNamed:@"ButtonNavList"] forState:UIControlStateNormal];
  [leftButton setImage:[UIImage imageNamed:@"ButtonNavListHighlighted"] forState:UIControlStateHighlighted];
  [headerView addSubview:leftButton];
  
  [self setHeaderView:headerView];
  [headerView release];
}

- (void)setupSubviews {
  CGFloat topHeight = 200.0;
  CGFloat bottomHeight = 186.0;
  _centerView = [[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, 300.0, topHeight)];
  _centerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
  _centerView.layer.borderWidth = 1.0;
  _leftView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN + topHeight + MARGIN, 145.0, bottomHeight)];
  _leftView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
  _leftView.layer.borderWidth = 1.0;
  _leftView.clipsToBounds = YES;
  _rightView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN + 145.0 + MARGIN, MARGIN + topHeight + MARGIN, 145.0, bottomHeight)];
  _rightView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
  _rightView.layer.borderWidth = 1.0;
  _rightView.clipsToBounds = YES;
  
  [self.contentView addSubview:_centerView];
  [self.contentView addSubview:_leftView];
  [self.contentView addSubview:_rightView];
  
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
  
  UITapGestureRecognizer *gr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFilm)] autorelease];
  [centerImageView addGestureRecognizer:gr];
  centerImageView.userInteractionEnabled = YES;
  
  UITapGestureRecognizer *grpop = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testPop)] autorelease];
  [rightImageView addGestureRecognizer:grpop];
  rightImageView.userInteractionEnabled = YES;
}

- (void)showFilm {
  FilmViewController *vc = [[FilmViewController alloc] initWithNibName:nil bundle:nil];
  [self.psNavigationController pushViewController:vc animated:YES];
  [vc release];
}

- (void)testPop {
  [self.psNavigationController popViewControllerAnimated:YES];
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
