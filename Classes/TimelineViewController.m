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
#import "PreviewViewController.h"
#import "AFNetworking.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreLocation/CoreLocation.h>

@implementation TimelineViewController (CameraDelegateMethods)

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self.psNavigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  
  // Handle a still image capture
  if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
    
    PreviewViewController *pvc = nil;

    // First check if image was taken from camera or library
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
      // Taken with camera
      UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
      NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
      pvc = [[PreviewViewController alloc] initWithImage:image metadata:metadata];
    } else {
      // Picked from library
      UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
      NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
      if (assetURL) {
        pvc = [[PreviewViewController alloc] initWithImage:image assetURL:assetURL];
      }
    }
    
    if (pvc) {
      pvc.psNavigationController = self.psNavigationController;
      [picker pushViewController:pvc animated:YES];
      [pvc release];
    } else {
      [self.psNavigationController popViewControllerAnimated:YES];
    }
  } else {
    [self.psNavigationController popViewControllerAnimated:YES];
  }
}

@end

@interface TimelineViewController (Private)

- (void)snap;

- (void)loadFromRemote;
- (void)loadFromSavedPhotos;

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


#pragma mark - State Machine
- (void)loadDataSource {
  [super loadDataSource];
  
//  [self loadFromRemote];
  [self loadFromSavedPhotos];
  
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
  

}

- (void)dataSourceDidLoad {
  [super dataSourceDidLoad];
}

- (void)loadFromRemote {
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

- (void)loadFromSavedPhotos {
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  
  // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
  [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    
    if (group) {
      // Within the group enumeration block, filter to enumerate just photos.
      [group setAssetsFilter:[ALAssetsFilter allPhotos]];
      
      NSMutableArray *items = [NSMutableArray array];
      
      NSMutableArray *photos = [NSMutableArray array];
      
      [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
        if (result) {
          ALAssetRepresentation *rep = [result defaultRepresentation];
          
          NSURL *assetURL = [rep url];
          // NOTE: it is expensive to read out the metadata!!!
//          NSDictionary *metadata = [rep metadata];
          
#warning debug
//          if ([assetURL.absoluteString isEqualToString:@"assets-library://asset/asset.JPG?id=E6292758-C2C3-4077-A7AD-ED11C4BACF7A&ext=JPG"]) {
//            NSLog(@"debug");
//          }
          
          // Read out asset properties
//          NSNumber *assetWidth = [metadata objectForKey:(NSString *)kCGImagePropertyPixelWidth];
//          NSNumber *assetHeight = [metadata objectForKey:(NSString *)kCGImagePropertyPixelHeight];
          NSDate *assetDate = [result valueForProperty:ALAssetPropertyDate];
          CLLocation *assetLocation = [result valueForProperty:ALAssetPropertyLocation];
          
          // EXIF Optional
//          NSDictionary *exif = [metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
//          NSNumber *exifWidth = nil;
//          NSNumber *exifHeight = nil;
//          NSMutableString *exifDatetime = nil;
//          if (exif) {
//            // Width
//            exifWidth = [exif objectForKey:(NSString *)kCGImagePropertyExifPixelXDimension];
//            exifHeight = [exif objectForKey:(NSString *)kCGImagePropertyExifPixelYDimension];
//            
//            // Datetime
//            NSString *unformattedDateAsString = [exif objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
//            if (unformattedDateAsString) {
//              exifDatetime = [[unformattedDateAsString mutableCopy] autorelease];
//              //make sure the date stored in the metadata is not nil, and contains a meaningful date
//              if(exifDatetime && ![exifDatetime isEqualToString:@""] && ![exifDatetime isEqualToString:@"0000:00:00 00:00:00"]) {
//                // the date (not the time) part of the string needs to contain dashes, not colons, for NSDate to read it correctly
//                [exifDatetime replaceOccurrencesOfString:@":" withString:@"-" options:0 range:NSMakeRange(0, 10)]; //the first 10 characters are the date part
//                //the EXIF spec does not allow the time zone to be saved with the date,
//                // so we must assume the camera’s clock is set to the same time zone as the computer’s.
//                [exifDatetime appendString:@" +0000"];
//              }
//            }
//          }
          
          // GPS
//          NSDictionary *gps = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
//          
//          NSString *exifLatitude = nil;
//          NSString *exifLongitude = nil;
//          if (gps) {
//            exifLatitude = [gps objectForKey:(NSString *)kCGImagePropertyGPSLatitude];
//            exifLongitude = [gps objectForKey:(NSString *)kCGImagePropertyGPSLongitude];
//          }
          
          // Build array of PTPhoto based on Assets
          // Pass into dataSourcedidLoadObjects:
          NSMutableDictionary *photo = [[NSMutableDictionary alloc] init];
          [photo setObject:assetURL.absoluteString forKey:@"source"];
          if (assetDate) [photo setObject:assetDate forKey:@"timestamp"];
          if (assetLocation) [photo setObject:assetLocation forKey:@"location"];
//          if (assetWidth) [photo setObject:assetWidth forKey:@"width"];
//          if (assetHeight) [photo setObject:assetHeight forKey:@"height"];
          
//          NSLog(@"Adding photo: %@", photo);
          [photos addObject:photo];
          [photo release];
        }        
      }];
      
      NSArray *sortedPhotos = [photos sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
      
      unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
      
      NSDate *currentDate = nil;
      CLLocation *currentLocation = nil;
      for (NSDictionary *photo in sortedPhotos) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:[photo objectForKey:@"timestamp"]];
        NSDate *photoDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        CLLocation *photoLocation = [photo objectForKey:@"location"];
        currentLocation = photoLocation;
        
        // Begin a new day if no currentDate set or if photo date doesn't match
        if (!currentDate || (![currentDate isEqualToDate:photoDate])) {
          currentDate = photoDate;
          [items addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:currentDate, @"timestamp", currentLocation, @"location", nil]];
          [[items lastObject] setObject:[NSMutableArray arrayWithObject:photo] forKey:@"photos"];
        } else {
          // If photo is still part of current day, add to array
          [[[items lastObject] objectForKey:@"photos"] addObject:photo];
        }
      }
      
      [self dataSourceShouldLoadObjects:[NSMutableArray arrayWithObject:items] shouldAnimate:NO];
    }

  } failureBlock: ^(NSError *error) {
    NSLog(@"No groups");
  }];
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
