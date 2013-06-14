//
//  ZJMasterViewController.m
//  TableViewDrawer
//
//  Created by Zhu Jiang on 13-6-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ZJMasterViewController.h"

@interface ZJMasterViewController() {
    NSMutableArray *dataArray_;
    NSIndexPath *selectedIndexPath_;
    
}
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation ZJMasterViewController
@synthesize drawerCell;
@synthesize selectedIndexPath = selectedIndexPath_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        self.selectedIndexPath = nil;
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!dataArray_) 
    {
        dataArray_ = [[NSMutableArray alloc] initWithCapacity:1];
    }
    for (int i = 0; i < 10 ; i ++)
    {
        [dataArray_ addObject:[NSString stringWithFormat:@"This is %d",i+1]];
    }
}

- (void)viewDidUnload
{
    [self setDrawerCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.selectedIndexPath ) {
//        return [dataArray_ count] + 1;
//    }
    return [dataArray_ count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath && indexPath.row == (self.selectedIndexPath.row + 1))
    {
        return self.drawerCell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        // Configure the cell.
        NSInteger row = indexPath.row;
//        if (indexPath.row > self.selectedIndexPath.row && self.selectedIndexPath)
//        {
//            row = indexPath.row - 1;
//        }
        cell.textLabel.text = [dataArray_ objectAtIndex:row];
        return cell;
    
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSIndexPath *lastIndexPath = nil;
    if (self.selectedIndexPath)
    {
        lastIndexPath = self.selectedIndexPath;
        [dataArray_ removeObjectAtIndex:lastIndexPath.row + 1];
        NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.selectedIndexPath.row + 1 inSection:self.selectedIndexPath.section]];
        self.selectedIndexPath = nil;
        [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if ([indexPath isEqual:lastIndexPath])
        {
            return;
        }

    }
    
   
    self.selectedIndexPath = indexPath;
    
    
    NSInteger row = 0;
    
    if (indexPath.row > lastIndexPath.row && lastIndexPath)
    {
        row = indexPath.row ;
    }
    else
    {
        row = indexPath.row + 1;
    }
    [dataArray_ insertObject:@"test" atIndex:row];
    self.selectedIndexPath  = [NSIndexPath indexPathForRow:row-1 inSection:indexPath.section]; 
    NSArray *insertArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:indexPath.section], nil];
    [tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationAutomatic];

}
- (void)popAlertWithTitle:(NSString *)title andMsg:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

}

- (IBAction)btn1Action:(id)sender {
    NSString *msg = [NSString stringWithFormat:@"cell %d clicked!",self.selectedIndexPath.row + 1];
    NSString *selector = NSStringFromSelector(_cmd);
    [self popAlertWithTitle:selector andMsg:msg];
}

- (IBAction)btn2Action:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    NSString *msg = [NSString stringWithFormat:@"cell %d clicked!",indexPath.row -1 + 1];
    NSString *selector = NSStringFromSelector(_cmd);
    [self popAlertWithTitle:selector andMsg:msg];
}

- (IBAction)btn3Action:(id)sender {
    NSString *msg = [NSString stringWithFormat:@"cell %d clicked!",self.selectedIndexPath.row + 1];
    NSString *selector = NSStringFromSelector(_cmd);
    [self popAlertWithTitle:selector andMsg:msg];
}
@end
