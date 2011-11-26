//
//  CardView.m
//  Rolodex
//
//  Created by Peter Shih on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CardView.h"

#define CARD_WIDTH 300
#define CARD_HEIGHT 100

@implementation CardView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT)];
  if (self) {
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
//    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark - View
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)fillCardWithObject:(id)object {
  
}

@end
