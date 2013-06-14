//
//  ZJMasterViewController.h
//  TableViewDrawer
//
//  Created by Zhu Jiang on 13-6-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ZJMasterViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *drawerCell;

- (IBAction)btn1Action:(id)sender;
- (IBAction)btn2Action:(id)sender;
- (IBAction)btn3Action:(id)sender;

@end
