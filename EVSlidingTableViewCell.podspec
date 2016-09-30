
Pod::Spec.new do |s|
  s.name             = 'EVSlidingTableViewCell'
  s.version          = '2.0.1'
  s.homepage         = 'https://github.com/epv44/EVSlidingTableViewCell'
  s.author           = { 'Eric Vennaro' => 'epv9@case.edu' }
  s.summary          = 'UITableViewCell implementing "swipe to reveal" a drawer view with customizable action buttons'
  s.description      = <<-DESC
Custom UITableViewCell that can be swiped either way to reveal a "drawer" with between 1 and 4 customizable action buttons.  These action buttons fade and grow into view as the drawer is swiped.  This cell works on all orientations and all devices.
                       DESC

  s.homepage         = 'https://github.com/epv44/EVSlidingTableViewCell'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Vennaro' => 'epv9@case.edu' }
  s.source           = { :git => 'https://github.com/epv44/EVSlidingTableViewCell.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'EVSlidingTableViewCell/Classes/**/*'
  
  s.resource_bundles = {
    'EVSlidingTableViewCell' => ['EVSlidingTableViewCell/Classes/**/*.{xib}']
  }
end
