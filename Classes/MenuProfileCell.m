//
//  MenuProfileCell.m
//  OSnap
//
//  Created by Peter Shih on 11/24/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "MenuProfileCell.h"

@implementation MenuProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
    [PSStyleSheet applyStyle:@"menuCellTitle" forLabel:self.textLabel];
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    [PSStyleSheet applyStyle:@"menuCellSubtitle" forLabel:self.detailTextLabel];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    self.imageView.backgroundColor = self.backgroundColor;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
  NSString *firstName = [obj objectForKey:@"firstName"];
  NSString *lastName = [obj objectForKey:@"lastName"];
  NSString *headline = [obj objectForKey:@"headline"];
  NSString *pictureUrl = [obj objectForKey:@"pictureUrl"];
  
  self.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
  self.detailTextLabel.text = headline;
  [self.imageView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:nil];
}

+ (CGFloat)rowHeight {
  return 60.0;
}

+ (CGFloat)rowHeightForObject:(id)object forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return 60.0;
}

@end
