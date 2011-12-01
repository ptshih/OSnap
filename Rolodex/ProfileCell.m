//
//  ProfileCell.m
//  Rolodex
//
//  Created by Peter Shih on 11/25/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
  if (self) {
    [PSStyleSheet applyStyle:@"menuCellTitle" forLabel:self.textLabel];
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    [PSStyleSheet applyStyle:@"menuCellSubtitle" forLabel:self.detailTextLabel];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.imageView.frame = CGRectMake(10, 10, 30, 30);
  self.textLabel.left = self.imageView.right + 10;
  self.detailTextLabel.left = self.textLabel.left;
  
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.imageView cancelImageRequestOperation];
}

#pragma mark - Fill and Height
- (void)fillCellWithObject:(id)object
{
  NSDictionary *obj = (NSDictionary *)object;
  NSString *title = [obj objectForKey:@"title"];
  NSString *subtitle = [obj objectForKey:@"subtitle"];
  
  self.textLabel.text = title;
  self.detailTextLabel.text = subtitle;
}

+ (CGFloat)rowHeight {
  return 50;
}

+ (CGFloat)rowHeightForObject:(id)object forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return 50;
}

@end
