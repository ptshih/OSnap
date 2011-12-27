//
//  DashView.h
//  OSnap
//
//  Created by Peter Shih on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PSView.h"

#define DASH_MARGIN 10.0
#define DASH_CAPTION_HEIGHT 20.0

@interface DashView : PSView {
  UIView *_contentView;
  UILabel *_nameLabel;
  UIImageView *_disclosureView;
}

- (void)fillDashSectionWithObject:(id)object;

@end