#
# Be sure to run `pod lib lint NMFloatLabelSearchField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NMFloatLabelSearchField'
  s.version          = '0.1.0'
  s.summary          = 'A lightweight subclass of UITextField to display floating hints and suggestion list as you type.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A lightweight subclass of SkyFloatingLabelTextField to display dynamic floating hints and suggestion list as you type text in the text field. Combination of https://github.com/Skyscanner/SkyFloatingLabelTextField and https://github.com/apasccon/SearchTextField pods.
                       DESC

  s.homepage         = 'https://github.com/namshi/NMFloatLabelSearchField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Noor ul Ain Ali' => 'noor.ali@namshi.com' }
  s.source           = { :git => 'https://github.com/namshi/NMFloatLabelSearchField.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/namshidotcom'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NMFloatLabelSearchField/Classes/**/*'

  s.frameworks = 'UIKit'
  s.dependency 'SkyFloatingLabelTextField', '~> 3.4.0'

end
