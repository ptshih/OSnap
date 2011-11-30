//
//  ArticleSlideView.m
//  Rolodex
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ArticleSlideView.h"

@implementation ArticleSlideView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.slideContentView.backgroundColor = [UIColor greenColor];
    self.slideContentView.frame = CGRectMake(0, 0, 320, 640);
  }
  return self;
}

- (void)dealloc {
  // Views
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

@end
