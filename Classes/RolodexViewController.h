//
//  RolodexViewController.h
//  OSnap
//
//  Created by Peter Shih on 11/23/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSViewController.h"
#import "PSCollectionView.h"

@class CardView;

@interface RolodexViewController : PSViewController <PSCollectionViewDelegate, PSCollectionViewDataSource> {
  NSMutableArray *_cardData;
  
  // Views
  PSCollectionView *_collectionView;
}

- (id)initWithConfig:(NSDictionary *)config;


@end
