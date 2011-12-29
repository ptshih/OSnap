//
//  TimelineViewController.m
//  OSnap
//
//  Created by Peter Shih on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TimelineViewController.h"
#import "TimelineCell.h"

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
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadDataSource];
}

#pragma mark - Config Subviews
- (void)setupHeader {
  UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0)];
  headerView.userInteractionEnabled = YES;
  [headerView setImage:[UIImage stretchableImageNamed:@"BackgroundNavigationBar" withLeftCapWidth:0.0 topCapWidth:1.0]];
  
  UIButton *leftButton = [UIButton buttonWithFrame:CGRectMake(10.0, 6.0, 30.0, 30.0) andStyle:nil target:self action:@selector(animatedBack)];
  [leftButton setImage:[UIImage imageNamed:@"IconBackBlack"] forState:UIControlStateNormal];
  [leftButton setImage:[UIImage imageNamed:@"IconBackGray"] forState:UIControlStateHighlighted];
  [headerView addSubview:leftButton];
  
  UILabel *titleLabel = [UILabel labelWithText:@"Timeline" style:@"navigationTitleLabel"];
  titleLabel.frame = CGRectMake(0, 0, headerView.width - 80.0, headerView.height);
  titleLabel.center = headerView.center;
  
  [headerView addSubview:titleLabel];
  
  [self setHeaderView:headerView];
  [headerView release];
}

- (void)setupSubviews {
  [self setupTableViewWithFrame:CGRectMake(0.0, self.headerView.height, self.view.width, self.view.height - self.headerView.height) style:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine separatorColor:[UIColor lightGrayColor]];
}


#pragma mark - State Machine
- (void)loadDataSource {
  [super loadDataSource];
  
  NSString *testSource = @"http://cdn.sinodefenceforum.com/avatars/mr-t.gif?dateline=1207083401";
  NSMutableDictionary *dict = nil;
  NSMutableArray *images = nil;
  
  NSMutableArray *items = [NSMutableArray array];
  
  NSMutableArray *section = [NSMutableArray array];
  
  dict = [NSMutableDictionary dictionary];
  images = [NSMutableArray array];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [dict setObject:images forKey:@"images"];
  [section addObject:dict];
  
  dict = [NSMutableDictionary dictionary];
  images = [NSMutableArray array];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [dict setObject:images forKey:@"images"];
  [section addObject:dict];
  
  dict = [NSMutableDictionary dictionary];
  images = [NSMutableArray array];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [dict setObject:images forKey:@"images"];
  [section addObject:dict];
  
  dict = [NSMutableDictionary dictionary];
  images = [NSMutableArray array];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:testSource, @"source", nil]];
  [dict setObject:images forKey:@"images"];
  [section addObject:dict];
  
  [items addObject:section];
  
  [self dataSourceShouldLoadObjects:items shouldAnimate:NO];
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
