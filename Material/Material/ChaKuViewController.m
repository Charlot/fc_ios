//
//  ChaKuViewController.m
//  Material
//
//  Created by ryan on 7/22/15.
//  Copyright (c) 2015 brilliantech. All rights reserved.
//

#import "ChaKuViewController.h"

#import "UITextField+Extended.h"


@interface ChaKuViewController ()
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *whTextField;
- (IBAction)confirmAction:(id)sender;


@end

@implementation ChaKuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmAction:(id)sender
{
    if (self.partTextField.text.length > 0)
    {
        
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:@"确认提交？"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
            [alert show];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请填写零件号"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *strPart = self.partTextField.text;
    NSString *strWh = self.whTextField.text;
    
    /*
     clear TextField data
     */
    if(buttonIndex == 1){
        NSArray *subviews = [self.view subviews];
        //                int i =0 ;
        for (id objInput in subviews) {
            if ([objInput isKindOfClass:[UITextField class]]) {
                UITextField *theTextField = objInput;
                theTextField.text = @"";
                //                        NSLog(@"time is %d", i);
                //                        i++;
                
            }
        }
       
        
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager GET:[AFNet get_positions]
           parameters:@{@"part_id": strPart, @"wh_id": strWh }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1)
                  {
//                      [AFNet alertSuccess:responseObject[@"content"]];
                      NSMutableArray *dataList = [[NSMutableArray alloc] init];
                      NSArray *resultArray=responseObject[@"content"];
                      for(int i=0;i<resultArray.count;i++){
                          NSDictionary *dic= resultArray[i];
                          [dataList addObject: dic];
                      }
//                      [self performSegueWithIdentifier:@"queryRequire" sender:@{@"billArray": [billList copy]}];
                  }
                  else
                  {
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
