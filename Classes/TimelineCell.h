//
//  TimelineCell.h
//  OSnap
//
//  Created by Peter Shih on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PSCell.h"

#define TL_MARGIN 10.0
#define TL_CAPTION_HEIGHT 20.0

@interface TimelineCell : PSCell {
  NSMutableArray *_images;
  UILabel *_titleLabel;
  UILabel *_subtitleLabel;
}

@end
