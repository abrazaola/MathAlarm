//
//  alarmaViewController.h
//  Despertador
//
//  Created by Aitor Brazaola on 23/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class Alarma;

@interface alarmaViewController : UIViewController<UITextFieldDelegate, AVAudioPlayerDelegate>
{
    UILabel *titulo;
    UILabel *hora;
    UILabel *operando1;
    UILabel *operando2;
    UILabel *operacion;
    UITextField *resultado;
    UIButton *apagar;
    
    int op1;
    int op2;
    int resultadoNum;
    
    Alarma *alarmaActual;
    
    AVAudioPlayer *audioPlayer;
        
    NSDateFormatter *dateFormatter;
}
@property(nonatomic)Alarma *alarmaActual;
@property(nonatomic)IBOutlet UILabel *titulo;
@property(nonatomic)IBOutlet UILabel *hora;
@property(nonatomic)IBOutlet UILabel *operando1;
@property(nonatomic)IBOutlet UILabel *operando2;
@property(nonatomic)IBOutlet UILabel *operacion;
@property(nonatomic)IBOutlet UIButton *BotonApagar;
@property(nonatomic)IBOutlet UITextField *resultado;

-(id)initConAlarma:(Alarma *)a;
-(IBAction)apagar:(id)sender;
-(void)generarOperacion;

@end
