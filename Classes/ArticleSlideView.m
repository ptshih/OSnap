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
    _cardView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, self.slideContentView.width - MARGIN * 2, self.slideContentView.height - MARGIN * 2)];
    _cardView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    _cardView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _cardView.layer.borderWidth = 1.0;
    _cardView.layer.cornerRadius = 5.0;
    _cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    _cardView.layer.shadowOpacity = 0.5;
    _cardView.layer.shadowRadius = 2.0;
    _cardView.layer.shadowOffset = CGSizeMake(0, 1);
//    _cardView.layer.shouldRasterize = YES;
    
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _pictureView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    _pictureView.layer.borderWidth = 1.0;
    _pictureView.layer.shadowColor = [UIColor blackColor].CGColor;
    _pictureView.layer.shadowOpacity = 0.75;
    _pictureView.layer.shadowRadius = 2.0;
    _pictureView.layer.shadowOffset = CGSizeMake(0, 2);
    _pictureView.layer.shouldRasterize = YES;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [PSStyleSheet applyStyle:@"slideTitle" forLabel:_titleLabel];
    
    _statView = [[StatView alloc] initWithFrame:CGRectZero];
    
    _separatorView = [[UIImageView alloc] initWithImage:[UIImage stretchableImageNamed:@"HorizontalLine" withLeftCapWidth:2 topCapWidth:0]];
    
    _captionContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    _captionContainerView.backgroundColor = [UIColor whiteColor];

    // Array of caption subviews
    _captionViews = [[NSMutableArray alloc] initWithCapacity:1];
    
    // Expand button
    _expandButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [PSStyleSheet applyStyle:@"expandButton" forButton:_expandButton];
    
    // Add subviews to hierarchy
    [self.slideContentView addSubview:_cardView];
    [_cardView addSubview:_titleLabel];
    [_cardView addSubview:_pictureView];
    [_cardView addSubview:_statView];
    [_cardView addSubview:_separatorView];
    [_cardView addSubview:_captionContainerView];
    [_cardView addSubview:_expandButton];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_dictionary);
  RELEASE_SAFELY(_cardView);
  RELEASE_SAFELY(_titleLabel);
  RELEASE_SAFELY(_pictureView);
  RELEASE_SAFELY(_statView);
  RELEASE_SAFELY(_separatorView);
  RELEASE_SAFELY(_captionContainerView);
  RELEASE_SAFELY(_captionViews);
  RELEASE_SAFELY(_expandButton);
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
  
  self.slideContentView.frame = self.bounds;
  _cardView.frame = CGRectMake(MARGIN, MARGIN, self.slideContentView.width - MARGIN * 2, self.slideContentView.height - MARGIN * 2);
}

- (void)fillSlideWithObject:(id)object {
  CGFloat width = _cardView.width - MARGIN * 2;
  CGFloat left = MARGIN;
  CGFloat top = MARGIN;
  _dictionary = (PFObject *)[object retain];
  
  // Title
  _titleLabel.text = @"This is a test title!";
  CGSize titleSize = [UILabel sizeForText:_titleLabel.text width:width font:_titleLabel.font numberOfLines:_titleLabel.numberOfLines lineBreakMode:_titleLabel.lineBreakMode];
  _titleLabel.left = left;
  _titleLabel.top = top;
  _titleLabel.width = titleSize.width;
  _titleLabel.height = titleSize.height;
  
  top = _titleLabel.bottom + MARGIN;
  
  // Picture
//  NSString *pictureUrl = [NSString stringWithFormat:@"http://i.imgur.com/%@%@", [_dictionary objectForKey:@"hash"], [_dictionary objectForKey:@"ext"]];
  NSString *pictureUrl = [_dictionary objectForKey:@"source"];
  [_pictureView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:nil];
  
  CGFloat pictureWidth = [[_dictionary objectForKey:@"width"] floatValue];
  CGFloat pictureHeight = [[_dictionary objectForKey:@"height"] floatValue];
  _pictureView.frame = CGRectMake(left, top, width, floorf(pictureHeight / (pictureWidth / width)));
  
  top = _pictureView.bottom + MARGIN; // No Margin after this
  
  // Stats
  _statView.frame = CGRectMake(left, top, width, 10.0);

  top = _statView.bottom + MARGIN;
  
  // Horizontal Line
  _separatorView.left = left;
  _separatorView.top = top;
  _separatorView.width = width;
  _separatorView.height = 1.0;
  
  top = _separatorView.bottom + MARGIN;
  
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
      CaptionView *captionView = [[CaptionView alloc] initWithFrame:CGRectMake(0, 0, width, 0.0) andDictionary:captionDict];
      captionView.backgroundColor = (idx % 2 == 0) ? [UIColor whiteColor] : [UIColor lightGrayColor];
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
  } else {
    _captionContainerView.hidden = YES;
  }
  
  // Expand Button
  _expandButton.frame = CGRectMake(left, top, width, 32.0);
  if (captionsIds && [captionsIds count] > 1) {
    [_expandButton setTitle:[NSString stringWithFormat:@"Show %d More Captions...", [captionsIds count]] forState:UIControlStateNormal];
  } else {
    [_expandButton setTitle:@"No Captions Yet... Add One Now!" forState:UIControlStateNormal];
  }
  
  top = _expandButton.bottom;
  
  top += MARGIN;
  
  _cardView.height = fmaxf(top, _cardView.height);
  self.slideHeight = _cardView.height + MARGIN * 2;
}

@end
