//
//  InventoryViewController.m
//  Material
//
//  Created by exmooncake on 15-6-13.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "InventoryViewController.h"

@interface InventoryViewController ()

@property (strong, nonatomic) IBOutlet UIPickerView *processingPicker;

@end

@implementation InventoryViewController

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
//    self.processingPicker.dataSource = self;
//    self.processingPicker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
