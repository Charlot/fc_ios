//
//  InventoryConfirmViewController.h
//  Material
//
//  Created by exmooncake on 15-6-14.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryListItem.h"

@interface InventoryConfirmViewController : UIViewController
@property(strong, nonatomic) NSString *inventroy_id;
@property(strong, nonatomic) InventoryListItem *inventory_list_item;
@end
