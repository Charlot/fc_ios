//
//  SelectCargoListItemTableViewCell.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "SelectCargoListItemTableViewCell.h"

@implementation SelectCargoListItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.SelectItemNameLabel.adjustsFontSizeToFitWidth = YES;
    self.SelectItemQuantityLabel.adjustsFontSizeToFitWidth = YES;
    self.SelectItemBoxQuantityLabel.adjustsFontSizeToFitWidth = YES;
    self.SelectItemSelectedQuantityLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
