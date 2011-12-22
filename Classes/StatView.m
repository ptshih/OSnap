//
//  StatView.m
//  OSnap
//
//  Created by Peter Shih on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StatView.h"

#define MARGIN 5.0

@implementation StatView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Icons are 16pt tall
    _eyeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconEye"]];
    _happyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconHappyFace"]];
    _sadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconSadFace"]];
    _captionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconCaption"]];
    
    _eyeView.left = MARGIN;
    _eyeView.top = 0;
    
    [self addSubview:_eyeView];
//    [self addSubview:_happyView];
//    [self addSubview:_sadView];
//    [self addSubview:_captionView];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_eyeView);
  RELEASE_SAFELY(_happyView);
  RELEASE_SAFELY(_sadView);
  RELEASE_SAFELY(_captionView);
  [super dealloc];
}

@end
