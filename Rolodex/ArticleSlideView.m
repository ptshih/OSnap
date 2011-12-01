//
//  ArticleSlideView.m
//  Rolodex
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "ArticleSlideView.h"

#define MARGIN 10.0

@implementation ArticleSlideView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Config
    self.slideContentView.backgroundColor = [UIColor greenColor];
    self.slideContentView.frame = CGRectMake(0, 0, 320, 640);
    
    // Configure subviews
    _frameView = [[UIImageView alloc] initWithImage:[UIImage stretchableImageNamed:@"PhotoFrame.png" withLeftCapWidth:21 topCapWidth:6]];
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    // Add subviews to hierarchy
    [self addSubview:_frameView];
    [self addSubview:_pictureView];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_frameView);
  RELEASE_SAFELY(_pictureView);
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Configure Subview Frames
  CGFloat left = 0.0;
  CGFloat top = 0.0;
  CGSize desiredSize = CGSizeZero;
  CGFloat textWidth = 0.0;
  
  // Picture
  _frameView.frame = CGRectMake(MARGIN, MARGIN, self.slideContentView.width - MARGIN * 2, self.slideContentView.width - MARGIN * 2);
  _pictureView.frame = CGRectMake(MARGIN * 1.5, MARGIN * 1.5, self.slideContentView.width - MARGIN * 3, self.slideContentView.width - MARGIN * 3);
  
//  _frameView.frame = CGRectMake(MARGIN, MARGIN, self.slideContentView.width - MARGIN * 2, 374);
//  _pictureView.frame = CGRectMake(MARGIN * 1.5, MARGIN * 1.5, self.slideContentView.width - MARGIN * 3, 364);
}

- (void)fillSlideWithObject:(id)object {
  NSDictionary *dict = (NSDictionary *)object;
  NSString *pictureUrl = [dict objectForKey:@"pictureUrl"];
  if (pictureUrl) {
    [_pictureView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:[UIImage imageNamed:@"DosEquisMan.jpg"]];
  } else {
    [_pictureView setImage:[UIImage imageNamed:@"DosEquisMan.jpg"]];
  }
}

@end
