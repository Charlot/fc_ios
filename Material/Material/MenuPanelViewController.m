//
//  MenuPanelViewController.m
//  Material
//
//  Created by Charlot on 16/3/14.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "MenuPanelViewController.h"
#import "AFNetOperate.h"

@interface MenuPanelViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (weak, nonatomic) IBOutlet UIButton *NeedButton;

@end

@implementation MenuPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _logoutBtn.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    _sendButton.backgroundColor =[UIColor colorWithRed:209.0/255.0 green:42.0/255.0 blue:26.0/255.0 alpha:0.8];
    _receiveButton.backgroundColor =[UIColor colorWithRed:209.0/255.0 green:42.0/255.0 blue:26.0/255.0 alpha:0.8];
    _countButton.backgroundColor =[UIColor colorWithRed:209.0/255.0 green:42.0/255.0 blue:26.0/255.0 alpha:0.8];
    _NeedButton.backgroundColor =[UIColor colorWithRed:209.0/255.0 green:42.0/255.0 blue:26.0/255.0 alpha:0.8];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logout:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager DELETE:[AFNet log_out]
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [AFNet.activeView stopAnimating];
                if([responseObject[@"result"] integerValue]==1){
                    //                    [self dismissViewControllerAnimated:YES completion:nil];
                    UIStoryboard *storyboard =
                    [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                    UIViewController *tabbarStock = [[UIViewController alloc] init];
                    tabbarStock =
                    [storyboard instantiateViewControllerWithIdentifier:@"login"];
                    [self presentViewController:tabbarStock animated:YES completion:nil];
                    
                }
                else{
                    [AFNet alert:responseObject[@"content"]];
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [AFNet.activeView stopAnimating];
                [AFNet alert:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            }
     ];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
