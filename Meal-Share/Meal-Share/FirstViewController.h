//
//  FirstViewController.h
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/14/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

