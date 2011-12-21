//
//  ArticleSlideView.m
//  OSnap
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "ArticleSlideView.h"
#import "CaptionView.h"
#import "StatView.h"

#define MARGIN 10.0

@implementation ArticleSlideView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Config
    self.slideContentView.frame = self.bounds;
    
    // Dictionary object
    _dictionary = nil;
    
    // Configure subviews
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _statView = [[StatView alloc] initWithFrame:CGRectZero];
    _captionContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    _captionContainerView.backgroundColor = [UIColor whiteColor];

    // Array of caption subviews
    _captionViews = [[NSMutableArray alloc] initWithCapacity:1];
    
    // Add subviews to hierarchy
    [self.slideContentView addSubview:_pictureView];
    [self.slideContentView addSubview:_statView];
    [self.slideContentView addSubview:_captionContainerView];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_dictionary);
  RELEASE_SAFELY(_pictureView);
  RELEASE_SAFELY(_statView);
  RELEASE_SAFELY(_captionContainerView);
  RELEASE_SAFELY(_captionViews);
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];

}

- (void)prepareForReuse {
  [super prepareForReuse];
  RELEASE_SAFELY(_dictionary);
  
  [_captionContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [_captionViews removeAllObjects];
}

- (void)fillSlideWithObject:(id)object {
  CGFloat width = self.slideContentView.width;
  CGFloat left = 0.0;
  CGFloat top = 0.0;
  _dictionary = (PFObject *)[object retain];
  
  // Picture
//  NSString *pictureUrl = [NSString stringWithFormat:@"http://i.imgur.com/%@%@", [_dictionary objectForKey:@"hash"], [_dictionary objectForKey:@"ext"]];
  NSString *pictureUrl = [_dictionary objectForKey:@"source"];
  [_pictureView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:nil];
  
  CGFloat pictureWidth = [[_dictionary objectForKey:@"width"] floatValue];
  CGFloat pictureHeight = [[_dictionary objectForKey:@"height"] floatValue];
  _pictureView.frame = CGRectMake(left, top, width, floorf(pictureHeight / (pictureWidth / width)));
  
  top = _pictureView.bottom;
  
  // Stats
  _statView.frame = CGRectMake(left, top, width, 44.0);

  top = _statView.bottom;
  
  // Captions
  // We're gonna show the top caption, and all other captions will be in a "show more" button
  // If no captions, don't show this section
  NSArray *captionsIds = [_dictionary objectForKey:@"captionIds"];
  if (captionsIds && [captionsIds count] > 0) {
    // First lets read out all the actual captions from the global cache
    NSArray *captionsIds = [_dictionary objectForKey:@"captionIds"];
    [captionsIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
      PFObject *captionObject = [[APP_DELEGATE captionsCache] objectForKey:obj];
      NSDictionary *captionDict = [NSDictionary dictionaryWithObject:[captionObject objectForKey:@"message"] forKey:@"message"];
      
      // Lets create CaptionView objects for each caption and put it into the array
      CaptionView *captionView = [[CaptionView alloc] initWithFrame:CGRectMake(0, 0, self.slideContentView.width, 0.0) andDictionary:captionDict];
      [_captionViews addObject:captionView];
      [captionView release];
    }];
    
    CGFloat captionHeight = 0.0;
    for (CaptionView *captionView in _captionViews) {
      captionView.top = captionHeight;
      [_captionContainerView addSubview:captionView];
      captionHeight += captionView.height;
    }
    
    _captionContainerView.hidden = NO;
    _captionContainerView.frame = CGRectMake(left, top, width, captionHeight);
    

    top = _captionContainerView.bottom;
    
    // If there is more than 1 caption, display the show more button
    
    if ([captionsIds count] > 1) {
      UIButton *moreButton = [UIButton buttonWithFrame:CGRectMake(0.0, _captionContainerView.height, _captionContainerView.width, 44.0) andStyle:nil target:nil action:nil];
      [moreButton setTitle:@"Show 5 More Captions..." forState:UIControlStateNormal];
      [PSStyleSheet applyStyle:@"moreCaptionsButton" forButton:moreButton];
      [_captionContainerView addSubview:moreButton];
      _captionContainerView.height += 44.0;
      
      top = _captionContainerView.bottom;
    }
  } else {
    _captionContainerView.hidden = YES;
  }
  
  self.slideHeight = top;
}

@end
