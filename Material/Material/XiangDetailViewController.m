//
//  XiangDetailViewController.m
//  Material
//
//  Created by wayne on 16/4/19.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "XiangDetailViewController.h"
#import "ScanStandard.h"
#import "UserPreference.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XiangDetailTableViewCell.h"
#import "XiangDetail.h"
#import "XiangDetailModel.h"

@interface XiangDetailViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *fifo;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;

@property (strong,nonatomic)ScanStandard *scanStandard;
@property (strong,nonatomic)UserPreference *userPref;
@property(strong,nonatomic)NSMutableArray *xiangdetailist;

@property (strong,nonatomic)UIAlertView *alert;
@property (strong, nonatomic) UITextField *firstResponder;


@property (strong,nonatomic) XiangDetailTableViewCell *tableviewCell;

@property(strong,nonatomic)XiangDetailModel *XiangItem;

@property (nonatomic) int xiang_detail_count;
@property(nonatomic)NSDictionary *parameters;
@property NSString *partNumberDeleteP;

- (IBAction)sureToInput:(id)sender;

@end
@implementation XiangDetailViewController


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
    [self clearExtraLine:self.xiangTable];
    // Do any additional setup after loading the view.
    self.key.delegate = self;
    self.partNumber.delegate=self;
    self.quantity.delegate=self;
    self.fifo.delegate=self;
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    self.alert=nil;
    UINib *nib=[UINib nibWithNibName:@"XiangDetailTableViewCell" bundle:nil];

    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"xiangCell"];
    self.xiangdetailist=[[NSMutableArray alloc]init];
    
    [self.xiangTable reloadData];
    
    self.scanStandard=[ScanStandard sharedScanStandard];

    self.userPref=[UserPreference sharedUserPreference];
}

-(void)popout
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self.key becomeFirstResponder];
    [self.xiangTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex==1){
////        [self performSegueWithIdentifier:@"scanToPrint" sender:@{@"container":self.tuo}];
//    }
//}
-(void)enterPackageCheck{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET: [AFNet xiang_index]
    parameters: @{@"package_id":self.key.text}
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [AFNet.activeView stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSString *message = @"唯一码已存在";
            
            self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(dissmissAlert:)
                                           userInfo:nil
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            [self.alert show];
            self.key.text = @"";
            
        }else{
            [self textFieldShouldReturn:self.firstResponder];
            [self.partNumber becomeFirstResponder];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AFNet.activeView stopAnimating];
        
    }];
}
-(void)enterPartNrCheck{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST: [AFNet part_validate]
      parameters: @{@"id":self.partNumberDeleteP}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if ([responseObject[@"result"] integerValue] == 0) {
                 NSString *message = @"零件不存在";
                 
                 self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
                 [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                  target:self
                                                selector:@selector(dissmissAlert:)
                                                userInfo:nil
                                                 repeats:NO];
                 AudioServicesPlaySystemSound(1051);
                 [self.alert show];
                 self.partNumber.text = @"";
                 
             }else{
                 [self textFieldShouldReturn:self.firstResponder];
                 [self.quantity becomeFirstResponder];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             
         }];
    
}
#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    self.firstResponder.text=[data copy];
    UITextField *targetTextField=self.firstResponder;
    if(targetTextField.tag==self.key.tag ){
        //唯一码
        NSString *alertString=@"请扫描唯一码";
        BOOL isMatch  = [self.scanStandard checkKey:data];
        if(isMatch){
            [self enterPackageCheck];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
    else if(targetTextField.tag==self.partNumber.tag){
        //part number
        NSString *alertString=@"请扫描零件号";
        BOOL isMatch  = [self.scanStandard checkPartNumber:data];
        if(isMatch){
            self.partNumberDeleteP=[self.scanStandard filterPartNumber:self.partNumber.text];
            [self enterPartNrCheck];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
    else if(targetTextField.tag==self.fifo.tag){
        //fifo
        NSString *alertString=@"请扫描FIFO";
        BOOL isMatch  = [self.scanStandard checkDate:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
        
    }
    else{
        //qty
        NSString *alertString=@"请扫描数量";
        BOOL isMatch  = [self.scanStandard checkQuantity:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
            
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
}

#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}

-(void)getPackageInfo{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet xiang_enter_stock]
       parameters: self.parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              [AFNet.activeView stopAnimating];
              
              if([responseObject[@"result"] integerValue]==1){
                  
                  if([(NSDictionary *)responseObject[@"content"] count]>0){
                      NSString *message = @"已完成全部入库！";
                      
                      self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
                      [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                       target:self
                                                     selector:@selector(dissmissAlert:)
                                                     userInfo:nil
                                                      repeats:NO];
                      [self.alert show];
                       AudioServicesPlaySystemSound(1012);
                      

                      
                  }else{
                      NSString *message = @"扫描入库失败，没有返回值";
                      
                      self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
                      [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                       target:self
                                                     selector:@selector(dissmissAlert:)
                                                     userInfo:nil
                                                      repeats:NO];
                      [self.alert show];
                      
                  }
              }else{
                  NSString *message = @"扫描入库失败，网络错误";
                  
                  self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
                  [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                   target:self
                                                 selector:@selector(dissmissAlert:)
                                                 userInfo:nil
                                                  repeats:NO];
                  
                  [self.alert show];
                  [AFNet alert:responseObject[@"content"]];
                  self.key.text=@"";
                  self.partNumber.text=@"";
                  self.quantity.text=@"";
                  self.fifo.text=@"";
                  [self.key becomeFirstResponder];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
          }
     ];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __block long tag=textField.tag;
    if(tag==self.fifo.tag){
        NSString *key=self.key.text?self.key.text:@"";
        NSString *partNumber=self.partNumber.text?self.partNumber.text:@"";
        NSString *quantity=self.quantity.text?self.quantity.text:@"";
        NSString *fifo=self.fifo.text?self.fifo.text:@"";
        
            //after regex partNumber
        NSString *partNumberPost=[self.scanStandard filterPartNumber:partNumber];
        //after regex quantity
        NSString *fifoPost=[self.scanStandard filterDate:fifo];
        NSString *quantityPost=[self.scanStandard filterQuantity:quantity];
        //after regex date
        if(key.length>0){
            
            self.parameters=[NSDictionary dictionary];

            self.parameters=@{@"package":
                                  @[@{
                             @"id":key,
                             @"part_id_display":partNumber,
                             @"part_id":partNumberPost,
                             @"quantity":quantityPost,
                             @"quantity_display":quantity,
                             @"custom_fifo_time":fifoPost,
                             @"fifo_time_display":fifo
                             },@{
                            @"id":key,
                            @"part_id_display":partNumber,
                            @"part_id":partNumberPost,
                            @"quantity":quantityPost,
                            @"quantity_display":quantity,
                            @"custom_fifo_time":fifoPost,
                            @"fifo_time_display":fifo
                                        } ]
                         };
            
            NSString *idValue;
            NSString *keyValue;
            NSString *partNrValue;
            NSString *quantityValue;
            
            idValue=self.key.text;
            keyValue=self.key.text;
            quantityValue=self.quantity.text;
            partNrValue=self.partNumber.text;
            
            
            self.XiangItem=[[XiangDetailModel alloc] initWith:idValue key:keyValue partNr:partNrValue quantity:quantityValue];
            
            XiangDetailModel *xiangdetailmodel=self.XiangItem;
            
            [self.xiangdetailist insertObject:xiangdetailmodel atIndex:0];
            
            [self.xiangTable reloadData];
            
            AudioServicesPlaySystemSound(1012);
            
            self.key.text=@"";
            
            self.partNumber.text=@"";
            
            self.quantity.text=@"";
            
            self.fifo.text=@"";
            
            [self.key becomeFirstResponder];

        }else{
            self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                            message:@"检查扫描参数"
                            delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
                             [NSTimer scheduledTimerWithTimeInterval:2.0f
                              target:self
                             selector:@selector(dissmissAlert:)
                              userInfo:nil
                              repeats:NO];
                            [self.alert show];

                }
    }
    else{
        tag+=10;
        UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
        [nextText becomeFirstResponder];
    }
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray * array=self.xiangdetailist[section];
    return [self.xiangdetailist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XiangDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    
   
        XiangDetailModel *xiangdetail=[self.xiangdetailist objectAtIndex:indexPath.row];
    

        cell.key.text=xiangdetail.Key;
        cell.partNr.text=xiangdetail.PartNr;
        cell.quantity.text=xiangdetail.Quantity;

    
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = NO;
        return cell;
}
-(void)clearExtraLine :(UITableView *)tableView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.xiangTable setTableFooterView:view];
}
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (IBAction)sureToInput:(id)sender {
    [self getPackageInfo];
    
    XiangDetailModel *xianglist = self.xiangdetailist[0];
    
    self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                                          message:[NSString stringWithFormat:@"%@",xianglist.PartNr]
                                         delegate:self
                                cancelButtonTitle:@"123"
                                otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:10.0f
                                     target:self
                                   selector:@selector(dissmissAlert:)
                                   userInfo:nil
                                    repeats:NO];
    [self.alert show];
}
@end
