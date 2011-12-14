//
//  CaptionView.h
//  OSnap
//
//  Created by Peter Shih on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PSView.h"

@interface CaptionView : PSView {
  NSDictionary *_dictionary;
  UILabel *_messageLabel;
}

- (id)initWithFrame:(CGRect)frame andDictionary:(NSDictionary *)dictionary;

@end
