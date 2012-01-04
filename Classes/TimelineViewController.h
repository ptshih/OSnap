//
//  TimelineViewController.h
//  OSnap
//
//  Created by Peter Shih on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PSTableViewController.h"

@interface TimelineViewController : PSTableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)getExifFromData:(NSData *)data;
//- (void)uploadPhotoWithData:(NSData *)data;
- (void)uploadPhotoWithData:(NSData *)data width:(CGFloat)width height:(CGFloat)height metadata:(NSDictionary *)metadata;
- (void)uploadPhotoWithAssetURL:(NSURL *)assetURL;

@end
