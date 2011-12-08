//
//  ArticleSlideView.h
//  OSnap
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "PSSlideView.h"

@interface ArticleSlideView : PSSlideView {
  NSDictionary *_dictionary;
  
  UIView *_backgroundView;
  UIImageView *_pictureView;
  UIView *_captionView;
  UIView *_actionView;
}

- (void)fillSlideWithObject:(id)object;

@end
