//
//  SplashVC.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/23/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SplashVC;

@protocol SplashVCDelegate <NSObject>

    -(void)cerrarVentana;

@end

@interface SplashVC : UIViewController
@property(nonatomic, weak) id <SplashVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *viewSplash;


- (IBAction)btnCerrarVentana:(id)sender;

@end

NS_ASSUME_NONNULL_END
