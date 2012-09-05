//
//  Alarma.m
//  Despertador
//
//  Created by Aitor Brazaola on 16/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "Alarma.h"
#import "alarmaViewController.h"

@implementation Alarma
@synthesize date, title, estado, sonido, localNotif;
-(id)init
{
    self = [super init];
    
    date=[[NSDate alloc]init];
    title=NSLocalizedString(@"Nueva Alarma", @"TituloDeLasNuevasAlarmas");
    estado=YES;
    sonido=nil;
    localNotif=[[UILocalNotification alloc]init];
    
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    
    [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
    [self setDate:[aDecoder decodeObjectForKey:@"date"]];
    [self setEstado:[aDecoder decodeBoolForKey:@"estado"]];
    [self setSonido:[aDecoder decodeObjectForKey:@"sonido"]];
    [self setLocalNotif:[aDecoder decodeObjectForKey:@"notificacion"]];
        
    return self;
}
-(id)initConAlarma:(Alarma *)a
{
    self = [super init];
    
    date=[a date];
    title=[a title];
    estado=[a estado];
    sonido=[a sonido];
    
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:date forKey:@"date"];
    [aCoder encodeObject:title forKey:@"title"];    
    [aCoder encodeBool:estado forKey:@"estado"];
    [aCoder encodeObject:sonido forKey:@"sonido"];
    [aCoder encodeObject:localNotif forKey:@"notificacion"];
}

-(void)registrarNotificacion
{
    [self cancelarNotificacion];
    
    localNotif.fireDate = date;
    NSLog(@"Objeto alarma con fecha %@",[date description]);
    
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@", nil),
                            title];
    localNotif.alertAction = NSLocalizedString(@"Apagar", nil);
    
    localNotif.repeatInterval = NSDayCalendarUnit;
    
    NSString *sonidoElegido=[[self sonido] stringByAppendingString:@".caf"];
    
    localNotif.soundName = sonidoElegido;
    localNotif.applicationIconBadgeNumber = 0;
        
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    NSLog(@"Notificacion registrada %@", localNotif);
}

-(void)cancelarNotificacion
{
    if (localNotif) {
        NSLog(@"Notificacion cancelada %@", localNotif);
        [[UIApplication sharedApplication]cancelLocalNotification:localNotif];
    }
}
-(void)cambiarEstado
{
    if([self estado])
    {
        estado=NO;
        [self cancelarNotificacion];
    }
    else {
        estado=YES;
        [self registrarNotificacion];
    }
}


@end
