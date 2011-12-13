//
//  ArticleSlideView.h
//  OSnap
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "PSSlideView.h"

@interface ArticleSlideView : PSSlideView {
  PFObject *_dictionary;
  
  UIImageView *_pictureView;
  UIImageView *_caretView;
  UIView *_statsView;
  UIView *_captionView;
  UIImageView *_dividerView;
}

- (void)fillSlideWithObject:(id)object;

@end
