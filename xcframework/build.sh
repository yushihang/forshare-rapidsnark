


xcodebuild -create-xcframework -library ios-arm64/libfr.a  -library ios-simulator-x86_64_arm64/libfr.a  -output fr.xcframework


xcodebuild -create-xcframework -library ios-arm64/libfq.a  -library ios-simulator-x86_64_arm64/libfq.a  -output fq.xcframework


xcodebuild -create-xcframework -library ios-arm64/librapidsnark.a -headers header  -library ios-simulator-x86_64_arm64/librapidsnark.a  -headers header  -output rapidsnark.xcframework


