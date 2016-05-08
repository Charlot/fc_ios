//
//  TuoTableViewController.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//
#import "RuKuTableTableViewController.h"
#import "TuoTableViewController.h"
#import "TuoScanViewController.h"
#import "XiangStore.h"
#import "Tuo.h"
#import "TuoEditViewController.h"
#import "AFNetOperate.h"
#import "Xiang.h"
#import "XiangTableViewCell.h"
@interface RuKuTableTableViewController ()
@property(nonatomic,strong)XiangStore *xiangStore;
@end

@implementation RuKuTableTableViewController

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
    self.navigationItem.leftBarButtonItem.title=@"";
    UINib *nib=[UINib nibWithNibName:@"XiangTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"xiangCell"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //得到数据
    [self selfState];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 筛选显示的状态
//this .......................
-(void)selfState
{
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"查看全部"
//                                                                           style:UIBarButtonItemStyleBordered
//                                                                          target:self
//                                                                          action:@selector(allState)];
    XiangStore *xiangStore=[[XiangStore alloc] init];
    xiangStore.xiangArray=[[NSMutableArray alloc] init];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    [AFNet.activeView stopAnimating];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [AFNet.activeView stopAnimating];
    [manager GET:[AFNet xiang_root]
      parameters:@{
                   @"state":@[@0,@1,@2,@3,@4],
                   @"type":@0
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             NSArray *xiangArrayResult=responseObject[@"content"];
             for(int i=0;i<xiangArrayResult.count;i++){
                 Xiang *xiangItem=[[Xiang alloc] initWithObject:xiangArrayResult[i]];
                 [xiangStore.xiangArray addObject:xiangItem];
             }
             self.xiangStore=xiangStore;
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];

}

-(void)allState
{
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"查看个人"
//                                                                           style:UIBarButtonItemStyleBordered
//                                                                          target:self
//                                                                          action:@selector(selfState)];
    XiangStore *xiangStore=[[XiangStore alloc] init];
    xiangStore.xiangArray=[[NSMutableArray alloc] init];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    [AFNet.activeView stopAnimating];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [AFNet.activeView stopAnimating];
    [manager GET:[AFNet xiang_root]
      parameters:@{
                   @"state":@[@0,@1,@2,@3,@4],
                   @"type":@0,
                   @"all":@YES
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             
             NSArray *xiangArrayResult=responseObject[@"content"];
             for(int i=0;i<xiangArrayResult.count;i++){
                 Xiang *xiangItem=[[Xiang alloc] initWithObject:xiangArrayResult[i]];
                 [xiangStore.xiangArray addObject:xiangItem];
             }
             self.xiangStore=xiangStore;
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.xiangStore xiangCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    Xiang *xiang=[[self.xiangStore xiangList] objectAtIndex:indexPath.row];
    cell.partNumber.text=xiang.number;
    cell.key.text=xiang.key;
    cell.quantity.text=xiang.count;
    cell.position.text=xiang.position;
    cell.date.text=xiang.date;
    cell.stateLabel.text=@"已入库";
    if(xiang.state==0){
        [cell.stateLabel setTextColor:[UIColor redColor]];
    }
    else if(xiang.state==1 || xiang.state==2){
        [cell.stateLabel setTextColor:[UIColor blueColor]];
    }
    else if(xiang.state==3){
        [cell.stateLabel setTextColor:[UIColor colorWithRed:87.0/255.0 green:188.0/255.0 blue:96.0/255.0 alpha:1.0]];
    }
    else if(xiang.state==4){
        [cell.stateLabel setTextColor:[UIColor orangeColor]];
    }
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//unwind
- (IBAction)unwindToXiangTable:(UIStoryboardSegue *)unwindSegue{
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
        
        int row=indexPath.row;
        Xiang *xiangRetain=[[[Xiang alloc] init] copyMe:[self.xiangStore.xiangList objectAtIndex:row]];
        
        
        dispatch_queue_t deleteRow=dispatch_queue_create("com.delete.row.pptalent", NULL);
        dispatch_async(deleteRow, ^{
            NSString *ID=[xiangRetain ID];
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            dispatch_async(dispatch_get_main_queue(), ^{
                [AFNet.activeView stopAnimating];
            });
            [manager DELETE:[AFNet xiang_index]
                 parameters:@{@"id":ID}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if([responseObject[@"result"] integerValue]==1){
                        }
                        else{
                            
                            [AFNet alert:responseObject[@"content"]];
                            [self viewWillAppear:YES];
                        }
                        
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                        [self viewWillAppear:YES];
                    }
             ];
        });
        
        [self.xiangStore removeXiang:row];
        [tableView cellForRowAtIndexPath:indexPath].alpha = 0.0;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[self.xiangStore.xiangList objectAtIndex:indexPath.row];
    if(xiang.state==0){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TuoScanViewController *scan=segue.destinationViewController;
    scan.type=@"ruku";
    scan.hideCheckButton=YES;
    
//    if([segue.identifier isEqualToString:@"tuoEdit"]){
//        TuoEditViewController *tuoEdit=segue.destinationViewController;
//        tuoEdit.tuo=[sender objectForKey:@"tuo"];
//    }
}

@end
