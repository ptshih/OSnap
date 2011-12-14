//
//  ArticleSlideView.h
//  OSnap
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "PSSlideView.h"

@class StatView;

@interface ArticleSlideView : PSSlideView {
  PFObject *_dictionary;
  UIImageView *_pictureView;
  StatView *_statView;
  UIView *_captionContainerView;
  NSMutableArray *_captionViews;
}

- (void)fillSlideWithObject:(id)object;

@end
