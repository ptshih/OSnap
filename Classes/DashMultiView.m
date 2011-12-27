//
//  DashMultiView.m
//  OSnap
//
//  Created by Peter Shih on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashMultiView.h"

@implementation DashMultiView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _images = [[NSMutableArray arrayWithCapacity:1] retain];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_images);
  [super dealloc];
}

- (void)fillDashSectionWithObject:(id)object {
  /**
   Depending on what aspect ratio the top pictures are, display them accordingly.
   P P P P
   L L
   L P P, P L P, P P L
   */
//  NSArray *sources = [object objectForKey:@"sources"];
  [_images addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://i.imgur.com/5sSRi.jpg", @"source", @"landscape", @"orientation", nil]]; // l
  [_images addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://i.imgur.com/jQpkf.jpg", @"source", @"portrait", @"orientation", nil]]; // p
  [_images addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://i.imgur.com/jQpkf.jpg", @"source", @"portrait", @"orientation", nil]]; // p
  [_images addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://i.imgur.com/oZf7E.jpg", @"source", @"portrait", @"orientation", nil]]; // p
  [_images addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://i.imgur.com/oZf7E.jpg", @"source", @"portrait", @"orientation", nil]]; // p
  [_images addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://i.imgur.com/jQpkf.jpg", @"source", @"portrait", @"orientation", nil]]; // p
  [_images addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://i.imgur.com/oZf7E.jpg", @"source", @"portrait", @"orientation", nil]]; // p
  
  CGFloat width = _contentView.width;
  CGFloat height = _contentView.height - DASH_CAPTION_HEIGHT - DASH_MARGIN;
  CGFloat lWidth = floorf(width / 2);
  CGFloat pWidth = floorf(width / 4);
  
  // Images
  __block CGFloat left = 0.0;
  __block CGFloat adjWidth = 0.0;
  __block CGFloat spacing = 2.0;
  [_images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *orientation = [obj objectForKey:@"orientation"];
    NSString *source = [obj objectForKey:@"source"];
    CGFloat sWidth = ([orientation isEqualToString:@"portrait"]) ? pWidth : lWidth;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(left, 0, sWidth - adjWidth, height)];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    [iv setImageWithURL:[NSURL URLWithString:source]];
    [_contentView addSubview:iv];
    left += (sWidth - adjWidth);
    left += spacing;
    adjWidth++;
    
    if (left >= width) *stop = YES;
  }];
  
  // Set Labels
  _nameLabel.text = @"Funny";
  _disclosureView.hidden = NO;
}

@end
