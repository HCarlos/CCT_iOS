//
//  ArchivoCVCell.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/15/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "ArchivoCVCell.h"
#import "VerImagenVC.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"
@interface ArchivoCVCell ()
@end

@implementation ArchivoCVCell
@synthesize IdArchivo, Archivo, Imagen, esVideo, esDocument, esAudio, extensionArchivo ;


- (IBAction)btnDelete:(id)sender {
    [self.delegate quitarArchivo:self.IdArchivo Archivo:self.Archivo];
}

- (IBAction)btnDelete2:(id)sender {
    [self.delegate quitarArchivo:self.IdArchivo Archivo:self.Archivo];
}

- (IBAction)btnOpenFile:(id)sender {
    
    self.Singleton  = [Singleton sharedMySingleton];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.Singleton.urlMediaData,self.Archivo];
    NSLog(@"Nombre del Archivo que se va abrir: %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:nil];
    
}

@end
