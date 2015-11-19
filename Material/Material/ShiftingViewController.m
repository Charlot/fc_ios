//
//  ShiftingViewController.m
//  Material
//
//  Created by ryan on 11/18/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "ShiftingViewController.h"

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
