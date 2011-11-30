//
//  FilmViewController.m
//  Rolodex
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FilmViewController.h"
#import "ArticleSlideView.h"

@implementation FilmViewController

#pragma mark - Init
- (id)initWithConfig:(NSDictionary *)config {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    // Configure rolodex parameters
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _filmData = [[NSMutableArray alloc] initWithCapacity:1];
  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_filmData);
  
  [super dealloc];
}

#pragma mark - View Config
- (UIView *)baseBackgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundWeave.jpg"]] autorelease];
  return bgView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Film View
  _filmView = [[PSFilmView alloc] initWithFrame:self.view.bounds];
  _filmView.autoresizingMask = ~UIViewAutoresizingNone;
  _filmView.filmViewDelegate = self;
  _filmView.filmViewDataSource = self;
  [self.view addSubview:_filmView];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithImage:[UIImage imageNamed:@"IconMenu.png"] withTarget:APP_DELEGATE action:@selector(slide) width:50.0 height:30.0 buttonType:BarButtonTypeNormal];
  
  // TEST
  
  
//  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"connections" ofType:@"json"];
//  NSData *fixtureData = [NSData dataWithContentsOfFile:filePath];
//  NSDictionary *connections = [fixtureData objectFromJSONData];
  
//  [_cardData addObjectsFromArray:[connections objectForKey:@"values"]];
  
  // Setup some sample cards
  //  [_cardData addObject:@"test card 1"];
  //  [_cardData addObject:@"test card 2"];
  //  [_cardData addObject:@"test card 3"];
  //  [_cardData addObject:@"test card 4"];
  //  [_cardData addObject:@"test card 5"];
  //  [_cardData addObject:@"test card 6"];
  //  [_cardData addObject:@"test card 7"];
  
  [_filmView reloadSlides];
}

#pragma mark - PSFilmViewDataSource
- (NSInteger)numberOfSlidesInFilmView:(PSFilmView *)filmView {
  return 0;
}

- (PSSlideView *)filmView:(PSFilmView *)filmView slideAtIndex:(NSInteger)index {
  ArticleSlideView *slideView = nil;
  slideView = [filmView dequeueReusableSlideView];
  if (!slideView) {
    slideView = [[[ArticleSlideView alloc] initWithFrame:filmView.bounds] autorelease];
    slideView.delegate = filmView;
    slideView.scrollsToTop = NO;
    slideView.backgroundColor = [UIColor clearColor];
  }
  // Configure Slide View
  
  return slideView;
}

@end
