//
//  PreviewViewController.h
//  OSnap
//
//  Created by Peter Shih on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSViewController.h"

@interface PreviewViewController : PSViewController {
  UIImageView *_photoView;
  UIImage *_image;
  NSDictionary *_metadata;
  NSURL *_assetURL;
}

- (id)initWithImage:(UIImage *)image metadata:(NSDictionary *)metadata;
- (id)initWithImage:(UIImage *)image assetURL:(NSURL *)assetURL;

- (void)getExifFromData:(NSData *)data;
//- (void)uploadPhotoWithData:(NSData *)data;
- (void)uploadPhotoWithData:(NSData *)data width:(CGFloat)width height:(CGFloat)height metadata:(NSDictionary *)metadata;
- (void)uploadPhotoWithAssetURL:(NSURL *)assetURL;

@end
