
Pod::Spec.new do |s|


  s.name         = "MLSwitch"
  s.version      = "1.0.2"
  s.summary      = "Simple yet powerful and fast image cache."

  s.description  = <<-DESC
# MLSwitch
## Fully customisable UISwitch replacement

Reimplementation of UISwitch using custom images for background and slider, with an option to have on and off buttons different from each other.
One needs to provide a background image and on/off images (can be the same). 

The control sends "Value Changed" control events just like normal UISwitch does.

## Installation
  
Use CocoaPods or copy those 2 files directly into the project. 

    pod 'MLSwitch'

## How to use it?
    
    The only difference between MLSwitch and UISwitch is that you need to set on, off and background images and image offset. The off image is offset from left top corner, 
    the on image is offset from right top corner.
    
    let switch = MLSwitch(frame: CGRectMake(0,0,100,100))
    
    switch.backgroundImage = UIImage(named:"example_bg")
    switch.offImage = UIImage(named:"example_off")
    switch.onImage = UIImage(named:"example_on")
    switch.switchOffset = CGPointMake(0, 0)
    
It can be used with autolayout, just pick a generic UIControl in a storyboard and assign it MLSwitch class. You can place the image initialization code in 
didSet on the outlet like this: 

    @IBOutlet private weak var switch: MLSwitch! {
        didSet {
                switch.backgroundImage = UIImage(named:"example_bg")
                switch.offImage = UIImage(named:"example_off")
                switch.onImage = UIImage(named:"example_on")
                switch.switchOffset = CGPointMake(0, 0)
        }
    }

                   DESC

   s.homepage     = "https://github.com/mll/MLSwitch"
   s.license   =  'MIT'
   
   s.author             = { "Marek Lipert" => "marek.lipert@gmail.com" }
   s.ios.deployment_target = '5.0'
   s.source       = { :git => "https://github.com/mll/MLSwitch.git", :tag => "1.0.2" }
   s.source_files  = '*.{h,m}'
   s.requires_arc = true

end
