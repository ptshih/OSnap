//
//  AppDelegate.h
//  OSnap
//
//  Created by Peter Shih on 11/15/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  RootViewController *_rootViewController;
}

@property (strong, nonatomic) UIWindow *window;

- (NSMutableDictionary *)captionsCache;

@end
