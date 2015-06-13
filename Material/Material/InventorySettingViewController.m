//
//  InventorySettingViewController.m
//  Material
//
//  Created by exmooncake on 15-6-13.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "InventorySettingViewController.h"
#import "AFNetOperate.h"

@interface InventorySettingViewController ()<UITextFieldDelegate>
- (IBAction)logout:(id)sender;
@end

@implementation InventorySettingViewController

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
}

- (void)didReceiveMemoryWarning
{
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
                    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
