//
//  AppDelegate.h
//  OSnap
//
//  Created by Peter Shih on 11/15/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSDrawerController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  PSDrawerController *_drawerController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) PSDrawerController *drawerController;

@end
