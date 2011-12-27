//
//  DashView.m
//  OSnap
//
//  Created by Peter Shih on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashView.h"

@implementation DashView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(DASH_MARGIN, DASH_MARGIN, frame.size.width - DASH_MARGIN * 2, frame.size.height - DASH_MARGIN * 2)];
    [self addSubview:_contentView];
    
    CGFloat width = _contentView.width;
    CGFloat height = _contentView.height - DASH_CAPTION_HEIGHT - DASH_MARGIN;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height + DASH_MARGIN, width, DASH_CAPTION_HEIGHT)];
    [PSStyleSheet applyStyle:@"dashSectionName" forLabel:_nameLabel];
    
    _disclosureView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 20, height + DASH_MARGIN, 20, DASH_CAPTION_HEIGHT)];
    [_disclosureView setImage:[UIImage imageNamed:@"IconNextBlack"]];
    _disclosureView.hidden = YES;
    
    [_contentView addSubview:_nameLabel];
    [_contentView addSubview:_disclosureView];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_nameLabel);
  RELEASE_SAFELY(_disclosureView);
  RELEASE_SAFELY(_contentView);
  [super dealloc];
}

- (void)fillDashSectionWithObject:(id)object {  

}

@end
