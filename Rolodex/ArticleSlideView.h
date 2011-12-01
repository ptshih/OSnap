//
//  ArticleSlideView.h
//  Rolodex
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "PSSlideView.h"

@interface ArticleSlideView : PSSlideView {
  UIImageView *_frameView;
  UIImageView *_pictureView;
}

- (void)fillSlideWithObject:(id)object;

@end
