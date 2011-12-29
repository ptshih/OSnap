//
//  TimelineCell.m
//  OSnap
//
//  Created by Peter Shih on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TimelineCell.h"

#import "PSZoomView.h"

#define IMAGES_PER_ROW 4
#define IMAGE_SPACING 2.0

@implementation TimelineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _images = [[NSMutableArray arrayWithCapacity:1] retain];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [PSStyleSheet applyStyle:@"timelineTitle" forLabel:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [PSStyleSheet applyStyle:@"timelineSubtitle" forLabel:_subtitleLabel];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_subtitleLabel];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_images);
  
  RELEASE_SAFELY(_titleLabel);
  RELEASE_SAFELY(_subtitleLabel);
  [super dealloc];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [_images removeAllObjects];
  _titleLabel.text = nil;
  _subtitleLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.contentView.frame = CGRectMake(TL_MARGIN, TL_MARGIN, self.width - TL_MARGIN * 2, self.height - TL_MARGIN * 2);
  
  CGFloat width = self.contentView.width;
  CGFloat height = self.contentView.height - TL_CAPTION_HEIGHT - TL_MARGIN;
  
  // Images
  CGFloat iWidth = 0.0;
  NSInteger numImages = [_images count];
  if (numImages == 1) {
    iWidth = width;
  } else if (numImages == 2) {
    iWidth = floorf(width / 2.0);
  } else if (numImages == 3) {
    iWidth = floorf(width / 3);
  } else {
    iWidth = floorf(width / 4.0);
  }
  iWidth -= IMAGE_SPACING;
  
  CGFloat iHeight = 0.0;
  NSInteger numRows = (([_images count] - 1) / IMAGES_PER_ROW) + 1;
  iHeight = floorf(height / numRows);
  iHeight -= IMAGE_SPACING;

  [_images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSInteger col = idx % IMAGES_PER_ROW;
    NSInteger row = idx / IMAGES_PER_ROW;
    CGFloat colSpacing = col * IMAGE_SPACING;
    CGFloat rowSpacing = row * IMAGE_SPACING;
    CGFloat left = col * iWidth + colSpacing;
    CGFloat top = row * iHeight + rowSpacing;
    
    NSString *source = [obj objectForKey:@"source"];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, iWidth, iHeight)];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    iv.userInteractionEnabled = YES;
    UITapGestureRecognizer *zoomGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)] autorelease];
    [iv addGestureRecognizer:zoomGesture];
    [iv setImageWithURL:[NSURL URLWithString:source]];
    [self.contentView addSubview:iv];
  }];
  
  // Labels
  _titleLabel.frame = CGRectMake(0, height + TL_MARGIN, floorf(width * (3.0 / 4.0)), TL_CAPTION_HEIGHT);
  _subtitleLabel.frame = CGRectMake(floorf(width * (3.0 / 4.0)), height + TL_MARGIN, floorf(width * (1.0 / 4.0)), TL_CAPTION_HEIGHT);
}



+ (CGFloat)rowHeightForObject:(id)object forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  NSArray *images = [object objectForKey:@"photos"];
  NSInteger numImages = [images count];
  NSInteger numRows = ((numImages - 1) / IMAGES_PER_ROW) + 1;
  if (numImages == 1) return 200.0 + 20.0;
  else return 100.0 * numRows + 20.0;
}

- (void)fillCellWithObject:(id)object {
  [_images addObjectsFromArray:[object objectForKey:@"photos"]];
  
  // Labels
  _titleLabel.text = @"Disneyland - Anaheim, CA";
  _subtitleLabel.text = @"Dec. 25, 2011";
  
}

#pragma mark - Zoom
- (void)zoom:(UITapGestureRecognizer *)gestureRecognizer {
  UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
  
  PSZoomView *zoomView = [[[PSZoomView alloc] initWithImage:imageView.image frame:[self.contentView convertRect:imageView.frame toView:nil] contentMode:imageView.contentMode] autorelease];
  [zoomView show];
}

@end
