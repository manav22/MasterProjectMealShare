//
//  PostCuisineViewController.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/21/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "PostCuisineViewController.h"
#import "Meal.h"
#import "Meals.h"
#import "AppDelegate.h"

@interface PostCuisineViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) Meal *meal;
@property (nonatomic) BOOL isONVeg;
@property (nonatomic) BOOL eatHere;
@property (nonatomic) BOOL togo;
@property (nonatomic, strong) UIImage* picture;
@property (nonatomic, strong) NSURL* imagePath;
@end

@implementation PostCuisineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isONVeg = FALSE;
    self.eatHere = FALSE;
    self.togo = FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- Image
- (IBAction)cameraButtonPressed:(UIButton *)sender {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    self.picture = image;
    self.cuisineImage.image = image;
}


-(void) imagePickerController:(UIImagePickerController *)UIPicker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
        [self dismissModalViewControllerAnimated:YES];


    //Zoomed or scrolled image if picker.editing = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image =  [info objectForKey:UIImagePickerControllerOriginalImage];
        self.cuisineImage.image = image;
            self.picture = image;

    // Get PNG data from following method
    NSData *myData =     UIImagePNGRepresentation(image);
    //NSLog(@"data: %@", myData);
   // NSString *str = [[NSString alloc] initWithData:myData encoding:NSUTF32StringEncoding];
NSString *str =    [myData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"string: %@",str);

}
#pragma mark- bool options
- (IBAction)vegetarianSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.isONVeg = TRUE;
    }
    NSLog(@"%d",self.isONVeg);
}

- (IBAction)eatHereSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.eatHere = TRUE;
    }
}

- (IBAction)togoSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.togo = TRUE;
    }

}
- (IBAction)postBarButtonItem:(UIBarButtonItem *)sender {
    [self persistMeal];
}


#pragma mark - model
- (void) persistMeal
{
    if (!self.meal) {
        self.meal = [[Meal alloc] init];
    }
    
  
    
        self.meal.mealTitle = self.mealTitleTextField.text;
        self.meal.mealAddress = self.mealAddressTextField.text;
        self.meal.mealAvailableSpots = self.numberOfPersonsTextField.text;
        self.meal.mealDescription = self.mealDescriptionTextView.text;
        self.meal.mealStartDateTime = @"2015-10-25T15:00:00Z";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSString *availableDate = [dateFormatter stringFromDate:self.availableUntilDatePicker.date];
    
        self.meal.mealEndDateTime = availableDate;
        self.meal.mealSeller = @"561dfe85eb65f6da3a6de62d";

        self.meal.image = self.picture;
        self.meal.imageId = [self.imagePath absoluteString];
    
        //self.location.configuredBySystem = NO;
        
        [[AppDelegate appDelegate].meals persist:self.meal];
    
}
@end
