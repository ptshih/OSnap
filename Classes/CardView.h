//
//  CardView.h
//  OSnap
//
//  Created by Peter Shih on 11/24/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "PSView.h"

@interface CardView : PSView {
  UIImageView *_frameView;
  UIImageView *_pictureView;
  UILabel *_nameLabel;
  UILabel *_headlineLabel;
  UILabel *_locationLabel;
  UILabel *_industryLabel;
}

+ (CGFloat)cardWidth;
+ (CGFloat)cardHeight;

- (void)fillCardWithObject:(id)object;

@end
