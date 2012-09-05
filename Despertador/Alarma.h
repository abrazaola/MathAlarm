//
//  Alarma.h
//  Despertador
//
//  Created by Aitor Brazaola on 16/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class alarmaViewController;

@interface Alarma : NSObject<NSCoding>
{
    NSDate *date;
    NSString *title;
    NSString *sonido;
    
    UILocalNotification *localNotif;
        
    BOOL estado;
}
@property (nonatomic)NSDate *date;
@property (nonatomic)NSString *title;
@property (nonatomic)BOOL estado;
@property (nonatomic)NSString *sonido;
@property (nonatomic)UILocalNotification *localNotif;

-(id)init;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(id)initConAlarma:(Alarma *)a;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(void)registrarNotificacion;
-(void)cancelarNotificacion;
-(void)cambiarEstado;
@end