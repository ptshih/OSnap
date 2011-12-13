//
//  ArticleSlideView.m
//  OSnap
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
    _backgroundView = [[UIImageView alloc] initWithImage:nil];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    
    _dividerView = [[UIImageView alloc] initWithImage:[UIImage stretchableImageNamed:@"HorizontalLine.png" withLeftCapWidth:5 topCapWidth:0]];
    
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _pictureView.layer.borderWidth = 1.0;
//    _pictureView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _captionView = [[UIView alloc] initWithFrame:CGRectZero];
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
    [_backgroundView addSubview:_dividerView];
//    [_backgroundView addSubview:_actionView];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_dictionary);
  RELEASE_SAFELY(_dividerView);
  RELEASE_SAFELY(_backgroundView);
  RELEASE_SAFELY(_pictureView);
  RELEASE_SAFELY(_captionView);
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _backgroundView.frame = CGRectMake(0, 0, self.slideContentView.width, self.slideContentView.height);
  
//  _dividerView.frame = CGRectMake(0, self.slideContentView.height - 1, self.slideContentView.width, 1);
  
  // Configure Subview Frames
  CGFloat width = _backgroundView.width; // self.slideContentView.width
  CGFloat left = MARGIN;
  CGFloat top = MARGIN;
  CGSize desiredSize = CGSizeZero;
  CGFloat textWidth = width - MARGIN * 2;
  
  // Picture
  CGFloat pictureWidth = [[_dictionary objectForKey:@"width"] floatValue];
  CGFloat pictureHeight = [[_dictionary objectForKey:@"height"] floatValue];
  _pictureView.frame = CGRectMake(0, 0, width, floorf(pictureHeight / (pictureWidth / width)));
  
  top = _pictureView.bottom;
  
  // Divider
  _dividerView.frame = CGRectMake(0, top, width, 1);
  top += _dividerView.height;
  
  // Caption
  UILabel *captionLabel = [_captionView.subviews lastObject];
  
  desiredSize = [UILabel sizeForText:captionLabel.text width:textWidth font:captionLabel.font numberOfLines:captionLabel.numberOfLines lineBreakMode:captionLabel.lineBreakMode];

  _captionView.top = top;
  _captionView.left = left;
  _captionView.width = textWidth;
  _captionView.height = desiredSize.height + MARGIN * 2;
  
  captionLabel.frame = _captionView.bounds;
  
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
  _dictionary = (PFObject *)[object retain];
  
  // Picture
//  NSString *pictureUrl = [NSString stringWithFormat:@"http://i.imgur.com/%@%@", [_dictionary objectForKey:@"hash"], [_dictionary objectForKey:@"ext"]];
  NSString *pictureUrl = [_dictionary objectForKey:@"source"];
  [_pictureView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:nil];
  
  // Caption
  // Add caption
  __block NSMutableString *caption;
  NSArray *captionsIds = [_dictionary objectForKey:@"captionIds"];
  if (captionsIds && [captionsIds count] > 0) {
    caption = [NSMutableString string];
    [captionsIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
      PFObject *captionObject = [[APP_DELEGATE captionsCache] objectForKey:obj];
      [caption appendString:[captionObject objectForKey:@"message"]];
    }];
  } else {
    caption = [NSMutableString stringWithString:@"No Caption"];
  }
  
  UILabel *captionLabel = [_captionView.subviews lastObject];
  captionLabel.text = caption;
}

+ (CGFloat)heightForObject:(id)object {
  PFObject *dictionary = (PFObject *)object;
  
  CGFloat width = 320.0;
  CGFloat textWidth = 320.0 - MARGIN * 2;
  
  // Calculate height of dynamic labels;
  CGFloat desiredHeight = 0.0;
  
  // Add top margin
//  desiredHeight += MARGIN;
  
  // Add Picture
  CGFloat pictureWidth = [[dictionary objectForKey:@"width"] floatValue];
  CGFloat pictureHeight = [[dictionary objectForKey:@"height"] floatValue];
  desiredHeight += floorf(pictureHeight / (pictureWidth / width));
  
  // Add caption
  NSString *caption = @"No Caption";
  NSArray *captionsIds = [dictionary objectForKey:@"captionIds"];
  if (captionsIds && [captionsIds count] > 0) {
    
  } else {
    caption = @"No Title";
  }

  CGSize desiredSize = [UILabel sizeForText:caption width:textWidth font:[PSStyleSheet fontForStyle:@"articleCaption"] numberOfLines:[PSStyleSheet numberOfLinesForStyle:@"articleCaption"] lineBreakMode:UILineBreakModeTailTruncation];
  desiredHeight += desiredSize.height + MARGIN * 2;
  
  // Add action View
//  desiredHeight += 44;
  
  // Add bottom margin
//  desiredHeight += MARGIN;
  
  return desiredHeight;
}

@end
