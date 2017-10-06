# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

target 'qtum wallet' do
	pod 'CoreBitcoin', :podspec => 'https://raw.github.com/oleganza/CoreBitcoin/master/CoreBitcoin.podspec'
	pod 'AFNetworking', '~> 2.0'
	pod 'AFJSONRPCClient'
	pod 'SVProgressHUD'
	pod 'MTBBarcodeScanner', '~> 2.0.3'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'Firebase/Core'
	pod 'Firebase/Messaging'

	target 'qtum walletTests' do
        	inherit! :search_paths
		pod 'CoreBitcoin', :podspec => 'https://raw.github.com/oleganza/CoreBitcoin/master/CoreBitcoin.podspec'
	end
end

