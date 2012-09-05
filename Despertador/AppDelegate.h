//
//  AppDelegate.h
//  Despertador
//
//  Created by Aitor Brazaola on 12/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HoraViewController;
@class listaAlarmasViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationHora;
    UINavigationController *navigationAlarmas;
    
    UITabBarItem *tabBarItemReloj;
    UITabBarItem *tabBarItemAlarmas;
    
    UITabBarController *tbC;
    
    NSMutableArray *arrayAlarmas;
    
    HoraViewController *horaVC;
    listaAlarmasViewController *alarmasVC;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSMutableArray *arrayAlarmas;

-(NSString *)rutaArrayAlarmas;
-(void)guardarAlarmas;

@end
