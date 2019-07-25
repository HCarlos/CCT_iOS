//
//  VerImagenVC.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/10/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DenunciaTVC.h"
#import "ArchivoCVCell.h"
#import "Singleton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerImagenVC : UIViewController<UIPageViewControllerDelegate, AVAudioPlayerDelegate, UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) Singleton *Singleton;

//@property (nonatomic, retain) UIImage* imagen;
@property (nonatomic) UIImage* imagen;
@property (nonatomic, strong) NSString *nombreArchivo;
@property (nonatomic, strong) NSString *extensionArchivo;
@property (nonatomic, strong) NSData *Data;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (nonatomic) IBOutlet UIImageView *imgFoto;
@property (weak, nonatomic) IBOutlet UIButton *btnVerVideo;

@property (weak, nonatomic) IBOutlet UIView *playerView;

- (IBAction)btnPlay:(id)sender;
- (IBAction)btnPause:(id)sender;
- (IBAction)btnStop:(id)sender;


@end




NS_ASSUME_NONNULL_END
