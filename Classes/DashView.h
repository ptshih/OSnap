//
//  DashView.h
//  OSnap
//
//  Created by Peter Shih on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PSView.h"

@interface DashView : PSView {
  UIImageView *_imageView;
  UILabel *_nameLabel;
  UIImageView *_disclosureView;
}

- (void)fillDashSectionWithObject:(id)object;

@end