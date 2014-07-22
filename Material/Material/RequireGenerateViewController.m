//
//  RequireGenerateViewController.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireGenerateViewController.h"
#import "RequireXiangTableViewCell.h"
#import "RequireXiang.h"
#import "RequirePrintViewController.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface RequireGenerateViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong, nonatomic) UITextField *firstResponder;
@property (strong,nonatomic)NSMutableArray *xiangArray;
- (IBAction)finish:(id)sender;
@end

@implementation RequireGenerateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.partTextField.delegate=self;
    self.positionTextField.delegate=self;
    self.quantityTextField.delegate=self;
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    UINib *nib=[UINib nibWithNibName:@"RequireXiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"cell"];
    self.xiangArray=[[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self.partTextField becomeFirstResponder];
 
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}
#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
     self.firstResponder.text=[data copy];
//     UITextField *targetTextField=self.firstResponder;
     [self textFieldShouldReturn:self.firstResponder];
}
#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    long tag=textField.tag;
    NSString *partNumber=self.partTextField.text;
    NSString *position=self.positionTextField.text;
    NSString *quantity=self.quantityTextField.text;
    if(tag==2){
        //有了位置可以显示出部门
    }
    if(partNumber.length>0&&position.length>0&&quantity.length>0){
        //发送请求
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet order_item_verify]
          parameters:@{
                        @"position":position,
                        @"part_id":partNumber,
                        @"quantity:":quantity
                               }
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"result"] integerValue]==1){
                     RequireXiang *xiang=[[RequireXiang alloc] initWithObject:responseObject[@"content"]];
                     [self.xiangArray addObject:xiang];
                      AudioServicesPlaySystemSound(1012);
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                                   message:@"添加成功"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles: nil];
                     [NSTimer scheduledTimerWithTimeInterval:2.1f
                                                      target:self
                                                    selector:@selector(dismissAlert:)
                                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                                     repeats:NO];
                     [alert show];
                     self.partTextField.text=@"";
                     self.positionTextField.text=@"";
                     self.quantityTextField.text=@"";
                     [self.xiangTable reloadData];
                 }
                 else{
                     [AFNet alert:responseObject[@"content"]];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [AFNet.activeView stopAnimating];
                 [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
             }
         ];
    }
    tag++;
    if(tag>3){
        tag=1;
    }
    UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
    [nextText becomeFirstResponder];
    return YES;
}
-(void)dismissAlert:(NSTimer *)timer
{
    UIAlertView *alert=[[timer userInfo] objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.xiangArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequireXiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RequireXiang *xiang=self.xiangArray[indexPath.row];
    cell.positionTextField.text=xiang.position;
    cell.partNumberTextField.text=xiang.partNumber;
    cell.quantityTextField.text=xiang.quantity;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.xiangArray removeObjectAtIndex:indexPath.row];
        [tableView cellForRowAtIndexPath:indexPath].alpha = 0.0;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"printFormGenerate"]){
        RequirePrintViewController *print=segue.destinationViewController;
        print.type=[sender objectForKey:@"type"];
    }
}


- (IBAction)finish:(id)sender {
//    [self performSegueWithIdentifier:@"printFormGenerate" sender:@{@"type":@"list"}];
    if(self.xiangArray.count>0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"确认发送需求？"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请添加至少一个零件"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles: nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //发送运单
    if(buttonIndex==1){
        NSMutableArray *postItems=[[NSMutableArray alloc] init];
        for(int i=0;i<self.xiangArray.count;i++){
            RequireXiang *xiang=self.xiangArray[i];
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:xiang.position,@"position",xiang.partNumber,@"part_id",xiang.quantity,@"quantity", nil];
            [postItems addObject:dic];
        }
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet order_root]
           parameters:@{
                        @"order_items":postItems
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      [self performSegueWithIdentifier:@"printFormGenerate" sender:@{@"type":@"list"}];
                  }
                  else{
                      [AFNet alert:responseObject[@"content"]];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
                  [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
              }
         ];
    }
}
@end
