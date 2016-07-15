//
//  GetInForTableViewController.m
//  Material
//
//  Created by wayne on 16/5/13.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "GetInForTableViewController.h"
#import "RuKuDetailTableViewController.h"
#import "TuoTableViewController.h"
#import "TuoStore.h"
#import "XiangStore.h"
#import "KeychainItemWrapper.h"
#import "Tuo.h"
#import "KeychainItemWrapper.h"
#import "AFNetOperate.h"
#import "XiangTableViewCell.h"
#import "Xiang.h"
#import "MJRefresh.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MovementList.h"
#import "TuoTableViewCell.h"
#import "XiangTableViewCell.h"
#import "TuoScanViewController.h"
@interface GetInForTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *continueRuKu;
@property(strong,nonatomic)NSString *listNumber;
- (IBAction)continueRuKu:(id)sender;
@property (strong,nonatomic)UIAlertView *alert;
@property(strong,nonatomic)NSString *rukuList;
@property (strong,nonatomic)Xiang *xianglist;

@property(strong, nonatomic) NSMutableArray *dataArray;
@property NSString *movementListID;

@end

@implementation GetInForTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tuo=[[Tuo alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.userID=@"";
    KeychainItemWrapper *keyChain =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                        accessGroup:nil];
    if ([keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
        self.userID = [NSString
                       stringWithFormat:@"%@",
                       [keyChain objectForKey:(__bridge id)kSecAttrAccount]];
    }
    
    
    ///////////////////
    
    if ([self.listState isEqualToString:@"FINISH"]) {
        self.continueRuKu.enabled=NO;
    }else{
        self.continueRuKu.enabled=YES;
    }
    
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
    self.navigationItem.leftBarButtonItem.title=@"";
    [self customController];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customController {
    
    self.tableView.header =
    [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.header beginRefreshing];
}
#pragma mark - 筛选显示的状态
////////////////////////this
-(void)loadData
{
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    
    TuoStore *tuoStore=[[TuoStore alloc] init];
    tuoStore.listArray=[[NSMutableArray alloc] init];
    [manager GET:[AFNet getMovementResources]
      parameters:@{
                   @"movement_list_id" : self.listID
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if ([responseObject[@"result"] integerValue] == 1) {
                 [self.dataArray removeAllObjects];
                 
                 NSArray *resultArray = responseObject[@"content"];
                 
                 for (int i = 0; i < resultArray.count; i++) {
                     MovementList *ml =[[MovementList alloc] initWithObject:resultArray[i]];
                     [self.dataArray addObject:ml];
                     
                 }
                 [self.tableView reloadData];
                 
             } else {
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString
                           stringWithFormat:@"%@", [error localizedDescription]]];
         }];
                  [self.tableView.header endRefreshing];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MovementList *movementList = (MovementList *)self.dataArray [indexPath.row];
    XiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    cell.key.text=movementList.packageId;
    cell.partNumber.text=movementList.partNr;
    cell.date.text=movementList.fifo;
    cell.quantity.text=movementList.qty;
    
//    cell.date.text=[self.scanStandard filterDate:movementList.fifo];
    

    if ([self.listState isEqualToString:@"FINISH"]) {
            cell.stateLabel.text = @"已入库";
            cell.position.text=movementList.position;
    }else{
            cell.stateLabel.text = @"未入库";
            cell.position.text=@"";
    }

    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete_movement_source
        // Delete the row from the data source
        int row=indexPath.row;
        MovementList *tuoRetain=[[[MovementList alloc] init] copyMe:[self.dataArray objectAtIndex:row]];
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager DELETE:[AFNet delete_movement_source]
             parameters:@{
                          @"movement_source_id":tuoRetain.ID
                          }
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                              message:@"删除成功！"
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
                         AudioServicesPlaySystemSound(1012);
                        [self.dataArray removeObjectAtIndex:indexPath.row];
                        [self.tableView reloadData];
                        [self.alert show];
                        
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                        [self.tableView reloadData];
                        [self.alert show];
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                }
         ];
        
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int row = indexPath.row;
//    MovementList *rukuList = (MovementList *)self.dataArray [indexPath.row];
//    //    Xiang *Retain = [[[Xiang alloc]init] copyMe:[self.dataArray objectAtIndex:row]];
//    self.rukuList= [NSString stringWithFormat:@"%@",rukuList.ID];
//    [self performSegueWithIdentifier:@"rukuDetail" sender:@{@"rukuDetail":rukuList}];

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TuoScanViewController *scan=segue.destinationViewController;
    scan.type=@"contnruku";
    scan.hideCheckButton=YES;
    scan.listID=self.listID;
    scan.userID=self.userID;

}

- (IBAction)continueRuKu:(id)sender {
    if (self.dataArray.count == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                      message:@"没有任何入库内容"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }else{
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
                  
                  AudioServicesPlaySystemSound(1012);
                  self.dataArray = [[NSMutableArray alloc] init];
                  [self.alert show];
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
    
}

-(void)removeAlert:(NSTimer *)timer{
    UIAlertView *alert = [[timer userInfo]  objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dissmissAlert:(NSTimer *)timer
{
    if(self.alert){
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
        self.alert=nil;
    }
}

@end
