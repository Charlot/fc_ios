//
//  RuKuDetailTableViewController.m
//  Material
//
//  Created by wayne on 16/5/12.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "RuKuDetailTableViewController.h"
#import "KeychainItemWrapper.h"
#import "Tuo.h"
#import "AFNetOperate.h"
#import "Xiang.h"
#import "MJRefresh.h"
#import "XiangTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>


@interface RuKuDetailTableViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol,UIAlertViewDelegate>
- (IBAction)rukuButten:(id)sender;
@property (strong,nonatomic)UIAlertView *alert;
@property (strong,nonatomic)Xiang *xianglist;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RuKuDetailTableViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tuo=[[Tuo alloc] init];
    
//    self.userID=@"";
    KeychainItemWrapper *keyChain =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                        accessGroup:nil];
    if ([keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
        self.userID = [NSString
                       stringWithFormat:@"%@",
                       [keyChain objectForKey:(__bridge id)kSecAttrAccount]];
    }

//    self.tableView.dataSource=self;
//    self.tableView.delegate=self;
    
    UINib *nib=[UINib nibWithNibName:@"XiangTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"xiangCell"];
    
    self.alert=nil;
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
  
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customController];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customController {
    
    //    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    //  [backButton setTitle:@"取消" forState:UIControlStateNormal];
    //  [backButton addTarget:self
    self.tableView.header =
    [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.header beginRefreshing];
}
-(void)loadData{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    //    NSLog([AFNet getMovementResources]);
    
    [manager GET:[AFNet getMovementResources]
      parameters:@{@"movement_list_id":self.listID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 NSArray *xiangList=responseObject[@"content"];
                 for(int i=0;i<xiangList.count;i++){
                     Xiang *data=[[Xiang alloc] initWithObject:xiangList[i]];
                     [self.tuo.xiang addObject:data];
                 }
                 
                 
                [self.tableView.header endRefreshing];
                [self.tableView reloadData];

             }
             
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:@"something wrong"];
         }
     ];

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.tuo.xiang count];
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XiangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    
    
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    
    cell.partNumber.text=xiang.number;
    cell.key.text=xiang.key;
    cell.quantity.text=xiang.count;
    cell.position.text=xiang.position;
    cell.date.text=xiang.date;
    cell.stateLabel.text=@"待入库";
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.stateLabel setTextColor:[UIColor redColor]];
    
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
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //        delete_movement_source
        // Delete the row from the data source
            int row=indexPath.row;
            Xiang *tuoRetain=[[[Xiang alloc] init] copyMe:[self.tuo.xiang objectAtIndex:row]];
            NSString *ID=[NSString stringWithFormat:@"%d", tuoRetain.moveSourceId];
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager DELETE:[AFNet delete_movement_source]
                 parameters:@{
                              @"movement_source_id":ID
                              }
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [AFNet.activeView stopAnimating];
                        if([responseObject[@"result"] integerValue]==1){
                            self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                  message:@"删除成功！"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:nil];
                            [NSTimer scheduledTimerWithTimeInterval:0.9f
                                                             target:self
                                                           selector:@selector(dissmissAlert:)
                                                           userInfo:nil
                                                            repeats:NO];
                            [self.tuo.xiang removeObjectAtIndex:indexPath.row];
                            [self.tableView reloadData];
                            [self.alert show];
                            
                        }
                        else{
                            [AFNet alert:responseObject[@"content"]];
                            [self.alert show];
                        }
                        
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [AFNet.activeView stopAnimating];
                    }
             ];
            
            
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return YES;
 }


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)rukuButten:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet create_package_enter_stock]
       parameters:@{@"movement_list_id":self.listID,@"employee_id":self.userID}
     
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                        message:@"已完成全部入库"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
//                  [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                                   target:self
//                                                 selector:@selector(dissmissAlert:)
//                                                 userInfo:nil
//                                                  repeats:NO];
                  
                  AudioServicesPlaySystemSound(1012);
                  
                  [self.alert show];
//                  self.tuo=[[Tuo alloc] init];
//                  [self.xiangdetailist removeAllObjects];
                  [self.tableView reloadData];
              }else{
                  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                                message:@"失败，请检查是否有入库项"
                                                               delegate:self
                                                      cancelButtonTitle:@"不继续"
                                                      otherButtonTitles:nil];
                  [alert show];

}
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                            message:@"没有绑定任何箱，需要继续吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"不继续"
                                                  otherButtonTitles:@"继续操作", nil];
              [alert show];
          }];
}

@end
