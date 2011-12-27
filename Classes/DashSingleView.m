//
//  DashSingleView.m
//  OSnap
//
//  Created by Peter Shih on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashSingleView.h"

@implementation DashSingleView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_imageView);
  [super dealloc];
}

- (void)fillDashSectionWithObject:(id)object {
  NSString *source = [object objectForKey:@"source"];
  
  CGFloat width = _contentView.width;
  CGFloat height = _contentView.height - DASH_CAPTION_HEIGHT - DASH_MARGIN;
  
  // Image
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  _imageView.clipsToBounds = YES;
  [_imageView setImageWithURL:[NSURL URLWithString:source]];
  [_contentView addSubview:_imageView];
  
  // Set Labels
  _nameLabel.text = @"Featured / Best of OSnap";
  _disclosureView.hidden = NO;
}

@end
