//
//  FilmViewController.h
//  OSnap
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSBaseViewController.h"
#import "PSFilmView.h"

@interface FilmViewController : PSBaseViewController <PSFilmViewDelegate, PSFilmViewDataSource> {
  NSMutableArray *_filmData;
  
  // Views
  PSFilmView *_filmView;
}

@end
