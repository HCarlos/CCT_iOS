//
//  Opciones.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/29/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "Opciones.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation Opciones


+(Opciones*)newDataObject:(int)key value:(NSString*)value{
    Opciones *opt = [[Opciones alloc] init];
    opt.Key = key;
    opt.Value = value;
    return opt;
}

+(Opciones*)newDataObject:(int)key value:(NSString*)value VString1:(NSString *)vstring1 VString2:(NSString *)vstring2{
    Opciones *opt = [[Opciones alloc] init];
    opt.Key = key;
    opt.Value = value;
    opt.VString1 = vstring1;
    opt.VString2 = vstring2;
    return opt;
}

+(Opciones*)newDataObject:(int)key value:(NSString*)value VString1:(NSString *)vstring1 Data:(NSData *)data{
    Opciones *opt = [[Opciones alloc] init];
    opt.Key = key;
    opt.Value = value;
    opt.VString1 = vstring1;
    opt.Data = data;
    return opt;
}

+(Opciones*)newDataObjectWhitImage:(int)key value:(NSString*)value VString1:(NSString *)vstring1 Imagen:(UIImage *)imagen{
    Opciones *opt = [[Opciones alloc] init];
    opt.Key = key;
    opt.Value = value;
    opt.VString1 = vstring1;
    opt.Imagen = imagen;
    return opt;
}

+(Opciones*)newDataObjectMedia:(int)key value:(NSString*)value VString1:(NSString *)vstring1 Imagen:(UIImage *)imagen Data:(NSData *)data{
    Opciones *opt = [[Opciones alloc] init];
    opt.Key = key;
    opt.Value = value;
    opt.VString1 = vstring1;
    opt.Imagen = imagen;
    opt.Data = data;
    return opt;
}


@end
