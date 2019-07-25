//
//  PreloaderVC.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/17/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PreloaderVC;
@protocol PreloaderVCDelegate <NSObject>

    -(void)closeWindows;

@end

@interface PreloaderVC : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;
@property(nonatomic, weak) id <PreloaderVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblLoader;

@end

NS_ASSUME_NONNULL_END
