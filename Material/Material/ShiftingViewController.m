//
//  ShiftingViewController.m
//  Material
//
//  Created by ryan on 11/18/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "ShiftingViewController.h"
#import "AFNetOperate.h"

@interface ShiftingViewController ()

@end

@implementation ShiftingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self customController];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd'T'00:00:00ZZZZZ"];
  NSString *startDate = [formatter stringFromDate:[NSDate date]];
  [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  NSString *endDate = [formatter stringFromDate:[NSDate date]];

  AFNetOperate *AFNet = [[AFNetOperate alloc] init];
  [AFNet.activeView stopAnimating];
  AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
  [AFNet.activeView stopAnimating];
  [manager GET:[AFNet order_history]
      parameters:@{
        @"start" : startDate,
        @"end" : endDate
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [AFNet.activeView stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
          NSMutableArray *billList = [[NSMutableArray alloc] init];
          NSArray *resultArray = responseObject[@"content"][@"orders"];
          for (int i = 0; i < resultArray.count; i++) {
            NSDictionary *dic = resultArray[i];
          }

        } else {
          [AFNet alert:responseObject[@"content"]];
        }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AFNet.activeView stopAnimating];
        [AFNet alert:[NSString
                         stringWithFormat:@"%@", [error localizedDescription]]];
      }];
}

- (void)customController {

  //    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
  //  [backButton setTitle:@"取消" forState:UIControlStateNormal];
  //  [backButton addTarget:self
}

- (void)back:(UIBarButtonItem *)sender {
  // Perform your custom actions
  // ...
  // Go back to the previous ViewController
  [self.navigationController popViewControllerAnimated:YES];
}

@end
