//
//  MisDenunciasTVCell.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/13/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MisDenunciasTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitulo;
@property (weak, nonatomic) IBOutlet UITextView *lblTitulo2;

@end

NS_ASSUME_NONNULL_END
