//
//  VerImagenVC.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/10/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "VerImagenVC.h"
#import "DenunciaTVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ArchivoCVCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Singleton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>


@interface VerImagenVC ()

@end

@implementation VerImagenVC
@synthesize imgFoto, imagen, nombreArchivo, extensionArchivo, Singleton, audioPlayer, Data;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.Singleton  = [Singleton sharedMySingleton];
//    [self.Singleton setPlist];

    // self.navigationController.navigationBar.topItem.title = @"Regresar";
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg2.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    if ([self.extensionArchivo isEqualToString:@"jpg"]) {
        self.imgFoto.image = nil;
        self.imgFoto.image = self.imagen;
        self.imgFoto.clipsToBounds = YES;
        self.imgFoto.layer.cornerRadius = 15.0;
        self.imgFoto.layer.borderWidth = 5.0;
        self.imgFoto.layer.borderColor = [UIColor whiteColor].CGColor;
        self.playerView.hidden = YES;
    }else if ([self.extensionArchivo isEqualToString:@"mp4"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", self.Singleton.urlMediaData,self.nombreArchivo];
        NSURL *url = [NSURL URLWithString:urlString];
        AVPlayer *player = [AVPlayer playerWithURL:url];
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        [self addChildViewController:controller];
        [self.view addSubview:controller.view];
        controller.view.frame = self.view.bounds;//CGRectMake(50,50,500,300);
        controller.player = player;
        controller.showsPlaybackControls = YES;
        [player pause];
        [player play];
        self.playerView.hidden = YES;
    }else if ([self.extensionArchivo isEqualToString:@"mp3"]) {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.Data error:nil];
        [self.audioPlayer play];

    }else{
        self.imgFoto.image = nil;
        self.imgFoto.image = self.imagen;
        self.imgFoto.clipsToBounds = YES;
        self.imgFoto.layer.cornerRadius = 15.0;
        self.imgFoto.layer.borderWidth = 5.0;
        self.imgFoto.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btnVerVideo.hidden = YES;
        self.playerView.hidden = YES;
    }
    

}
- (IBAction)btnPlay:(id)sender {
    [self.audioPlayer play];
}

- (IBAction)btnPause:(id)sender {
    [self.audioPlayer pause];
}

- (IBAction)btnStop:(id)sender {
    [self.audioPlayer setRate:0.0];
    [self.audioPlayer stop];
}
//
//- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application{
//    NSLog(@"Send to App %@  ...", application);
//}
//
//- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
//    NSLog(@"Finished sending to app %@  ...", application);
//    
//}
//
//- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller{
//    NSLog(@"Bye");
//    
//}
//
//-(BOOL)canOpenDocumentWithURL:(NSURL*)url inView:(UIView*)view {
//    BOOL canOpen = NO;
//    UIDocumentInteractionController* tmpDocController = [UIDocumentInteractionController
//                                                         interactionControllerWithURL:url];
//    if (tmpDocController)
//    {
//        tmpDocController.delegate = self;
//        canOpen = [tmpDocController presentOpenInMenuFromRect:CGRectZero
//                                                       inView:self.view animated:NO];
//        [tmpDocController dismissMenuAnimated:NO];
//    }
//    return canOpen;
//}
//
//- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
//    return self;
//}

@end

