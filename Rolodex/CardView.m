//
//  CardView.m
//  Rolodex
//
//  Created by Peter Shih on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor darkGrayColor];
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

@end
