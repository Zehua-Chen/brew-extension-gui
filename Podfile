platform :osx, '10.14'
use_frameworks!

target 'Brew Extension Client' do
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'BrewExtension', :git => 'https://github.com/Zehua-Chen/brew-extension', :branch => 'master'

  target 'Brew Extension Client Tests' do
    inherit! :search_paths
  end
end
