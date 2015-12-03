//
//  UpdateProfileViewController.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 11/19/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "UpdateProfileViewController.h"

@interface UpdateProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *editFirstNameButton;
@property (strong, nonatomic) IBOutlet UIButton *editLastNameButton;
@property (strong, nonatomic) IBOutlet UIButton *editDateOfBirthButton;
@property (strong, nonatomic) IBOutlet UIButton *editAddressButton;

@property (nonatomic, strong) UIImage* picture;
@property (nonatomic, strong) NSData* imageData;
@property(nonatomic, strong) NSString* path;

@end

@implementation UpdateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.firstNameTextField setHidden:YES];
    [self.lastNameTextField setHidden:YES];
    [self.dateOfBirthTextField setHidden:YES];
    [self.addressTextField setHidden:YES];
    [self.creditCardNumTextField setHidden:YES];
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

- (IBAction)editNameButtonPressed:(UIButton *)sender {
    [self.firstNameLabel setHidden:YES];
    [self.firstNameTextField setHidden:NO];
    self.editFirstNameButton.hidden = YES;
}

- (IBAction)editLastNameButtonPressed:(UIButton *)sender {
    [self.lastNameLabel setHidden:YES];
    [self.lastNameTextField setHidden:NO];
    self.editLastNameButton.hidden = YES;
}

- (IBAction)editDateOfBirthButtonPressed:(UIButton *)sender {
    [self.dateOfBirthLabel setHidden:YES];
    [self.dateOfBirthTextField setHidden:NO];
    self.editDateOfBirthButton.hidden = YES;
}

- (IBAction)editAddressButtonPressed:(UIButton *)sender {
    [self.addressLabel setHidden:YES];
    [self.addressTextField setHidden:NO];
    self.editAddressButton.hidden= YES;

}

- (IBAction)updateCardButtonPressed:(UIButton *)sender {
    [self.creditCardNumTextField setHidden:NO];
}

#pragma mark- Image
- (IBAction)photoButtonPressed:(UIButton *)sender {
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
    self.imageView.image = image;
}


-(void) imagePickerController:(UIImagePickerController *)UIPicker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    [self dismissModalViewControllerAnimated:YES];
    
    
    //Zoomed or scrolled image if picker.editing = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    self.picture = image;
    
    // Get PNG data from following method
    self.imageData =     UIImagePNGRepresentation(image);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.path = [documentsDirectory stringByAppendingPathComponent:
                 @"test.png" ];
    self.imageData = UIImagePNGRepresentation(image);
    [self.imageData writeToFile:self.path atomically:YES];
    
    
}

@end
