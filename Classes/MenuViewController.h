//
//  MenuViewController.h
//  OSnap
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTableViewController.h"

@interface MenuViewController : PSTableViewController <UITextFieldDelegate> {
  NSIndexPath *_selectedMenuIndexPath;
  PSSearchField *_searchField;
}

@end
