//
//  RolodexViewController.m
//  Rolodex
//
//  Created by Peter Shih on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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
- (UIView *)backgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundDarkWood.jpg"]] autorelease];
  return bgView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Rolodex View
  _collectionView = [[PSCollectionView alloc] initWithFrame:self.view.bounds];
  _collectionView.autoresizingMask = ~UIViewAutoresizingNone;
  _collectionView.collectionViewDelegate = self;
  _collectionView.collectionViewDataSource = self;
  _collectionView.rowHeight = 120;
  [self.view addSubview:_collectionView];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithImage:[UIImage imageNamed:@"IconMenu.png"] withTarget:APP_DELEGATE action:@selector(slide) width:50.0 height:30.0 buttonType:BarButtonTypeNormal];
  
  // TEST
  // Setup some sample cards
  [_cardData addObject:@"test card 1"];
  [_cardData addObject:@"test card 2"];
  [_cardData addObject:@"test card 3"];
  [_cardData addObject:@"test card 4"];
  [_cardData addObject:@"test card 5"];
  [_cardData addObject:@"test card 6"];
  [_cardData addObject:@"test card 7"];
  
  [_collectionView reloadCards];
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
  switch (index) {
    case 0:
      cardView.backgroundColor = [UIColor redColor];
      break;
    case 1:
      cardView.backgroundColor = [UIColor greenColor];
      break;
    case 2:
      cardView.backgroundColor = [UIColor blueColor];
      break;
    case 3:
      cardView.backgroundColor = [UIColor purpleColor];
      break;
    case 4:
      cardView.backgroundColor = [UIColor yellowColor];
      break;
    case 5:
      cardView.backgroundColor = [UIColor orangeColor];
      break;
    default:
      cardView.backgroundColor = [UIColor grayColor];
      break;
  }
  
  
  return cardView;
}

@end
