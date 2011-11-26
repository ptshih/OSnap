//
//  CardView.m
//  Rolodex
//
//  Created by Peter Shih on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CardView.h"

#define MARGIN 10.0

@implementation CardView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:CGRectMake(0, 0, [[self class] cardWidth], [[self class] cardHeight])];
  if (self) {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    // Configure subviews
    _frameView = [[UIImageView alloc] initWithImage:[UIImage stretchableImageNamed:@"PhotoFrame.png" withLeftCapWidth:21 topCapWidth:6]];
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.numberOfLines = 1;
    [PSStyleSheet applyStyle:@"cardName" forLabel:_nameLabel];
    
    _headlineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _headlineLabel.backgroundColor = [UIColor clearColor];
    _headlineLabel.numberOfLines = 2;
    [PSStyleSheet applyStyle:@"cardHeadline" forLabel:_headlineLabel];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _locationLabel.backgroundColor = [UIColor clearColor];
    _locationLabel.numberOfLines = 1;
    [PSStyleSheet applyStyle:@"cardLocation" forLabel:_locationLabel];
    
    _industryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _industryLabel.backgroundColor = [UIColor clearColor];
    _industryLabel.numberOfLines = 1;
    [PSStyleSheet applyStyle:@"cardIndustry" forLabel:_industryLabel];
    
    // Add subviews to hierarchy
    [self addSubview:_frameView];
    [self addSubview:_pictureView];
    [self addSubview:_nameLabel];
    [self addSubview:_headlineLabel];
    [self addSubview:_locationLabel];
    [self addSubview:_industryLabel];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_frameView);
  RELEASE_SAFELY(_pictureView);
  RELEASE_SAFELY(_nameLabel);
  RELEASE_SAFELY(_headlineLabel);
  RELEASE_SAFELY(_locationLabel);
  RELEASE_SAFELY(_industryLabel);
  [super dealloc];
}

#pragma mark - Config
+ (CGFloat)cardWidth {
  return 300.0;
}

+ (CGFloat)cardHeight {
  return 120.0;
}

#pragma mark - View
- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Configure Subview Frames
  CGFloat left = 0.0;
  CGFloat top = 0.0;
  CGSize desiredSize = CGSizeZero;
  CGFloat textWidth = 0.0;
  
  // Picture
  _frameView.frame = CGRectMake(MARGIN, MARGIN, 100, 100);
  _pictureView.frame = CGRectMake(MARGIN * 2, MARGIN * 2, 80, 80);
  
  left = _frameView.right + MARGIN;
  top = _frameView.top;
  textWidth = self.width - left - MARGIN;
  
  // Labels
  desiredSize = [UILabel sizeForText:_nameLabel.text width:textWidth font:_nameLabel.font numberOfLines:_nameLabel.numberOfLines lineBreakMode:_nameLabel.lineBreakMode];
  _nameLabel.left = left;
  _nameLabel.top = top;
  _nameLabel.width = desiredSize.width;
  _nameLabel.height = desiredSize.height;
  top = _nameLabel.bottom;
  
  desiredSize = [UILabel sizeForText:_headlineLabel.text width:textWidth font:_headlineLabel.font numberOfLines:_headlineLabel.numberOfLines lineBreakMode:_headlineLabel.lineBreakMode];
  _headlineLabel.left = left;
  _headlineLabel.top = top;
  _headlineLabel.width = desiredSize.width;
  _headlineLabel.height = desiredSize.height;
  top = _headlineLabel.bottom;
  
  desiredSize = [UILabel sizeForText:_locationLabel.text width:textWidth font:_locationLabel.font numberOfLines:_locationLabel.numberOfLines lineBreakMode:_locationLabel.lineBreakMode];
  _locationLabel.left = left;
  _locationLabel.top = top;
  _locationLabel.width = desiredSize.width;
  _locationLabel.height = desiredSize.height;
  top = _locationLabel.bottom;
  
  desiredSize = [UILabel sizeForText:_industryLabel.text width:textWidth font:_industryLabel.font numberOfLines:_industryLabel.numberOfLines lineBreakMode:_industryLabel.lineBreakMode];
  _industryLabel.left = left;
  _industryLabel.top = top;
  _industryLabel.width = desiredSize.width;
  _industryLabel.height = desiredSize.height;
  top = _industryLabel.bottom;
}

- (void)fillCardWithObject:(id)object {
  NSDictionary *dict = (NSDictionary *)object;
  NSString *pictureUrl = [dict objectForKey:@"pictureUrl"];
  if (pictureUrl) {
    [_pictureView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:[UIImage imageNamed:@"CardPicturePlaceholder.png"]];
  } else {
    [_pictureView setImage:[UIImage imageNamed:@"CardPicturePlaceholder.png"]];
  }
//  [_pictureView setImageWithURL:[NSURL URLWithString:@"http://media.linkedin.com/mpr/mprx/0_iWKW8paRhZQskJCqTwPV8YyqGgKnQ01qTek98YYXjRkQMUXN7785aOoo2KrWL4-4GEtB7J8b3VYK"]];
  
  _nameLabel.text = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"firstName"], [dict objectForKey:@"lastName"]];
  _headlineLabel.text = [dict objectForKey:@"headline"];
  _locationLabel.text = [[dict objectForKey:@"location"] objectForKey:@"name"];
  _industryLabel.text = [dict objectForKey:@"industry"];
}

@end
