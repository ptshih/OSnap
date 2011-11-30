//
//  FilmViewController.h
//  Rolodex
//
//  Created by Peter Shih on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSViewController.h"
#import "PSFilmView.h"

@interface FilmViewController : PSViewController <PSFilmViewDelegate, PSFilmViewDataSource> {
  NSMutableArray *_filmData;
  
  // Views
  PSFilmView *_filmView;
}

@end
