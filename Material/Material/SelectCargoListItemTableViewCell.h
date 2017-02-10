//
//  SelectCargoListItemTableViewCell.h
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCargoListItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SelectItemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *SelectItemQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *SelectItemBoxQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *SelectItemSelectedQuantityLabel;
@end
