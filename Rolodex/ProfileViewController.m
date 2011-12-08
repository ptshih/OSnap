//
//  ProfileViewController.m
//  Rolodex
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"

@implementation ProfileViewController

#pragma mark - Init
- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _profileDict = [dictionary copy];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_profileDict);
  [super dealloc];
}

#pragma mark - View Config
- (UIView *)baseBackgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundBlueprint.jpg"]] autorelease];
  return bgView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithImage:[UIImage imageNamed:@"IconMenu.png"] withTarget:APP_DELEGATE.drawerController action:@selector(slideFromLeft) width:50.0 height:30.0 buttonType:BarButtonTypeNormal];
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonWithImage:[UIImage imageNamed:@"IconMenu.png"] withTarget:APP_DELEGATE.drawerController action:@selector(slideFromRight) width:50.0 height:30.0 buttonType:BarButtonTypeNormal];
  
  // Add a TableView
  [self setupTableViewWithFrame:self.view.bounds style:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleNone separatorColor:nil];
  
  [self loadDataSource];
  
  PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
  [testObject setObject:@"bar" forKey:@"foo"];
  [testObject setObject:[NSNumber numberWithInt:1337] forKey:@"leet"];
  [testObject save];
}

#pragma mark - State Machine
- (void)loadDataSource {
  [super loadDataSource];
  
  // Items
  NSMutableArray *items = [NSMutableArray array];
  
  // First section - Profile Card
  NSMutableArray *firstSection = [NSMutableArray array];
  NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:@"Connections", @"title", @"asdfasdfadsf", @"subtitle", nil];
  [firstSection addObject:profile];
  [items addObject:firstSection];
  
  // Second section
  NSMutableArray *secondSection = [NSMutableArray array];
  [items addObject:secondSection];
  
  [self dataSourceShouldLoadObjects:items shouldAnimate:NO];
}

- (void)dataSourceDidLoad {
  [super dataSourceDidLoad];
}

#pragma mark - TableView
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0:
      return [ProfileCell class];
      break;
    case 1:
      return [ProfileCell class];
      break;
    default:
      return [ProfileCell class];
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [self cellClassAtIndexPath:indexPath];
  return [cellClass rowHeight];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;
  
  NSMutableDictionary *object = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  [APP_DELEGATE.drawerController hideFromRight];
  
}

@end
