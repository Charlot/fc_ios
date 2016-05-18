//
//  TuoScanViewController.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoScanViewController.h"
#import "MovementAPI.h"
#import "TuoStore.h"
#import "UserPreference.h"
#import "Xiang.h"
#import "PrintViewController.h"
#import "Tuo.h"
#import "XiangEditViewController.h"
#import "AFNetOperate.h"
#import "XiangTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ScanStandard.h"
#import "SortArray.h"
#import "TuoCheckGeneralViewController.h"

@interface TuoScanViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quatity;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UILabel *xiangListLabel;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong,nonatomic)UIAlertView *alert;
@property (strong,nonatomic)ScanStandard *scanStandard;
@property (strong,nonatomic)UserPreference *userPref;
@property (weak, nonatomic) IBOutlet UILabel *xiangCountLabel;
@property (nonatomic)int sum_packages_count;
@property(nonatomic)NSDictionary *parameters;
@property NSString *partNumberDeleteP;
@property (strong,nonatomic)Xiang *xianglist;
- (IBAction)finish:(id)sender;
- (IBAction)checkXiang:(id)sender;
- (IBAction)clickScreen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@end

@implementation TuoScanViewController

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
    self.key.delegate=self;
    self.partNumber.delegate=self;
    self.quatity.delegate=self;
    self.dateTextField.delegate=self;
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    if([self.type isEqualToString:@"xiang"]){
        self.navigationItem.rightBarButtonItem=NULL;
        self.tuo=[[Tuo alloc] init];
    }
    else if([self.type isEqualToString:@"addXiang"]){
        self.navigationItem.rightBarButtonItem=NULL;
        self.xiangListLabel.text=@"已绑定箱数:";
    }
    else if([self.type isEqualToString:@"tuo"]){
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.title=self.tuo.department;
    }else if([self.type isEqualToString:@"ruku"]){
        self.tuo=[[Tuo alloc] init];
        self.navigationItem.rightBarButtonItem.title=@"确定入库";
        [self.xiangListLabel setHidden:true];
        [self.xiangCountLabel setHidden:true];
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet CreateMovementList]
           parameters:@{@"user_id":self.userID}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  Xiang *xiang=[[Xiang alloc] initWithObject:responseObject[@"content"]];
                 [self.tuo addXiang:xiang];
                   self.rukuList=xiang.listid;
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
                  
              }
         ];

    }
    self.xiangCountLabel.adjustsFontSizeToFitWidth=YES;
    UINib *nib=[UINib nibWithNibName:@"XiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"xiangCell"];
    self.alert=nil;
    self.scanStandard=[ScanStandard sharedScanStandard];
    self.sum_packages_count=[self.tuo.xiang count];
    [self updateXiangCountLabel];
    if(self.enablePop){
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(popout)];
    }
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
        if(self.hideCheckButton){
            self.checkButton.hidden=YES;
        }

}-(void)viewDidAppear:(BOOL)animated
{
        if ([self.type isEqualToString:@"ruku"]) {
             self.tuo=[[Tuo alloc] init];
        }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    self.firstResponder.text=[data copy];
    UITextField *targetTextField=self.firstResponder;
    if(targetTextField.tag==4 ){
        //date
        NSString *alertString=@"请扫描日期";
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
    else if(targetTextField.tag==2){
        //part number
        NSString *alertString=@"请扫描零件号";
        BOOL isMatch  = [self.scanStandard checkPartNumber:data];
        if(isMatch){
            //检查零件号合法性
            self.partNumberDeleteP=[self.scanStandard filterPartNumber:self.partNumber.text];
            if ([self.type isEqualToString:@"ruku"]) {
                AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                [manager POST: [AFNet part_validate]
                   parameters: @{@"id":self.partNumberDeleteP}
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          [AFNet.activeView stopAnimating];
                          if ([responseObject[@"result"] integerValue] == 0) {
                              NSString *message = @"零件不存在";
                              self.alert= [[UIAlertView alloc]initWithTitle:nil
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
//                              [self.quatity becomeFirstResponder];
                          }
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [AFNet.activeView stopAnimating];
                          
                      }];
            }else{
                [self textFieldShouldReturn:self.firstResponder];
                
            }
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
    else if(targetTextField.tag==3){
        //count
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
    else{
        //唯一码
        
        NSString *alertString=@"请扫描唯一码";
        BOOL isMatch  = [self.scanStandard checkKey:data];
        if(isMatch){
            
            //验证数据的合法性
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            //检查唯一码是否可用
            if ([self.type isEqualToString:@"ruku"]) {
                if (self.tuo.xiang.count > 0) {
                    NSMutableArray *KeyArray=[[NSMutableArray alloc] init];
                    for(int i = 0;i<self.tuo.xiang.count;i++){
                        Xiang *judgexiang=self.tuo.xiang[i];
                        [KeyArray addObject:judgexiang.key];
                    }
                    if ([KeyArray containsObject:self.key.text]) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                                      message:@"唯一码已存在"
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:nil];
                        [alert show];
                        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                         target:self
                                                       selector:@selector(removeAlert:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                                        repeats:NO];
                        AudioServicesPlaySystemSound(1051);
                        self.key.text=@"";
                    }else{
                        [self textFieldShouldReturn:self.firstResponder];
                    }

                }else{
                    [self textFieldShouldReturn:self.firstResponder];
                }
                
                            }else{
                [self textFieldShouldReturn:self.firstResponder];
                
            }
            [AFNet.activeView stopAnimating];
            NSString *address=[AFNet xiang_validate];
            dispatch_queue_t validate=dispatch_queue_create("com.validate.pptalent", NULL);
            dispatch_async(validate, ^{
                NSString *myData=data;
                if(self.tuo.ID.length>0 ){
                    [manager POST:address
                       parameters:@{@"id":myData}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [AFNet.activeView stopAnimating];
                              if([responseObject[@"result"] integerValue]==1){
                                  
                              }
                              else{
                                  NSDictionary *dic=[NSDictionary dictionary];
                                  if([self.userPref.location_id isEqualToString:@"FG"]){
                                      dic=@{
                                            @"id":self.tuo.ID,
                                            @"package_id":myData,
                                            @"check_whouse":@0
                                            };
                                  }
                                  else{
                                      dic=@{
                                            @"id":self.tuo.ID,
                                            @"package_id":myData
                                            };
                                  }
                                  AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                                  AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                                  [AFNet.activeView stopAnimating];
                                  [manager POST:[AFNet tuo_key_for_bundle]
                                     parameters:dic
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            if([responseObject[@"result"] integerValue]==1){
                                                //如果已经绑定了就直接添加
                                                if([(NSDictionary *)responseObject[@"content"] count]>0){
                                                    Xiang *xiang=[[Xiang alloc] initWithObject:responseObject[@"content"]];
                                                    [self.tuo addXiang:xiang];
                                                    [self.xiangTable reloadData];
                                                    [self.key becomeFirstResponder];
                                                    self.key.text=@"";
                                                    self.partNumber.text=@"";
                                                    self.quatity.text=@"";
                                                    self.dateTextField.text=@"";
                                                    [self updateAddXiangCount];
                                                    
                                                    NSString *result_code=responseObject[@"result_code"];
                                                    if([result_code isEqualToString:@"100"]){
                                                        AudioServicesPlaySystemSound(1012);
                                                        if(self.alert){
                                                            [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                                                            self.alert=nil;
                                                        }
                                                        self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                                              message:@"绑定成功！"
                                                                                             delegate:self
                                                                                    cancelButtonTitle:nil
                                                                                    otherButtonTitles:nil];
                                                        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                                         target:self
                                                                                       selector:@selector(dissmissAlert:)
                                                                                       userInfo:nil
                                                                                        repeats:NO];
                                                        [self.alert show];
                                                    }
                                                    else if([result_code isEqualToString:@"101"]){
                                                        AudioServicesPlaySystemSound(1051);
                                                        UIAlertView *positionAlert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                                                                              message:@"请确认部门是否正确"
                                                                                                             delegate:self
                                                                                                    cancelButtonTitle:@"确定"
                                                                                                    otherButtonTitles:nil];
                                                        [positionAlert show];
                                                    }
                                                }
                                            }
                                            else{
                                                [AFNet alert:responseObject[@"content"]];
                                                AudioServicesPlaySystemSound(1051);
                                                targetTextField.text=@"";
                                                [targetTextField becomeFirstResponder];
                                            }
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            [AFNet.activeView stopAnimating];
                                            [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                                            targetTextField.text=@"";
                                            [targetTextField becomeFirstResponder];
                                        }
                                   ];

                              }
                              
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [AFNet.activeView stopAnimating];
                              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                              targetTextField.text=@"";
                              [targetTextField becomeFirstResponder];
                          }
                     ];
   
                }
                else{
                    
                    [manager POST:address
                       parameters:@{@"id":data}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [AFNet.activeView stopAnimating];
                              if([responseObject[@"result"] integerValue]==1){
                                  
                              }
                              else{
                                  [AFNet alert:responseObject[@"content"]];
                                  AudioServicesPlaySystemSound(1051);
                                  targetTextField.text=@"";
                                  [targetTextField becomeFirstResponder];
                              }
                              
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [AFNet.activeView stopAnimating];
                              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                              targetTextField.text=@"";
                              [targetTextField becomeFirstResponder];
                          }
                     ];
                    
                }
            });
            
            
            
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
-(void)removeAlert:(NSTimer *)timer{
    UIAlertView *alert = [[timer userInfo]  objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
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
    __block long tag=textField.tag;
    if(tag==4){
        
        if ([self.type isEqualToString:@"ruku"]) {
            if (self.partNumber.text.length > 0) {
                
                if (self.key.text.length>0 && self.partNumber.text.length>0 && self.quatity.text.length>0 && self.dateTextField.text.length>0) {
                    [self getPackageInfo];
                }else{
                    self.alert= [[UIAlertView alloc]initWithTitle:@"警告"
                                                          message:@"扫描数据不能为空"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
                    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                     target:self
                                                   selector:@selector(dissmissAlert:)
                                                   userInfo:nil
                                                    repeats:NO];
                    [self alert];
                    self.key.text=@"";
                    self.partNumber.text=@"";
                    self.quatity.text=@"";
                    self.dateTextField.text=@"";
                    [self.key becomeFirstResponder];
                    
                }
                
            }else{
                self.alert= [[UIAlertView alloc]initWithTitle:nil
                                                      message:@"零件号不可为空"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
                [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                 target:self
                                               selector:@selector(dissmissAlert:)
                                               userInfo:nil
                                                repeats:NO];
                 AudioServicesPlaySystemSound(1051);
                [self.alert show];
            }
            self.key.text=@"";
            self.partNumber.text=@"";
            self.quatity.text=@"";
            self.dateTextField.text=@"";
            [self.key becomeFirstResponder];

        }else{
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            NSString *key=self.key.text?self.key.text:@"";
            NSString *partNumber=self.partNumber.text?self.partNumber.text:@"";
            NSString *quantity=self.quatity.text?self.quatity.text:@"";
            NSString *date=self.dateTextField.text?self.dateTextField.text:@"";
            //after regex partNumber
            NSString *partNumberPost=[self.scanStandard filterPartNumber:partNumber];
            //after regex quantity
            NSString *quantityPost=[self.scanStandard filterQuantity:quantity];
            //after regex date
            NSString *datePost=[self.scanStandard filterDate:date];
            //拖下面的绑定，不仅绑定，而且会为拖加入新的箱
            NSDictionary *parameters=[NSDictionary dictionary];
            
        if(self.tuo.ID.length>0){
            
            if([self.userPref.location_id isEqualToString:@"FG"]){
                parameters=@{
                             @"id":self.tuo.ID,
                             @"package_id":key,
                             @"part_id":partNumberPost,
                             @"quantity":quantityPost,
                             @"custom_fifo_time":datePost,
                             @"part_id_display":partNumber,
                             @"quantity_display":quantity,
                             @"fifo_time_display":date,
                             @"check_whouse":@0,
                             };
            }
            else{
            parameters=@{
                         @"id":self.tuo.ID,
                          @"package_id":key,
                          @"part_id":partNumberPost,
                          @"quantity":quantityPost,
                             @"custom_fifo_time":datePost,
                             @"part_id_display":partNumber,
                             @"quantity_display":quantity,
                             @"fifo_time_display":date,

                         };

            }
            [manager POST:[AFNet tuo_bundle_add]
               parameters: parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      //箱绑定成功了
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          
                          Xiang *newXiang=[[Xiang alloc] initWithObject:responseObject[@"content"]];//alert “唯一好不可用”
                          [self.tuo addXiang:newXiang];
                          [self.xiangTable reloadData];
                          tag=1;
                          UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
                          [nextText becomeFirstResponder];
                          self.key.text=@"";
                          self.partNumber.text=@"";
                          self.quatity.text=@"";
                          self.dateTextField.text=@"";
                          [self updateAddXiangCount];
                          
                          
                          NSString *result_code=responseObject[@"result_code"];
                          if([result_code isEqualToString:@"100"]){
                              AudioServicesPlaySystemSound(1012);
                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                    message:@"绑定成功"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];
                              
                              [self.alert show];
                          }
                          else if([result_code isEqualToString:@"101"]){
                              AudioServicesPlaySystemSound(1051);
                              UIAlertView *positionAlert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                                                    message:@"请确认部门是否正确"
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"确定"
                                                                          otherButtonTitles:nil];
                              [positionAlert show];
                          }
                      }
                      else{
                          [AFNet alert:responseObject[@"content"]];
                          self.key.text=@"";
                          self.partNumber.text=@"";
                          self.quatity.text=@"";
                          self.dateTextField.text=@"";
                          [self.key becomeFirstResponder];
                      }
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
        }
        else{
            //箱绑定下的绑定
 
            [manager POST:[AFNet xiang_index]
               parameters:@{@"package":@{
                                    @"id":key,
                                    @"part_id":partNumberPost,
                                    @"quantity":quantityPost,
                                    @"custom_fifo_time":datePost,
                                    @"part_id_display":partNumber,
                                    @"quantity_display":quantity,
                                    @"fifo_time_display":date
                                    }    
                            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          if([(NSDictionary *)responseObject[@"content"] count]>0){
                              Xiang *newXiang=[[Xiang alloc] initWithObject:responseObject[@"content"]];
                              [self.tuo addXiang:newXiang];
                              [self.xiangTable reloadData];
                              tag=1;
                              UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
                              [nextText becomeFirstResponder];
                              self.key.text=@"";
                              self.partNumber.text=@"";
                              self.quatity.text=@"";
                              self.dateTextField.text=@"";
                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                    message:@"绑定成功！"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:0.9f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];
                              AudioServicesPlaySystemSound(1012);
                              [self.alert show];
                              [self updateAddXiangCount];
                          }
                          
                      }
                      else{
                          [AFNet alert:responseObject[@"content"]];
                          self.key.text=@"";
                          self.partNumber.text=@"";
                          self.quatity.text=@"";
                          self.dateTextField.text=@"";
                          [self.key becomeFirstResponder];
                      }
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
        }
    }
}
    
    else{
        tag++;
        UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
        [nextText becomeFirstResponder];
    }
    return YES;
}
-(void)dissmissAlert:(NSTimer *)timer
{
    if(self.alert){
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
        self.alert=nil;
    }
}
//table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuo.xiang count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    XiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    cell.partNumber.text=xiang.number;
    cell.key.text=xiang.key;
    cell.quantity.text=xiang.count;
    cell.position.text=xiang.position;
    cell.date.text=xiang.date;
    if ([self.type isEqualToString:@"ruku"]) {
        cell.stateLabel.text=@"待入库";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.stateLabel setTextColor:[UIColor redColor]];
    }else{
        cell.stateLabel.text=xiang.state_display;}
    
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
        if ([self.type isEqualToString:@"ruku"]) {
            
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
                            [self.xiangTable reloadData];
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

        
        }else{
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        
        [manager DELETE:[AFNet tuo_remove_xiang]
             parameters:@{
                          @"package_id":[[self.tuo.xiang objectAtIndex:indexPath.row] ID]
                          }
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        [self.tuo.xiang removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self updateMinusXiangCount];
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                }
         ];
        
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    Xiang *xiang=[[self.xiangStore xiangList] objectAtIndex:indexPath.row];
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    if([self.type isEqualToString:@"xiang"]){
       [self performSegueWithIdentifier:@"fromTuo" sender:@{
                                                            @"xiang":xiang,
                                                            @"xiangIndex":[NSNumber numberWithInteger:indexPath.row]
                                                            }
        ];
    }else if ([self.type isEqualToString:@"ruku"]){
        
    }
    else{
       [self performSegueWithIdentifier:@"fromTuo" sender:@{@"xiang":xiang}];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //单独绑定箱的时候，不让删除，会误导，在最外面删去
    if([self.type isEqualToString:@"xiang"]){
        return NO;
    }
    else{
        return YES;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"scanToPrint"]){
        PrintViewController *printViewController = segue.destinationViewController;
        printViewController.container=[sender objectForKey:@"container"];
        printViewController.noBackButton=@1;
        printViewController.enableSend=YES;
    }
    else if([segue.identifier isEqualToString:@"fromTuo"]){
        XiangEditViewController *xiangEdit=segue.destinationViewController;
        xiangEdit.xiang=[sender objectForKey:@"xiang"];
        if([self.type isEqualToString:@"xiang"]){
            xiangEdit.enableSend=YES;
            xiangEdit.xiangArray=self.tuo.xiang;
            xiangEdit.xiangIndex=[[sender objectForKey:@"xiangIndex"] intValue];
        }
    }
    else if([segue.identifier isEqualToString:@"checkXiang"]){
        TuoCheckGeneralViewController *tuoCheck=segue.destinationViewController;
        tuoCheck.xiangArray=[sender objectForKey:@"xiangArray"];
    }
}
//入库
-(void)getPackageInfo{
    NSString *key=self.key.text?self.key.text:@"";
    NSString *partNumber=self.partNumber.text?self.partNumber.text:@"";
    NSString *quantity=self.quatity.text?self.quatity.text:@"";
    NSString *date=self.dateTextField.text?self.dateTextField.text:@"";
    //after regex partNumber
    NSString *partNumberPost=[self.scanStandard filterPartNumber:partNumber];
    //after regex quantity
    NSString *quantityPost=[self.scanStandard filterQuantity:quantity];
    //after regex date
    NSString *datePost=[self.scanStandard filterDate:date];
    self.parameters=[NSDictionary dictionary];
    self.parameters=@{
                      @"movement_list_id":self.rukuList,
                      @"toWh":@"WE87",
                      @"toPosition":@"WE87-1",
                      @"packageId":key,
                      @"partNr":partNumberPost,
                      @"qty":quantityPost,
                      @"fifo":datePost,
                      @"type":@"ENTRY",
                      @"qty_dislplay":quantity,
                      @"part_display":partNumber,
                      @"fifo_display":date
                      };
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet ValidateMovement]
       parameters:self.parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
//                  if([(NSDictionary *)responseObject[@"content"] count]>0 ){
//                      if ((i+1) == self.tuo.xiang.count) {
                          self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                message:responseObject[@"content"]
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil];
                          [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                           target:self
                                                         selector:@selector(dissmissAlert:)
                                                         userInfo:nil
                                                          repeats:NO];
                          
                          AudioServicesPlaySystemSound(1012);
                          
                          [self.alert show];
//                            [self.tuo.xiang removeAllObjects];
                  self.xianglist = [[Xiang alloc] initWith:key partNumber:partNumber key:key count:quantity position:@"" remark:@"" date:date];
                  self.xianglist.moveSourceId=[(responseObject[@"object"][@"id"]) intValue];
                  [self.tuo addXiang:self.xianglist];
                   [self.xiangTable reloadData];
                          

              }else{
//                  NSString *message = @"扫描入库失败，网络错误";
                  
                  self.alert= [[UIAlertView alloc]initWithTitle:@"失败"
                                                        message:responseObject[@"content"]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
                  [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                   target:self
                                                 selector:@selector(dissmissAlert:)
                                                 userInfo:nil
                                                  repeats:NO];
                  
                  [self.alert show];
//                  [AFNet alert:responseObject[@"content"]];
                  self.key.text=@"";
                  self.partNumber.text=@"";
                  self.quatity.text=@"";
                  self.dateTextField.text=@"";
                  [self.key becomeFirstResponder];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
          }
     ];
      
//    }
}
- (IBAction)finish:(id)sender {
    if ([self.type isEqualToString:@"ruku"]) {
        if (self.tuo.xiang.count==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                          message:@"没有任何入库项，请扫描入库信息？"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:self.rukuList
//                                                          message:self.rukuList
//                                                         delegate:self
//                                                cancelButtonTitle:@"不继续"
//                                                otherButtonTitles:@"继续操作", nil];

            [alert show];

        }else{
//        [self getPackageInfo];
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager POST:[AFNet create_package_enter_stock]
               parameters:@{@"movement_list_id":self.rukuList,@"employee_id":self.userID}
            
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                              message:@"已完成全部入库"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
                        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                         target:self
                                                       selector:@selector(dissmissAlert:)
                                                       userInfo:nil
                                                        repeats:NO];
                        
                        AudioServicesPlaySystemSound(1012);
                        
                        [self.alert show];
                        self.tuo=[[Tuo alloc] init];
                        [self.xiangdetailist removeAllObjects];
                        [self.xiangTable reloadData];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                                      message:@"失败"
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
        
    }else {
        if(self.tuo.xiang.count==0){
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                     message:@"没有绑定任何箱，需要继续吗？"
                                                    delegate:self
                                           cancelButtonTitle:@"不继续"
                                           otherButtonTitles:@"继续操作", nil];
        [alert show];
    }
    else{
      [self performSegueWithIdentifier:@"scanToPrint" sender:@{@"container":self.tuo}];
     }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
         [self performSegueWithIdentifier:@"scanToPrint" sender:@{@"container":self.tuo}];
    }
}

- (IBAction)checkXiang:(id)sender {
    NSArray *xiangArray=[SortArray sortByPartNumber:self.tuo.xiang];
    [self performSegueWithIdentifier:@"checkXiang" sender:@{@"xiangArray":xiangArray}];
}

- (IBAction)clickScreen:(id)sender {
    [self.dateTextField resignFirstResponder];
}

-(void)updateAddXiangCount{
    self.sum_packages_count++;
    [self updateXiangCountLabel];
    self.tuo.sum_packages++;
}
-(void)updateMinusXiangCount{
    self.sum_packages_count--;
    [self updateXiangCountLabel];
    self.tuo.sum_packages--;
}
-(void)updateXiangCountLabel
{
    self.xiangCountLabel.text=[NSString stringWithFormat:@"%d",self.sum_packages_count];
}

@end
