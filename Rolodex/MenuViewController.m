//
//  MenuViewController.m
//  Rolodex
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

#import "MenuCell.h"
#import "MenuProfileCell.h"

#import "PSDrawerController.h"
#import "ProfileViewController.h"
#import "RolodexViewController.h"

@implementation MenuViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
  RELEASE_SAFELY(_searchField);
}

- (void)dealloc {
  [super dealloc];
  
  // Views
  RELEASE_SAFELY(_searchField);
}

#pragma mark - View Config
- (UIView *)backgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundLeather.jpg"]] autorelease];
  return bgView;
}

- (UIView *)tableView:(UITableView *)tableView rowBackgroundViewForIndexPath:(NSIndexPath *)indexPath selected:(BOOL)selected {
  UIImageView *backgroundView = nil;
  if (!selected) {
    backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundCellLeather.png"]] autorelease];
    backgroundView.autoresizingMask = ~UIViewAutoresizingNone;
  }
  return backgroundView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Search
  UIView *searchView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0)] autorelease];
  searchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  UIImageView *searchBgView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BackgroundNavigationBar.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]] autorelease];
  searchBgView.autoresizingMask = searchView.autoresizingMask;
  [searchView addSubview:searchBgView];
  
  CGFloat searchWidth = searchView.width - 20;
  _searchField = [[PSSearchField alloc] initWithFrame:CGRectMake(10, 7, searchWidth, 30) style:PSSearchFieldStyleBlack];
  _searchField.delegate = self;
  _searchField.placeholder = @"Search";
//  [_searchField addTarget:self action:@selector(searchTermChanged:) forControlEvents:UIControlEventEditingChanged];
  [searchView addSubview:_searchField];
  
  [self.view addSubview:searchView];
  
  // Add a TableView
  [self setupTableViewWithFrame:CGRectMake(0, searchView.bottom, self.view.width, self.view.height - searchView.height) style:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone separatorColor:nil];
  
  [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if ([_searchField isFirstResponder]) {
    [_searchField resignFirstResponder];
  }
}

#pragma mark - State Machine
- (void)loadDataSource {
  [super loadDataSource];
  
  // Prepare Data
  NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
  
  if (!currentUser) {
    // User has not logged in yet
    return;
  }
  
  NSString *numConnections = [NSString stringWithFormat:@"%@", [currentUser objectForKey:@"numConnections"]];
  
  // First section
  NSMutableArray *items = [NSMutableArray array];
  
  // First section - Profile
  NSMutableArray *firstSection = [NSMutableArray array];
  NSDictionary *profile = currentUser;
  [firstSection addObject:profile];
  [items addObject:firstSection];
  
  // Second section
  NSMutableArray *secondSection = [NSMutableArray array];
  NSDictionary *connections = [NSDictionary dictionaryWithObjectsAndKeys:@"Connections", @"title", numConnections, @"subtitle", nil];
  [secondSection addObject:connections];
  [items addObject:secondSection];
  
  // Third section
  NSMutableArray *thirdSection = [NSMutableArray array];
  [items addObject:thirdSection];
  
  [self dataSourceShouldLoadObjects:items shouldAnimate:NO];
}

- (void)dataSourceDidLoad {
  [super dataSourceDidLoad];
}

#pragma mark - TableView
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0:
      return [MenuProfileCell class];
      break;
    case 1:
      return [MenuCell class];
      break;
    default:
      return [MenuCell class];
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

  if (section == 0 && row == 0) {
    // Current User Profile
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc = [[[[NSBundle mainBundle] loadNibNamed:@"PSNavigationController" owner:self options:nil] lastObject] retain];
    nc.viewControllers = [NSArray arrayWithObject:pvc];
    [pvc release];
    
    [APP_DELEGATE.drawerController setViewControllers:[NSArray arrayWithObjects:self, nc, nil]];
    [nc release];
  } else if (section == 1 && row == 0) {
    // Network - Connections
    RolodexViewController *rvc = [[RolodexViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc = [[[[NSBundle mainBundle] loadNibNamed:@"PSNavigationController" owner:self options:nil] lastObject] retain];
    nc.viewControllers = [NSArray arrayWithObject:rvc];
    [rvc release];
    
    [APP_DELEGATE.drawerController setViewControllers:[NSArray arrayWithObjects:self, nc, nil]];
    [nc release];
  } else if (section == 2) {
    // Rolodex
    RolodexViewController *rvc = [[RolodexViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc = [[[[NSBundle mainBundle] loadNibNamed:@"PSNavigationController" owner:self options:nil] lastObject] retain];
    nc.viewControllers = [NSArray arrayWithObject:rvc];
    [rvc release];
    
    [APP_DELEGATE.drawerController setViewControllers:[NSArray arrayWithObjects:self, nc, nil]];
    [nc release];
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0) return nil;
  
  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 23)] autorelease];
  headerView.autoresizingMask = ~UIViewAutoresizingNone;
  headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundSectionHeader.png"]];
  
  UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(MARGIN_X, 0, headerView.width - MARGIN_X * 2, headerView.height)] autorelease];
  [PSStyleSheet applyStyle:@"menuSectionHeader" forLabel:headerLabel];
  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];
  
  switch (section) {
    case 1:
      headerLabel.text = @"Your Network";
      break;
    case 2:
      headerLabel.text = @"Rolodex";
      break;
    default:
      break;
  }
  
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) return 0.0;
  else return 23.0;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [APP_DELEGATE hide];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [APP_DELEGATE hide];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (![textField isEditing]) {
    [textField becomeFirstResponder];
  }
  [textField resignFirstResponder];
  
  return YES;
}

@end
