//
//  ReceiveViewController.m
//  Material
//
//  Created by wayne on 14-11-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveViewController.h"
#import "ReceiveXiangViewController.h"
#import "ReceiveTuoViewController.h"
#import "ReceiveYunViewController.h"
#import "AFNetOperate.h"
#import "UserPreference.h"
@interface ReceiveViewController ()<CaptuvoEventsProtocol,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;


@property (strong,nonatomic)UserPreference *userPreference;

- (IBAction)test:(id)sender;
@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:209.0/255.0 green:42.0/255.0 blue:26.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view.
    self.scanTextField.delegate=self;
    [self.scanTextField becomeFirstResponder];
    
    
    self.userPreference=[UserPreference sharedUserPreference];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    self.scanTextField.text=@"";
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummy;
}
-(void)decoderDataReceived:(NSString *)data
{
    self.scanTextField.text=data;
    //扫描到对应的号码时应该去触发receive
    [self receive:self.scanTextField.text];
   }
//only for test use
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self receive:self.scanTextField.text];
    
//    NSString *data=  self.scanTextField.text;
//    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//    [manager POST:[AFNet movables]
//      parameters:@{@"id":data}
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             [AFNet.activeView stopAnimating];
//             if([responseObject[@"result"] integerValue]==1){
//                 int type=[responseObject[@"content"][@"type"] intValue];
//                 if(type==1){
//                     Xiang *xiang=[[Xiang alloc] initWithObject:responseObject[@"content"][@"object"]];
//                     [self performSegueWithIdentifier:@"receiveXiang" sender:@{@"title":data,@"xiang":xiang}];
//                 }
//                 else if(type==2){
//                     Tuo *tuo=[[Tuo alloc] initWithObject:responseObject[@"content"][@"object"]];
//                     [manager GET:[AFNet tuo_packages]
//                       parameters:@{@"id":tuo.ID}
//                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                              if([responseObject[@"result"] integerValue]==1){
//                                      NSArray *xiangList=responseObject[@"content"];
//                                      [tuo.xiang removeAllObjects];
//                                      for(int i=0;i<xiangList.count;i++){
//                                          Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
//                                          [tuo.xiang addObject:xiang];
//                                      }
//                                      [self performSegueWithIdentifier:@"receiveTuo" sender:@{@"title":data,@"tuo":tuo}];
//                              }
//                              else{
//                                  [AFNet alert:responseObject[@"content"]];
//                              }
//                              
//                          }
//                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                              [AFNet alert:@"something wrong"];
//                          }
//                      ];
//
//                 }
//                 else if(type==3){
//                     Yun *yun=[[Yun alloc] initWithObject:responseObject[@"content"][@"object"]];
//                     [manager GET:[AFNet yun_folklifts]
//                       parameters:@{@"id":yun.ID}
//                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                              [AFNet.activeView stopAnimating];
//                              if([responseObject[@"result"] integerValue]==1){
//                                      NSArray *tuoArray=responseObject[@"content"];
//                                      [yun.tuoArray removeAllObjects];
//                                      for(int i=0;i<tuoArray.count;i++){
//                                          Tuo *tuoItem=[[Tuo alloc] initWithObject:tuoArray[i]];
//                                          [yun.tuoArray addObject:tuoItem];
//                                      }
//                                      [self performSegueWithIdentifier:@"receiveYun" sender:@{@"title":data,@"yun":yun}];
//                              }
//                              else{
//                                  [AFNet alert:responseObject[@"content"]];
//                              }
//                              
//                          }
//                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                              [AFNet.activeView stopAnimating];
//                              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
//                          }
//                      ];
//                 }
//             }
//             else{
//                 [AFNet alert:responseObject[@"content"]];
//             }
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             [AFNet.activeView stopAnimating];
//             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
//         }
//     ];
    return YES;
}

-(void)receive:(NSString *)data{

    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet movables]
       parameters:@{@"id":data}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  int type=[responseObject[@"content"][@"type"] intValue];
                  if(type==1){
                      Xiang *xiang=[[Xiang alloc] initWithObject:responseObject[@"content"][@"object"]];
                      self.scanTextField.text=@"";
                      [self performSegueWithIdentifier:@"receiveXiang" sender:@{@"title":data,@"xiang":xiang}];
                  }
                  else if(type==2){
                      Tuo *tuo=[[Tuo alloc] initWithObject:responseObject[@"content"][@"object"]];
                      [manager GET:[AFNet tuo_packages]
                        parameters:@{@"id":tuo.ID}
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               if([responseObject[@"result"] integerValue]==1){
                                   NSArray *xiangList=responseObject[@"content"];
                                   [tuo.xiang removeAllObjects];
                                   for(int i=0;i<xiangList.count;i++){
                                       Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
                                       [tuo.xiang addObject:xiang];
                                   }
                                   self.scanTextField.text=@"";
                                   [self performSegueWithIdentifier:@"receiveTuo" sender:@{@"title":data,@"tuo":tuo,@"from":@"tuo"}];
                               }
                               else{
                                   [AFNet alert:responseObject[@"content"]];
                               }
                               
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               [AFNet alert:@"something wrong"];
                           }
                       ];
                      
                  }
                  else if(type==3){
                      
                      NSInteger receive_mode=[[self.userPreference location ] receive_mode];
                      
                      Yun *yun=[[Yun alloc] initWithObject:responseObject[@"content"][@"object"]];
                      
                      
                      if(receive_mode==100){
                          
                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择接收方式" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
                          
                          UIAlertAction *byTuoAction = [UIAlertAction actionWithTitle:@"按照托接收" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                                        {
                                                            [self yunReceiveByTuo:yun andInput:data];
                                                        }];
                          UIAlertAction *byXiangAction = [UIAlertAction actionWithTitle:@"按照箱接收" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                                          {
                                                              [self yunReceiveByXiang:yun andInput:data];
                                                          }];
                          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                                         {
                                                             self.scanTextField.text=@"";
                                                         }];
                          [alertController addAction:byTuoAction];
                          [alertController addAction:byXiangAction];
                          [alertController addAction:cancelAction];;
                          
                          [self presentViewController:alertController animated:YES completion:nil];
                          
                      }else if(receive_mode==200){
                          [self yunReceiveByTuo:yun andInput:data];
                          
                                               }else if(receive_mode==300){
                                                   [self yunReceiveByXiang:yun andInput:data];
                                               }
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

-(void)yunReceiveByTuo:(Yun*)yun andInput:(NSString *)data{
    
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    
    [manager GET:[AFNet yun_folklifts]
      parameters:@{@"id":yun.ID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 NSArray *tuoArray=responseObject[@"content"];
                 [yun.tuoArray removeAllObjects];
                 for(int i=0;i<tuoArray.count;i++){
                     Tuo *tuoItem=[[Tuo alloc] initWithObject:tuoArray[i]];
                     [yun.tuoArray addObject:tuoItem];
                 }
                 self.scanTextField.text=@"";
                 
                 [AFNet.activeView stopAnimating];
                 
                 [self performSegueWithIdentifier:@"receiveYun" sender:@{@"title":data,@"yun":yun}];
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


-(void)yunReceiveByXiang:(Yun*)yun andInput:(NSString *)data{
    
    
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    
    [manager GET:[AFNet yun_packages]
      parameters:@{@"id":yun.ID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if([responseObject[@"result"] integerValue]==1){
                 NSArray *xiangList=responseObject[@"content"];
                 [yun.xiang removeAllObjects];
                 for(int i=0;i<xiangList.count;i++){
                     Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
                     [yun.xiang addObject:xiang];
                 }
                 self.scanTextField.text=@"";
                 [AFNet.activeView stopAnimating];
                 [self performSegueWithIdentifier:@"receiveTuo" sender:@{@"title":data,@"tuo":yun,@"from":@"yun"}];
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet alert:@"something wrong"];
         }
     ];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"receiveXiang"]){
        ReceiveXiangViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
        vc.xiang=[sender objectForKey:@"xiang"];
    }
    else if([segue.identifier isEqualToString:@"receiveTuo"]){
        ReceiveTuoViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
        vc.enableCancel=YES;
        vc.enableConfirm=YES;
        vc.tuo=[sender objectForKey:@"tuo"];
        vc.from=[sender objectForKey:@"from"];
    }
    else if([segue.identifier isEqualToString:@"receiveYun"]){
        ReceiveYunViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
        vc.yun=[sender objectForKey:@"yun"];
    }
}


- (IBAction)test:(id)sender {
    [self performSegueWithIdentifier:@"receiveTuo" sender:self];
}
- (IBAction)unwindToReceive:(UIStoryboardSegue *)unwind
{
    
}
@end
