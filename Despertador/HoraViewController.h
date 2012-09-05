//
//  HoraViewController.h
//  Despertador
//
//  Created by Aitor Brazaola on 12/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class instruccionesViewController;


@interface HoraViewController : UIViewController
{
    NSTimer *timer;
    NSDateFormatter *hourFormatter;
    NSDateFormatter *dateFormatter;
    UINavigationItem *navigationItem;
        
    NSString *hora;
    NSString *fecha;
    
    instruccionesViewController *instruccionesVC;
    
    IBOutlet UILabel *labelHora;
    IBOutlet UILabel *labelFecha;
    IBOutlet UIImageView *indicadorAlarma;
    IBOutlet UIButton *borrarNotificaciones;
}
-(void)actualizarHora;
-(void)actualizarLED;
-(IBAction)borrarNotificaciones:(id)sender;

@end
