# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Marindeck' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod "Optik", :git => "https://github.com/RiniaOkyama/Optik"    # image preview
  pod "AlamofireImage"
  pod 'Highlightr' # js highlight
  #pod 'HighlightJS'
  #pod 'FLEX', :configurations => ['Debug'] # Debuger
  pod 'SPAlert'

  pod "SwiftGen"

  # Pods for Marindecker

end

target 'Marindeck-dev' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod "Optik", :git => "https://github.com/RiniaOkyama/Optik"     #image preview
  pod "AlamofireImage"
  pod 'Highlightr' # js highlight
  #pod 'HighlightJS'
  #pod 'FLEX', :configurations => ['Debug'] # Debuger
  pod 'SPAlert'

  pod "SwiftGen"

  # Pods for Marindecker

end

plugin 'cocoapods-keys', {
    :projects => "Marindeck",
    :target => ["Marindeck-dev", "Marindeck"],
    :keys => [
        "GiphyApiKey",
        "DeploygateUsername",
        "DeploygateSdkApiKey"
    ]
}
