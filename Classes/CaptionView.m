//
//  CaptionView.m
//  OSnap
//
//  Created by Peter Shih on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CaptionView.h"

#define MARGIN 5.0

@implementation CaptionView

- (id)initWithFrame:(CGRect)frame andDictionary:(NSDictionary *)dictionary {
  self = [super initWithFrame:frame];
  if (self) {
    _dictionary = [dictionary copy];
    
    CGFloat width = self.width - MARGIN * 2;
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, width, 0.0)];
   [self addSubview:_messageLabel];
    
    [PSStyleSheet applyStyle:@"articleCaption" forLabel:_messageLabel];
    _messageLabel.text = [_dictionary objectForKey:@"message"];
    
    CGSize messageSize = [UILabel sizeForText:_messageLabel.text width:_messageLabel.width font:_messageLabel.font numberOfLines:_messageLabel.numberOfLines lineBreakMode:_messageLabel.lineBreakMode];
    
    _messageLabel.height = messageSize.height;
    
    self.height = messageSize.height + MARGIN * 2;
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_dictionary);
  RELEASE_SAFELY(_messageLabel);
  [super dealloc];
}

@end
