//
//  DashboardViewController.m
//  OSnap
//
//  Created by Peter Shih on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashboardViewController.h"
#import "FilmViewController.h"

#import "DashView.h"

#define MARGIN 10.0

@interface DashboardViewController (Private)

- (void)setupHiddenHeader;

@end

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
  RELEASE_SAFELY(_scrollView);
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_featuredItems);
  
  // Views
  RELEASE_SAFELY(_scrollView);
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
  [self setupHiddenHeader];
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
  
  UIButton *leftButton = [UIButton buttonWithFrame:CGRectMake(10.0, 6.0, 30.0, 30.0) andStyle:nil target:self action:@selector(animatedBack)];
  [leftButton setImage:[UIImage imageNamed:@"IconBackBlack"] forState:UIControlStateNormal];
  [leftButton setImage:[UIImage imageNamed:@"IconBackGray"] forState:UIControlStateHighlighted];
  [headerView addSubview:leftButton];
  
  [self setHeaderView:headerView];
  [headerView release];
}

- (void)setupHiddenHeader {

}

- (void)setupSubviews {
  _scrollView = [[UIScrollView alloc] initWithFrame:_contentView.bounds];
  
  /**
   Categories / Sections
   1. Featured / Best of OSnap (4 pics, 1 shown at a time)
   2. Funny (4 pics shown at time)
   3. Cute (4 pics shown at time)
   4. Cool (4 pics shown at time)
   */
  
  CGFloat top = 0.0;
  UIImageView *separatorView = nil;
  
  _featuredView = [[[DashView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 260.0)] autorelease];
  _featuredView.top = top;
  [_scrollView addSubview:_featuredView];
  
  [_featuredView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFilm)] autorelease]];
  
  top = _featuredView.bottom;
  
  separatorView = [[[UIImageView alloc] initWithImage:[UIImage stretchableImageNamed:@"HorizontalLine" withLeftCapWidth:2 topCapWidth:0]] autorelease];
  separatorView.frame = CGRectMake(10.0, top, _scrollView.width - 20.0, 1.0);
  [_scrollView addSubview:separatorView];
  
  top = separatorView.bottom;
  
  _funnyView = [[[DashView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 120.0)] autorelease];
  _funnyView.top = top;
  [_scrollView addSubview:_funnyView];
  
  top = _funnyView.bottom;
  
  separatorView = [[[UIImageView alloc] initWithImage:[UIImage stretchableImageNamed:@"HorizontalLine" withLeftCapWidth:2 topCapWidth:0]] autorelease];
  separatorView.frame = CGRectMake(10.0, top, _scrollView.width - 20.0, 1.0);
  [_scrollView addSubview:separatorView];
  
  top = separatorView.bottom;
  
  _cuteView = [[[DashView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 120.0)] autorelease];
  _cuteView.top = top;
  [_scrollView addSubview:_cuteView];
  
  top = _cuteView.bottom;
  
  separatorView = [[[UIImageView alloc] initWithImage:[UIImage stretchableImageNamed:@"HorizontalLine" withLeftCapWidth:2 topCapWidth:0]] autorelease];
  separatorView.frame = CGRectMake(10.0, top, _scrollView.width - 20.0, 1.0);
  [_scrollView addSubview:separatorView];
  
  top = separatorView.bottom;
  
  _coolView = [[[DashView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 120.0)] autorelease];
  _coolView.top = top;
  [_scrollView addSubview:_coolView];
  
  top = _coolView.bottom;
  
  _scrollView.contentSize = CGSizeMake(_contentView.width, top);
  
  // Add all subviews to content view
  [_contentView addSubview:_scrollView];
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
  snapsQuery.limit = [NSNumber numberWithInteger:4];
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
    
    [_featuredView fillDashSectionWithObject:[_featuredItems lastObject]];
    [_funnyView fillDashSectionWithObject:[_featuredItems objectAtIndex:1]];
    [_cuteView fillDashSectionWithObject:[_featuredItems objectAtIndex:2]];
    [_coolView fillDashSectionWithObject:[_featuredItems objectAtIndex:0]];
    
    // Make sure we have at least 3 snaps
    if ([_featuredItems count] == 3) {
       [_featuredItems enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop) {
         switch (idx) {
           case 0:
           {
             NSString *centerSource = [obj objectForKey:@"source"];
             if (centerSource) {
             }
             break;
           }
           case 1:
           {
             NSString *leftSource = [obj objectForKey:@"source"];
             if (leftSource) {
             }
             break;
           }
           case 2:
           {
             NSString *rightSource = [obj objectForKey:@"source"];
             if (rightSource) {
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
