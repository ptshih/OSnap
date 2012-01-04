//
//  TimelineViewController.m
//  OSnap
//
//  Created by Peter Shih on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TimelineViewController.h"
#import "TimelineCell.h"
#import "CameraViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreLocation/CoreLocation.h>

#import "PSLocationCenter.h"
#import "AFNetworking.h"

@implementation TimelineViewController (CameraDelegateMethods)

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self.psNavigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  
  // Handle a still image capture
  if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {

    // First check if image was taken from camera or library
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
      // Taken with camera
      UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
      
      ALAssetsLibrary *assetsLibrary = [[[ALAssetsLibrary alloc] init] autorelease];
      
      NSMutableDictionary *metadata = nil;
      if ([info objectForKey:UIImagePickerControllerMediaMetadata]) {
        metadata = [NSMutableDictionary dictionaryWithDictionary:[info objectForKey:UIImagePickerControllerMediaMetadata]];
        NSDictionary *location = [[PSLocationCenter defaultCenter] exifLocation];
        if ([location count] > 0) {
          [metadata setObject:location forKey:(NSString*)kCGImagePropertyGPSDictionary];
        }
      }
      
      [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error){
        if (assetURL) {
          [self uploadPhotoWithAssetURL:assetURL];
        }
      }];
      
    } else {
      // Picked from library
      NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
      if (assetURL) {
        [self uploadPhotoWithAssetURL:assetURL];
      }
    }
        
#if 0
    // Regular UIImage access
    UIImage *image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize scaledSize = [image scaledSizeBoundedByWidth:720.0];
//    UIImage *scaledImage = [image scaledBoundedByWidth:720.0];
    UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:scaledSize interpolationQuality:kCGInterpolationDefault];
#endif
    
    // Save to Camera Roll?
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
    //      ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //      [library writeImageToSavedPhotosAlbum:(CGImageRef)image metadata:[info objectForKey:UIImagePickerControllerMediaMetadata] completionBlock:^(NSURL *assetURL, NSError *error){
  }

  
  [self.psNavigationController popViewControllerAnimated:YES];
}

@end

@interface TimelineViewController (Private)

- (void)snap;

@end

@implementation TimelineViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidUnload {
  // Views
  [super viewDidUnload];
}

- (void)dealloc {
  
  // Views
  [super dealloc];
}

#pragma mark - View Config
- (UIColor *)baseBackgroundColor {
  return [UIColor whiteColor];
}

//- (UIView *)baseBackgroundView {
//  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundCloth.jpg"]] autorelease];
//  return bgView;
//}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Setup Views
  [self setupHeader];
  [self setupSubviews];
  
  [self setupPullRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadDataSource];
}

#pragma mark - Config Subviews
- (void)setupHeader {
  static CGFloat margin = 10.0;
  UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0)];
  headerView.userInteractionEnabled = YES;
  [headerView setImage:[UIImage stretchableImageNamed:@"BackgroundNavigationBar" withLeftCapWidth:0.0 topCapWidth:1.0]];
  
  UIButton *leftButton = [UIButton buttonWithFrame:CGRectMake(margin, 6.0, 28.0, 32.0) andStyle:nil target:self action:@selector(test)];
  [leftButton setImage:[UIImage imageNamed:@"IconBackBlack"] forState:UIControlStateNormal];
  [leftButton setImage:[UIImage imageNamed:@"IconBackGray"] forState:UIControlStateHighlighted];
  [headerView addSubview:leftButton];
  
  UILabel *titleLabel = [UILabel labelWithText:@"Timeline" style:@"navigationTitleLabel"];
  titleLabel.frame = CGRectMake(0, 0, headerView.width - 80.0, headerView.height);
  titleLabel.center = headerView.center;
  [headerView addSubview:titleLabel];
  
  UIButton *rightButton = [UIButton buttonWithFrame:CGRectMake(headerView.width - 28.0 - margin, 6.0, 28.0, 32.0) andStyle:nil target:self action:@selector(snap)];
  [rightButton setImage:[UIImage imageNamed:@"IconCameraBlack"] forState:UIControlStateNormal];
  [rightButton setImage:[UIImage imageNamed:@"IconCameraGray"] forState:UIControlStateHighlighted];
  [headerView addSubview:rightButton];
  
  [self setHeaderView:headerView];
  [headerView release];
}

- (void)setupSubviews {
  [self setupTableViewWithFrame:CGRectMake(0.0, self.headerView.height, self.view.width, self.view.height - self.headerView.height) style:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine separatorColor:[UIColor lightGrayColor]];
}

#pragma mark - Actions
- (void)test {
  BOOL sb = [UIApplication sharedApplication].statusBarHidden;
  [[UIApplication sharedApplication] setStatusBarHidden:!sb];
}

- (void)snap {
  UIActionSheet *as = nil;
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    as = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", nil] autorelease];
  } else {
    as = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", nil] autorelease];
  }
  [as showInView:[APP_DELEGATE window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == actionSheet.cancelButtonIndex) return;
//  CameraViewController *cvc = [[CameraViewController alloc] initWithNibName:nil bundle:nil];
//  [self.psNavigationController pushViewController:cvc animated:YES];
//  [cvc release];
  UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    if (buttonIndex == 0) {
      sourceType = UIImagePickerControllerSourceTypeCamera;
    }
  }
  
//  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.allowsEditing = NO;
  imagePicker.delegate = self;
  imagePicker.sourceType = sourceType;
  imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
  [self.psNavigationController pushViewController:imagePicker animated:YES];
  [imagePicker release];
}

- (void)getExifFromData:(NSData *)data {
  CGImageSourceRef ref = CGImageSourceCreateWithData((CFDataRef)data, NULL);
  NSDictionary *dict = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(ref
                                                                          , 0, NULL);
  NSDictionary *exif = [dict objectForKey:(NSString *)kCGImagePropertyExifDictionary];
  NSDictionary *gps = [dict objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
  NSDictionary *tiff = [dict objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
  
  NSLog(@"METADATA: %@", dict);
  NSLog(@"Exif: %@", exif);
  NSLog(@"GPS: %@", gps);
  NSLog(@"TIFF: %@", tiff);
}

- (void)uploadPhotoWithAssetURL:(NSURL *)assetURL {
  ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset) {
    // Read properties
//    NSString *assetType = [asset valueForProperty:ALAssetPropertyType];
//    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
    
    // Get representation
    ALAssetRepresentation *rep = [asset defaultRepresentation];
//    ALAssetOrientation assetOrientation = [rep orientation];
//    CGFloat assetScale = [rep scale];
    
    // Read metadata from original
    NSDictionary *metadata = [rep metadata];
    NSString *uti = [rep UTI];
    
    // get full res image
    CGImageRef imageRef = [rep fullResolutionImage];
    
    /**
     Scale image
     
     When scaling we don't want to pass in the orientation.
     Raw data is written with EXIF orientation
     
     If we scale with orientation transform, the image will be double-rotated once during scale and another during EXIF rotation
     */
    CGImageRef scaledImageRef = CreateCGImageWithinSize(imageRef, CGSizeMake(720.0, 720.0), UIImageOrientationUp);
    CGFloat scaledWidth = CGImageGetWidth(scaledImageRef);
    CGFloat scaledHeight = CGImageGetHeight(scaledImageRef);
    
    // Make the metadata dictionary mutable so we can add/edit properties to it
    NSMutableDictionary *mutableMetadata = [[metadata mutableCopy] autorelease];
    
    // CGImageProperties
    // We are writing the scaled width and height into cgimage properties
    [mutableMetadata setObject:[NSNumber numberWithFloat:scaledWidth] forKey:(NSString *)kCGImagePropertyPixelWidth];
    [mutableMetadata setObject:[NSNumber numberWithFloat:scaledHeight] forKey:(NSString *)kCGImagePropertyPixelHeight];
    
    // EXIF
    NSMutableDictionary *exifDict = [[[mutableMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy] autorelease];
    if(!exifDict) {
      exifDict = [NSMutableDictionary dictionary];
      
      // We are writing the scaled width and height into exif
      [exifDict setObject:[NSNumber numberWithFloat:scaledWidth] forKey:(NSString *)kCGImagePropertyExifPixelXDimension];
      [exifDict setObject:[NSNumber numberWithFloat:scaledHeight] forKey:(NSString *)kCGImagePropertyExifPixelYDimension];
      
      if (exifDict) {
        [mutableMetadata setObject:exifDict forKey:(NSString *)kCGImagePropertyExifDictionary];
      }
    }
    
    // GPS
    NSMutableDictionary *gpsDict = [[[mutableMetadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary] mutableCopy] autorelease];
    if(!gpsDict) {
      gpsDict = [[PSLocationCenter defaultCenter] exifLocation];
      
      if (gpsDict) {
        [mutableMetadata setObject:gpsDict forKey:(NSString *)kCGImagePropertyGPSDictionary];
      }
    }

    // Write out the new CGImage with metadata to NSMutableData
    NSMutableData *scaledData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)scaledData, (CFStringRef)uti, 1, NULL);
    
    // add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImage(destination, scaledImageRef, (CFDictionaryRef)mutableMetadata);
    
    CGImageDestinationFinalize(destination);
    
    [self getExifFromData:scaledData];
    
    [self uploadPhotoWithData:scaledData width:scaledWidth height:scaledHeight metadata:metadata];
    
    
    
    // Read raw data
//    long long assetSize = rep.size;
//    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*assetSize);
//    NSError *error = nil;
//    [rep getBytes:buffer fromOffset:0 length:assetSize error:&error];
//    if (error) {
//      NSLog(@"Default Representation getBytes with error: %@", error);
//    }
//    NSData *rawData = [NSData dataWithBytesNoCopy:buffer length:assetSize freeWhenDone:YES];
    
    // get full res image
//    CGImageRef imageRef = [rep fullResolutionImage];
//    CGImageRef scaledImageRef = CreateCGImageWithinSize(imageRef, CGSizeMake(720.0, 720.0), (UIImageOrientation)assetOrientation);
//    UIImage *scaledImage = [UIImage imageWithCGImage:imageRef scale:assetScale orientation:(UIImageOrientation)assetOrientation];
//
//    CGFloat scaledWidth = CGImageGetWidth(scaledImageRef);
//    CGFloat scaledHeight = CGImageGetHeight(scaledImageRef);
    
//    [self getExifFromData:rawData];
    
//    [self uploadPhotoWithData:rawData];
    
  };
  
  ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
    NSLog(@"cant get image - %@", [error localizedDescription]);
  };
  
  ALAssetsLibrary *assetsLibrary = [[[ALAssetsLibrary alloc] init] autorelease];
  [assetsLibrary assetForURL:assetURL resultBlock:resultBlock failureBlock:failureBlock];
}

- (void)uploadPhotoWithData:(NSData *)data width:(CGFloat)width height:(CGFloat)height metadata:(NSDictionary *)metadata {
  // Read out metadata
  // width
  // height
  // datetime
  // gps - lat, lng
  NSNumber *exifWidth = [NSNumber numberWithFloat:width];
  NSNumber *exifHeight = [NSNumber numberWithFloat:height];
  
  NSDictionary *exif = [metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
  NSDictionary *gps = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
  
  NSMutableString *exifDatetime = nil;
  if (exif) {
    NSString *unformattedDateAsString = [exif objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
    
    exifDatetime = [[unformattedDateAsString mutableCopy] autorelease];
    //make sure the date stored in the metadata is not nil, and contains a meaningful date
    if(exifDatetime && ![exifDatetime isEqualToString:@""] && ![exifDatetime isEqualToString:@"0000:00:00 00:00:00"]) {
      // the date (not the time) part of the string needs to contain dashes, not colons, for NSDate to read it correctly
      [exifDatetime replaceOccurrencesOfString:@":" withString:@"-" options:0 range:NSMakeRange(0, 10)]; //the first 10 characters are the date part
      //the EXIF spec does not allow the time zone to be saved with the date,
      // so we must assume the camera’s clock is set to the same time zone as the computer’s.
      [exifDatetime appendString:@" +0000"];
    }
  }
  
  NSString *exifLatitude = nil;
  NSString *exifLongitude = nil;
  if (gps) {
    exifLatitude = [gps objectForKey:(NSString *)kCGImagePropertyGPSLatitude];
    exifLongitude = [gps objectForKey:(NSString *)kCGImagePropertyGPSLongitude];
  }
  
  // Set parameters
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[NSNumber numberWithBool:YES] forKey:@"hasExif"];
  if (exifDatetime) [params setObject:exifDatetime forKey:@"exifDatetime"];
  if (exifLatitude) [params setObject:exifLatitude forKey:@"exifLatitude"];
  if (exifLongitude) [params setObject:exifLongitude forKey:@"exifLongitude"];
  if (exifWidth) [params setObject:exifWidth forKey:@"exifWidth"];
  if (exifHeight) [params setObject:exifHeight forKey:@"exifHeight"];
  
  // Upload
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload", API_BASE_URL]];
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
  NSData *uploadData = data;
  NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:uploadData name:@"photo" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
  }];
  
  AFHTTPRequestOperation *op = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
  
  [op setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
    NSLog(@"Sent %d of %d bytes", totalBytesWritten, totalBytesExpectedToWrite);
  }];
  
  NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
  [queue addOperation:op];
}

#pragma mark - State Machine
- (void)loadDataSource {
  [super loadDataSource];
  
//  NSString *jpegPath = [[NSBundle mainBundle] pathForResource:@"bubbles" ofType:@"jpg"];
//  NSData *jpegData = [NSData dataWithContentsOfFile:jpegPath];
  
//  UIImage *jpeg = [UIImage imageWithData:jpegData];
  
//  CGImageSourceRef ref = CGImageSourceCreateWithData((CFDataRef)jpegData, NULL);
//  NSDictionary *dict = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(ref
//                                                                          , 0, NULL);
//  NSDictionary *exif = [dict objectForKey:(NSString *)kCGImagePropertyExifDictionary];
//  NSDictionary *gps = [dict objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
//  
//  
//  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"albums" ofType:@"json"];
//  NSData *fixtureData = [NSData dataWithContentsOfFile:filePath];
//  NSDictionary *response = [fixtureData objectFromJSONData];
//
//  NSArray *items = [response objectForKey:@"data"];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/timeline", API_BASE_URL]]];
  AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
    
    NSArray *items = [JSON objectForKey:@"data"];
    if (items && [items count] > 0) {
      [self dataSourceShouldLoadObjects:[NSMutableArray arrayWithObject:items] shouldAnimate:NO];
    } else {
      [self dataSourceDidError];
    }
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
    [self dataSourceDidError];
  }];
  
  NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
  [queue addOperation:op];
}

- (void)dataSourceDidLoad {
  [super dataSourceDidLoad];
}

#pragma mark - TableView
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    default:
      return [TimelineCell class];
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [self cellClassAtIndexPath:indexPath];
  
  NSMutableDictionary *object = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  return [cellClass rowHeightForObject:object forInterfaceOrientation:self.interfaceOrientation];
}

- (void)tableView:(UITableView *)tableView configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
  NSMutableDictionary *object = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  [cell fillCellWithObject:object];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [self cellClassAtIndexPath:indexPath];
  id cell = nil;
  NSString *reuseIdentifier = [cellClass reuseIdentifier];
  
  cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if(cell == nil) { 
    cell = [[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    [_cellCache addObject:cell];
  }
  
  [self tableView:tableView configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

@end
