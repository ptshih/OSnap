//
//  CameraViewController.m
//  OSnap
//
//  Created by Peter Shih on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation CameraViewController (CameraDelegateMethods)

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//  _shouldDismissOnAppear = YES;
  [[picker parentViewController] dismissModalViewControllerAnimated:NO];
  [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  
  if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
    _shouldSaveToAlbum = YES;
  } else {
    _shouldSaveToAlbum = NO;
  }
  
  // Handle a still image capture
  if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
    _snappedImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    [_snappedImage retain];
//    _selectedImage = [[originalImage scaleProportionalToSize:CGSizeMake(640, 640)] retain];
  }
  
  if (_snappedImage && _shouldSaveToAlbum) {
    UIImageWriteToSavedPhotosAlbum(_snappedImage, nil, nil, nil);
  }
  
  _shouldDismissOnAppear = NO;
  [[picker parentViewController] dismissModalViewControllerAnimated:NO];
  [picker release];
}

@end

@implementation CameraViewController

- (id)initWithSourceType:(UIImagePickerControllerSourceType)sourceType {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _sourceType = sourceType; // override sourceType
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // default
    
    _shouldSaveToAlbum = NO;
    _shouldDismissOnAppear = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self showImagePicker];
}


- (void)showImagePicker {
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.allowsEditing = NO;
  imagePicker.delegate = self;
  imagePicker.sourceType = _sourceType;
  imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
  [self presentModalViewController:imagePicker animated:NO];
}

- (void)dealloc {
  RELEASE_SAFELY(_snappedImage);
  [super dealloc];
}

@end
