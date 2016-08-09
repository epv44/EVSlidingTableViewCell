#
# Be sure to run `pod lib lint EVSlidingTableViewCell.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EVSlidingTableViewCell'
  s.version          = '0.1.0'
  s.homepage         = 'https://github.com/epv44/EVTopTabBar'
  s.author           = { 'Eric Vennaro' => 'epv9@case.edu' }
  s.summary          = 'UITableViewCell implementing "swipe to reveal" a drawer view with customizable action buttons'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Custom UITableViewCell that can be swiped either way to reveal a "drawer" with between 1 and 4 customizable action buttons.  These action buttons fade and grow into view as the drawer is swiped.  This cell works on all orientations and all devices.
                       DESC

  s.homepage         = 'https://github.com/epv44/EVSlidingTableViewCell'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Vennaro' => 'epv9@case.edu' }
  s.source           = { :git => 'https://github.com/epv44/EVSlidingTableViewCell.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'EVSlidingTableViewCell/Classes/**/*'
  
  s.resource_bundles = {
    'EVSlidingTableViewCell' => ['EVSlidingTableViewCell/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
