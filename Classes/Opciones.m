//
//  Opciones.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/29/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "Opciones.h"

@implementation Opciones


+(Opciones*)newDataObject:(int)key value:(NSString*)value{
    
    Opciones *opt = [[Opciones alloc] init];
    opt.Key = key;
    opt.Value = value;
    
    return opt;
    
}

@end
