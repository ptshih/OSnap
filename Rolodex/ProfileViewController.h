//
//  ProfileViewController.h
//  Rolodex
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTableViewController.h"

@interface ProfileViewController : PSTableViewController {
  NSDictionary *_profileDict;
}

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
