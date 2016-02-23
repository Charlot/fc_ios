//
//  InventoryPositionViewController.h
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryPositionViewController : UIViewController
@property(strong, nonatomic) NSMutableArray *positionData;
@property(strong, nonatomic) NSString *position;
@property(strong, nonatomic) NSString *inventory_list_id;
@property(strong, nonatomic) NSString *userName;

@end
