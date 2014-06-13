//
//  TuoTableViewController.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoTableViewController.h"
#import "TuoStore.h"
#import "Tuo.h"
#import "TuoEditViewController.h"
#import "AFNetOperate.h"

@interface TuoTableViewController ()
@property(nonatomic,strong)TuoStore *tuoStore;
@end

@implementation TuoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tuoStore=[TuoStore sharedTuoStore:self.tableView];
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuoStore tuoCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuo=[[self.tuoStore tuoList] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuoCell"];
    cell.textLabel.text=tuo.department ;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@   %@",tuo.date,tuo.agent];
    return cell;
}

//unwind
- (IBAction)unwindToTuoTable:(UIStoryboardSegue *)unwindSegue{
    [self.tableView reloadData];
}


// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        NSString *ID=[[self.tuoStore.tuoList objectAtIndex:indexPath.row] ID];
        [manager DELETE:[AFNet tuo_edit:ID]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if(responseObject[@"result"]){
                        [self.tuoStore removeTuo:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                }
         ]; 
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"tuoEdit"]){
        TuoEditViewController *tuoEdit=segue.destinationViewController;
        Tuo *tuo=[[self.tuoStore tuoList] objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
        tuoEdit.tuo=tuo;
    }
}

@end
