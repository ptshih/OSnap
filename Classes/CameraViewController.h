//
//  CameraViewController.h
//  OSnap
//
//  Created by Peter Shih on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSViewController.h"

@interface CameraViewController : PSViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  UIImagePickerControllerSourceType _sourceType;
  
  UIImage *_snappedImage;
  
  BOOL _shouldSaveToAlbum;
  BOOL _shouldDismissOnAppear;
}

- (void)showImagePicker;

@end
