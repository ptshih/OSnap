//
//  RolodexViewController.m
//  OSnap
//
//  Created by Peter Shih on 11/23/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "RolodexViewController.h"


@implementation RolodexViewController

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
    _cardData = [[NSMutableArray alloc] initWithCapacity:1];
  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_cardData);
  
  [super dealloc];
}

#pragma mark - View Config
- (UIView *)baseBackgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundDarkWood.jpg"]] autorelease];
  return bgView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [(PSNavigationBar *)[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"BackgroundNavigationBar.png"]];
  
  // Rolodex View
  _collectionView = [[PSCollectionView alloc] initWithFrame:self.view.bounds];
  _collectionView.autoresizingMask = ~UIViewAutoresizingNone;
  _collectionView.collectionViewDelegate = self;
  _collectionView.collectionViewDataSource = self;
  _collectionView.rowHeight = [CardView cardHeight];
  [self.view addSubview:_collectionView];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithImage:[UIImage imageNamed:@"ButtonNavList.png"] highlightedImage:[UIImage imageNamed:@"ButtonNavListHighlighted.png"] withTarget:self.drawerController action:@selector(slideFromLeft) width:40.0 height:30.0 buttonType:BarButtonTypeNone];
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonWithImage:[UIImage imageNamed:@"ButtonNavList.png"] highlightedImage:[UIImage imageNamed:@"ButtonNavListHighlighted.png"] withTarget:self.drawerController action:@selector(slideFromRight) width:40.0 height:30.0 buttonType:BarButtonTypeNone];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadDataSource];
}

#pragma mark - Data Source
- (void)loadDataSource {
  [super loadDataSource];
  
  // TEST
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"connections" ofType:@"json"];
  NSData *fixtureData = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *connections = [fixtureData objectFromJSONData];
  
  [_cardData addObjectsFromArray:[connections objectForKey:@"values"]];
  
  [self dataSourceDidLoad];
}

- (void)dataSourceDidLoad {
  [super dataSourceDidLoad];
  
  [_collectionView reloadCards];
}

- (BOOL)dataIsAvailable {
  return ([_cardData count] > 0);
}

#pragma mark - PSCollectionViewDelegate
- (void)collectionView:(PSCollectionView *)collectionView didSelectCardAtIndex:(NSInteger)index {
  
}

#pragma mark - PSCollectionViewDataSource
- (NSInteger)numberOfCardsInCollectionView:(PSCollectionView *)collectionView {
  return [_cardData count];
}

- (CardView *)collectionView:(PSCollectionView *)collectionView cardAtIndex:(NSInteger)index {
  CardView *cardView = nil;
  cardView = [collectionView dequeueReusableCardView];
  
  // Configure Card View
  NSDictionary *cardDict = [_cardData objectAtIndex:index];
  
//  switch (index) {
//    case 0:
//      cardView.backgroundColor = [UIColor redColor];
//      break;
//    case 1:
//      cardView.backgroundColor = [UIColor greenColor];
//      break;
//    case 2:
//      cardView.backgroundColor = [UIColor blueColor];
//      break;
//    case 3:
//      cardView.backgroundColor = [UIColor purpleColor];
//      break;
//    case 4:
//      cardView.backgroundColor = [UIColor yellowColor];
//      break;
//    case 5:
//      cardView.backgroundColor = [UIColor orangeColor];
//      break;
//    default:
//      cardView.backgroundColor = [UIColor whiteColor];
//      break;
//  }
  
  [cardView fillCardWithObject:cardDict];
  
  return cardView;
}

@end
