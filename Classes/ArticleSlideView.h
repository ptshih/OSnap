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
  UIView *_cardView;
  UIImageView *_pictureView;
  UILabel *_titleLabel;
  StatView *_statView;
  UIImageView *_separatorView;
  UIView *_captionContainerView;
  NSMutableArray *_captionViews;
}

- (void)fillSlideWithObject:(id)object;

@end
