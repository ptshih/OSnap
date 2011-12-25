//
//  DashView.m
//  OSnap
//
//  Created by Peter Shih on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashView.h"

#define MARGIN 10.0
#define CAPTION_HEIGHT 32.0

@implementation DashView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat top = 0.0;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, self.width - MARGIN * 2, self.height - MARGIN)];
    _imageView.height -= CAPTION_HEIGHT;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
//    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _imageView.layer.shadowOpacity = 0.75;
//    _imageView.layer.shadowRadius = 2.0;
//    _imageView.layer.shadowOffset = CGSizeMake(0, 2);
//    _imageView.layer.shouldRasterize = YES;
    
    top = _imageView.bottom;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, top, self.width, CAPTION_HEIGHT)];
    [PSStyleSheet applyStyle:@"dashSectionName" forLabel:_nameLabel];
    
    _disclosureView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 20 - MARGIN, top + 6, 20, 20)];
    [_disclosureView setImage:[UIImage imageNamed:@"IconNextBlack"]];
    _disclosureView.hidden = YES;
    
    [self addSubview:_imageView];
    [self addSubview:_nameLabel];
    [self addSubview:_disclosureView];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_imageView);
  RELEASE_SAFELY(_nameLabel);
  RELEASE_SAFELY(_disclosureView);
  [super dealloc];
}

- (void)fillDashSectionWithObject:(id)object {
  NSString *source = [object objectForKey:@"source"];
  
  [_imageView setImageWithURL:[NSURL URLWithString:source]];
  _nameLabel.text = @"Featured / Best of OSnap";
  
  _disclosureView.hidden = NO;
}

@end
