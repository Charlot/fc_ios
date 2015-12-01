//
//  MovementDetailViewController.m
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "MovementDetailViewController.h"

@interface MovementDetailViewController ()
@property(strong, nonatomic) IBOutlet UILabel *toWhLabel;
@property(strong, nonatomic) IBOutlet UILabel *toPositionLabel;
@property(strong, nonatomic) IBOutlet UILabel *packageIdLabel;
@property(strong, nonatomic) IBOutlet UILabel *qtyLabel;
@property(strong, nonatomic) IBOutlet UILabel *partNrLabel;

@property(strong, nonatomic) IBOutlet UILabel *fromWhLabel;
@property(strong, nonatomic) IBOutlet UILabel *fromPositionLabel;
@end

@implementation MovementDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  //  [self loadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self loadData];
}

- (void)loadData {
  self.toWhLabel.text = self.movement.toWh;
  self.toPositionLabel.text = self.movement.toPosition;
  self.packageIdLabel.text = self.movement.packageId;
  self.qtyLabel.text = [NSString stringWithFormat:@"%@", self.movement.qty];
  self.partNrLabel.text = self.movement.partNr;
  self.fromWhLabel.text = self.movement.fromWh;
  self.fromPositionLabel.text = self.movement.fromPosition;
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

@end
