//
//  ArticleSlideView.m
//  Rolodex
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "ArticleSlideView.h"

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
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.layer.cornerRadius = 10;
    _backgroundView.layer.masksToBounds = YES;
    _backgroundView.backgroundColor = [UIColor whiteColor];
    
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _captionView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImageView *cbg = [[[UIImageView alloc] initWithImage:[UIImage stretchableImageNamed:@"BackgroundCaption.png" withLeftCapWidth:0 topCapWidth:22]] autorelease];
    [_captionView addSubview:cbg];
    UILabel *cl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [PSStyleSheet applyStyle:@"articleCaption" forLabel:cl];
    [_captionView addSubview:cl];
    
    _actionView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImageView *abg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundCellLeather.png"]] autorelease];
    [_actionView addSubview:abg];
    
    // Add subviews to hierarchy
    [self.slideContentView addSubview:_backgroundView];
    [_backgroundView addSubview:_pictureView];
    [_backgroundView addSubview:_captionView];
    [_backgroundView addSubview:_actionView];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_dictionary);
  RELEASE_SAFELY(_backgroundView);
  RELEASE_SAFELY(_pictureView);
  RELEASE_SAFELY(_captionView);
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _backgroundView.frame = CGRectMake(MARGIN, MARGIN, self.slideContentView.width - MARGIN * 2, self.slideContentView.height - MARGIN * 2);
  
  // Configure Subview Frames
  CGFloat width = _backgroundView.width; // self.slideContentView.width
  CGFloat left = 0.0;
  CGFloat top = 0.0;
  CGSize desiredSize = CGSizeZero;
  CGFloat textWidth = width - MARGIN * 2;
  
  // Picture
  CGFloat pictureWidth = [[_dictionary objectForKey:@"width"] floatValue];
  CGFloat pictureHeight = [[_dictionary objectForKey:@"height"] floatValue];
  _pictureView.frame = CGRectMake(0, 0, width, floorf(pictureHeight / (pictureWidth / width)));
  
  top = _pictureView.bottom;
  
  // Caption
  UILabel *captionLabel = [_captionView.subviews lastObject];
  
  desiredSize = [UILabel sizeForText:captionLabel.text width:textWidth font:captionLabel.font numberOfLines:captionLabel.numberOfLines lineBreakMode:captionLabel.lineBreakMode];
  captionLabel.width = desiredSize.width;
  captionLabel.height = desiredSize.height;
  captionLabel.left = MARGIN;
  captionLabel.top = MARGIN / 2;
  
  _captionView.top = top;
  _captionView.left = left;
  _captionView.width = self.slideContentView.width;
  _captionView.height = captionLabel.height + MARGIN;
  
  UIImageView *captionBackgroundView = [_captionView.subviews firstObject];
  captionBackgroundView.frame = _captionView.bounds;
  
  top = _captionView.bottom;

  _actionView.frame = CGRectMake(0, _backgroundView.height - 44, width, 44);
  UIImageView *actionBackgroundView = [_actionView.subviews firstObject];
  actionBackgroundView.frame = _actionView.bounds;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  RELEASE_SAFELY(_dictionary);
}

- (void)fillSlideWithObject:(id)object {
  _dictionary = (NSDictionary *)[object copy];
  
  // Picture
  NSString *pictureUrl = [NSString stringWithFormat:@"http://i.imgur.com/%@%@", [_dictionary objectForKey:@"hash"], [_dictionary objectForKey:@"ext"]];
  [_pictureView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:nil];
  
  // Caption
  NSString *caption = [_dictionary objectForKey:@"title"];
  if (![caption notNil]) caption = @"No Title";
  UILabel *captionLabel = [_captionView.subviews lastObject];
  captionLabel.text = caption;
}

+ (CGFloat)heightForObject:(id)object {
  NSDictionary *dictionary = (NSDictionary *)object;
  
  CGFloat width = 320.0 - MARGIN * 2;
  
  // Calculate height of dynamic labels;
  CGFloat desiredHeight = 0.0;
  
  // Add top margin
  desiredHeight += MARGIN;
  
  // Add Picture
  CGFloat pictureWidth = [[dictionary objectForKey:@"width"] floatValue];
  CGFloat pictureHeight = [[dictionary objectForKey:@"height"] floatValue];
  desiredHeight += floorf(pictureHeight / (pictureWidth / width));
  
  // Add caption
  NSString *caption = [dictionary objectForKey:@"title"];
  if (![caption notNil]) caption = @"No Title";
  CGSize desiredSize = [UILabel sizeForText:caption width:(width - MARGIN * 2) font:[PSStyleSheet fontForStyle:@"articleCaption"] numberOfLines:[PSStyleSheet numberOfLinesForStyle:@"articleCaption"] lineBreakMode:UILineBreakModeTailTruncation];
  desiredHeight += desiredSize.height + MARGIN;
  
  // Add action View
  desiredHeight += 44;
  
  // Add bottom margin
  desiredHeight += MARGIN;
  
  return desiredHeight;
}

@end
