//
//  StatView.m
//  OSnap
//
//  Created by Peter Shih on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StatView.h"

#define MARGIN_X 10.0
#define MARGIN_Y 12.0

@implementation StatView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    self.backgroundColor = [UIColor blackColor];
    
    // Icons are 20x20pt
    _eyeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconEye"]];
    _happyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconHappyFace"]];
    _sadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconSadFace"]];
    _captionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconCaption"]];
    
    _eyeView.left = MARGIN_X;
    _eyeView.top = MARGIN_Y;
    _happyView.left = MARGIN_X * 2 + 70.0;
    _happyView.top = MARGIN_Y;
    _sadView.left = MARGIN_X * 3 + 70.0 * 2;
    _sadView.top = MARGIN_Y;
    _captionView.top = MARGIN_Y;
    _captionView.left = MARGIN_X * 4 + 70.0 * 3;
    
    [self addSubview:_eyeView];
    [self addSubview:_happyView];
    [self addSubview:_sadView];
    [self addSubview:_captionView];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_eyeView);
  RELEASE_SAFELY(_happyView);
  RELEASE_SAFELY(_sadView);
  [super dealloc];
}

@end
