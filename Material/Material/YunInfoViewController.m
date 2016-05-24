//
//  YunInfoViewController.m
//  Material
//
//  Created by wayne on 14-6-9.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunInfoViewController.h"
#import "Yun.h"
#import "PrintViewController.h"
#import "AFNetOperate.h"
#import "YunSendViewController.h"
@interface YunInfoViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tuoCountLabel;
@property (weak, nonatomic) IBOutlet UITextField *remark;
@property (strong,nonatomic) UIAlertView *printAlert;
- (IBAction)touchScreen:(id)sender;
- (IBAction)generateYun:(id)sender;
@end

@implementation YunInfoViewController

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
//    self.name.delegate=self;
    self.remark.delegate=self;
     
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tuoCountLabel.text=[NSString stringWithFormat:@"%d",(int)[self.yun.tuoArray count]];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=textField.frame;
    int offset=frame.origin.y-100;
    NSTimeInterval animationDuration=0.30f;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                     }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.remark resignFirstResponder];
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation



- (IBAction)touchScreen:(id)sender {
    [self.remark resignFirstResponder];
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}

- (IBAction)generateYun:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    NSMutableArray *tuoArrayID=[[NSMutableArray alloc] init];
    for(int i=0;i<self.yun.tuoArray.count;i++){
        [tuoArrayID addObject:[self.yun.tuoArray[i] ID]];
    }
    
    [manager POST:[AFNet yun_index]
       parameters:@{
                    @"delivery":@{
                            @"remark":self.remark.text,
//                            @"order_id":self.yun.orderId==nil ? @"":self.yun.orderId
                            @"order_id":self.orderId==nil ? @"":self.orderId
                            },
                    @"forklifts":tuoArrayID
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  if([(NSDictionary *)responseObject[@"content"] count]>0){
                      self.yun.ID=[responseObject[@"content"] objectForKey:@"id"];
                      self.yun.remark=self.remark.text;
                      [self performSegueWithIdentifier:@"send" sender:self];
                  }
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
//-(void)generateBelongs
//{
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"发送运单"
//                                                  message:@"是否发送运单"
//                                                 delegate:self
//                                        cancelButtonTitle:@"不发送"
//                                        otherButtonTitles:@"发送", nil];
//    [alert show];
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //发送运单
//    if(buttonIndex==1){
//        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//        [manager POST:[AFNet yun_send]
//           parameters:@{@"id":self.yun.ID}
//              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  [AFNet.activeView stopAnimating];
//                  if([responseObject[@"result"] integerValue]==1){
//                      [self performSegueWithIdentifier:@"printYun" sender:@{@"yun":self.yun,@"content":responseObject[@"content"]}];
//                  }
//                  else{
//                      [AFNet alert:responseObject[@"content"]];
//                  }
//                  
//              }
//              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  [AFNet.activeView stopAnimating];
//                  [AFNet alert:[NSString stringWithFormat:@"%@",error.localizedDescription]];
//              }
//         ];
//    }
//    else{
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"printYun"]){
        PrintViewController *yunPrint=segue.destinationViewController;
        yunPrint.container=[sender objectForKey:@"yun"];
        yunPrint.noBackButton=@1;
        yunPrint.enableSend=YES;
    }
    else if([segue.identifier isEqualToString:@"send"]){
        YunSendViewController *vc=segue.destinationViewController;
        vc.yun=self.yun;
    
    }
}
@end
