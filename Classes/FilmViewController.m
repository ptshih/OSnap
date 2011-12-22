//
//  FilmViewController.m
//  OSnap
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "FilmViewController.h"
#import "ArticleSlideView.h"

@implementation FilmViewController

#pragma mark - Init
- (id)initWithConfig:(NSDictionary *)config {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _filmItems = [[NSMutableArray alloc] initWithCapacity:1];
    self.title = @"Trending";
  }
  return self;
}

- (void)viewDidUnload {
  RELEASE_SAFELY(_filmView);
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_filmItems);
  
  RELEASE_SAFELY(_filmView);
  [super dealloc];
}

#pragma mark - View Config
- (UIColor *)baseBackgroundColor {
  return [UIColor whiteColor];
}

//- (UIView *)baseBackgroundView {
//  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundWeave.jpg"]] autorelease];
//  return bgView;
//}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Setup Views
  [self setupHeader];
  [self setupFooter];
  [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadDataSource];
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

- (void)setupFooter {
  UIImageView *footerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0)];
  footerView.userInteractionEnabled = YES;
  [footerView setImage:[UIImage stretchableImageNamed:@"BackgroundToolbar" withLeftCapWidth:0.0 topCapWidth:1.0]];
  
  NSMutableArray *buttons = [NSMutableArray array];
  
  UIButton *captionButton = [UIButton buttonWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0) andStyle:nil target:self action:@selector(animatedBack)];
  [captionButton setImage:[UIImage imageNamed:@"IconCaptionBlack"] forState:UIControlStateNormal];
  [captionButton setImage:[UIImage imageNamed:@"IconCaptionGray"] forState:UIControlStateHighlighted];
  [buttons addObject:captionButton];
  
  UIButton *upButton = [UIButton buttonWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0) andStyle:nil target:self action:@selector(animatedBack)];
  [upButton setImage:[UIImage imageNamed:@"IconCaptionBlack"] forState:UIControlStateNormal];
  [upButton setImage:[UIImage imageNamed:@"IconCaptionGray"] forState:UIControlStateHighlighted];
  [buttons addObject:upButton];
  
  UIButton *downButton = [UIButton buttonWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0) andStyle:nil target:self action:@selector(animatedBack)];
  [downButton setImage:[UIImage imageNamed:@"IconCaptionBlack"] forState:UIControlStateNormal];
  [downButton setImage:[UIImage imageNamed:@"IconCaptionGray"] forState:UIControlStateHighlighted];
  [buttons addObject:downButton];
  
  __block CGFloat margin = floorf((footerView.width - (32.0 * [buttons count])) / ([buttons count] + 1));
  [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
    button.top = 6.0;
    button.left = margin + (idx * margin) + (idx * 32.0);
    [footerView addSubview:button];
  }];
  
  [self setFooterView:footerView];
  [footerView release];
}

- (void)setupSubviews {
  // Film View
  _filmView = [[PSFilmView alloc] initWithFrame:self.contentView.bounds];
  _filmView.autoresizingMask = ~UIViewAutoresizingNone;
  _filmView.filmViewDelegate = self;
  _filmView.filmViewDataSource = self;
  [self.contentView addSubview:_filmView];
}

#pragma mark - Data Source
- (void)loadDataSource {
  [super loadDataSource];
  
  // TEST
//  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"short_gallery" ofType:@"json"];
//  NSData *fixtureData = [NSData dataWithContentsOfFile:filePath];
//  NSDictionary *connections = [fixtureData objectFromJSONData];
//  [_filmItems addObjectsFromArray:[connections objectForKey:@"gallery"]];
  
  PFQuery *snapsQuery = [PFQuery queryWithClassName:@"Snap"];
  [snapsQuery includeKey:@"caption"];
  [snapsQuery orderByDescending:@"score"];
  
  [snapsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      NSLog(@"Successfully retrieved %d snaps.", objects.count);
      [_filmItems addObjectsFromArray:objects];
      
      // Get Captions
      NSMutableSet *captionIds = [NSMutableSet set];
      for (PFObject *item in _filmItems) {
        if ([item objectForKey:@"captionIds"]) {
          [captionIds addObjectsFromArray:[item objectForKey:@"captionIds"]];
        }
      }
      // Embedded query for captions
      PFQuery *captionsQuery = [PFQuery queryWithClassName:@"Caption"];
      [captionsQuery whereKey:@"objectId" containedIn:[captionIds allObjects]];
      [captionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
          NSLog(@"Successfully retrieved %d captions.", objects.count);
          for (PFObject *caption in objects) {
            [[APP_DELEGATE captionsCache] setObject:caption forKey:[caption objectId]];
          }
          
          [self dataSourceDidLoad];
        } else {
          NSLog(@"Error retrieving captions: %@ %@", error, [error userInfo]);
          [self dataSourceDidError];
        }
      }];
    } else {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
      [self dataSourceDidError];
    }
  }];
}

- (void)dataSourceDidLoad {
  [super dataSourceDidLoad];
  
  [_filmView reloadSlides];
}

- (BOOL)dataIsAvailable {
  return ([_filmItems count] > 0);
}

#pragma mark - PSFilmViewDelegate
- (void)filmViewDidTriggerRefresh:(PSFilmView *)filmView {
  [filmView performSelector:@selector(filmViewDidRefresh) withObject:nil afterDelay:3.0];
//  [filmView filmViewDidRefresh];
}

- (void)filmViewDidTriggerLoadMore:(PSFilmView *)filmView {
  [filmView performSelector:@selector(filmViewDidLoadMore) withObject:nil afterDelay:3.0];
//  [filmView filmViewDidLoadMore];
}

#pragma mark - PSFilmViewDataSource
- (NSInteger)numberOfSlidesInFilmView:(PSFilmView *)filmView {
  return [_filmItems count];
}

//- (CGFloat)filmView:(PSFilmView *)filmView heightForSlideAtIndex:(NSInteger)index {
//  NSDictionary *filmDict = [_filmItems objectAtIndex:index];
//  return [ArticleSlideView heightForObject:filmDict];
//}

- (PSSlideView *)filmView:(PSFilmView *)filmView slideAtIndex:(NSInteger)index {
  ArticleSlideView *slideView = nil;
  slideView = [filmView dequeueReusableSlideView];
  if (!slideView) {
    slideView = [[[ArticleSlideView alloc] initWithFrame:filmView.bounds] autorelease];
    slideView.delegate = filmView;
    slideView.autoresizingMask = ~UIViewAutoresizingNone;
    slideView.scrollsToTop = NO;
    slideView.backgroundColor = [UIColor clearColor];
  }
  // Configure Slide View
//  if (index % 3 == 0) {
//    slideView.slideContentView.backgroundColor = [UIColor redColor];
//  } else if (index % 3 == 1) {
//    slideView.slideContentView.backgroundColor = [UIColor blueColor];
//  } else if (index % 3 == 2) {
//    slideView.slideContentView.backgroundColor = [UIColor greenColor];
//  }
  
  NSDictionary *filmDict = [_filmItems objectAtIndex:index];
  
//  NSDictionary *filmDict = [NSDictionary dictionaryWithObject:@"http://bit.ly/vA2sIL" forKey:@"pictureUrl"];
  
  [slideView fillSlideWithObject:filmDict];
  
  return slideView;
}

- (NSString *)filmView:(PSFilmView *)filmView titleForHeaderAtIndex:(NSInteger)index forState:(PSFilmViewState)state {
  NSString *gesture = (state == PSFilmViewStateIdle) ? @"Pull Down" : @"Release";
  NSString *action = nil;
  if (index == 0) {
    action = @"Refresh";
  } else {
    NSInteger prevIndex = index - 1;
    NSString *prevTitle = [[_filmItems objectAtIndex:prevIndex] objectForKey:@"title"];
    if ([prevTitle notNil]) {
      action = [NSString stringWithFormat:@"View...\r%@", prevTitle];
    } else {
      action = @"View Previous";
    }
  }
  return [NSString stringWithFormat:@"%@ to %@", gesture, action];
}

- (NSString *)filmView:(PSFilmView *)filmView titleForFooterAtIndex:(NSInteger)index forState:(PSFilmViewState)state {
  NSString *gesture = (state == PSFilmViewStateIdle) ? @"Pull Up" : @"Release";
  NSString *action = nil;
  if (index == [_filmItems count] - 1) {
    action = @"Load More";
  } else {
    NSInteger nextIndex = index + 1;
    NSString *nextTitle = [[_filmItems objectAtIndex:nextIndex] objectForKey:@"title"];
    if ([nextTitle notNil]) {
      action = [NSString stringWithFormat:@"View...\r%@", nextTitle];
    } else {
      action = @"View Next";
    }
  }
  return [NSString stringWithFormat:@"%@ to %@", gesture, action];
}

@end
