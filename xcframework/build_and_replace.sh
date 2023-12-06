#!/bin/bash
#quit on any error
set -e

current_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "current_directory:$current_directory"
# enter project directory
parent_directory="$(dirname "$current_directory")"
#echo "$parent_directory"
project_directory="$parent_directory/build_prover_ios_simulator"



project_path="$project_directory/rapidsnark.xcodeproj"

output_path="$parent_directory/output"

libs_path="$parent_directory/libs"

framework_path="$parent_directory/xcframework/Frameworks"

# check project existance
if [ -e "$project_path" ]; then
    echo "$project_path exists."
else
    echo "Error: $project_path NOT found!"
    exit 1
fi

rm -rf "$output_path"
mkdir "$output_path"

rm -rf "$libs_path"
mkdir "$libs_path"

rm -rf "$project_directory/build"
rm -rf "$project_directory/src"

mkdir "$output_path/iPhoneSimulator" > /dev/null 2>&1
mkdir "$output_path/iPhoneOS" > /dev/null 2>&1 

output_path_iphone_simulator_x86_64="$output_path/iPhoneSimulator/x86_64"
mkdir "$output_path_iphone_simulator_x86_64" > /dev/null 2>&1

output_path_iphone_simulator_arm64="$output_path/iPhoneSimulator/arm64"
mkdir "$output_path_iphone_simulator_arm64" > /dev/null 2>&1

output_path_iphone_simulator_universal="$output_path/iPhoneSimulator/universal"
mkdir "$output_path_iphone_simulator_universal" > /dev/null 2>&1

output_path_iphoneos_arm64="$output_path/iPhoneOS/arm64"
mkdir "$output_path_iphoneos_arm64" > /dev/null 2>&1


available_sdks=$(xcodebuild -showsdks)
ios_simulator_sdk=$(echo "$available_sdks" | grep -o "iphonesimulator[0-9.]*")
echo "Available iOS Simulator SDKs: $ios_simulator_sdk"

#available_sdks=$(xcodebuild -showsdks)
ios_device_sdk=$(echo "$available_sdks" | grep -o "iphoneos[0-9.]*")
echo "Available iOS Device SDKs: $ios_device_sdk"

derivedDataPath="$project_directory/DerivedData"
build_configuration="Release"

rm -rf "$derivedDataPath"

scheme="rapidsnarkStatic"

lib="rapidsnark"
libName="lib$lib.a"

sdk="arm64"
xcodebuild -project "$project_path" -configuration "$build_configuration" -scheme "$scheme" -derivedDataPath "$derivedDataPath" -sdk "$ios_device_sdk" -arch "$sdk"
cp "$libs_path/Release_iphoneos_arm64/$libName" "$output_path_iphoneos_arm64"

sdk="arm64"
xcodebuild -project "$project_path" -configuration "$build_configuration" -scheme "$scheme" -derivedDataPath "$derivedDataPath" -sdk "$ios_simulator_sdk" -arch "$sdk"
cp "$libs_path/Release_iphonesimulator_arm64/$libName" "$output_path_iphone_simulator_arm64"

sdk="x86_64"
xcodebuild -project "$project_path" -configuration "$build_configuration" -scheme "$scheme" -derivedDataPath "$derivedDataPath" -sdk "$ios_simulator_sdk" -arch "$sdk"
cp "$libs_path/Release_iphonesimulator_x86_64/$libName" "$output_path_iphone_simulator_x86_64"

lipo -create "$output_path_iphone_simulator_x86_64/$libName" "$output_path_iphone_simulator_arm64/$libName" -output "$output_path_iphone_simulator_universal/$libName"


#lipo -create "$babyjubjub_with_exception_handing_path/output/iphonesimulator_arm64/$libName" "$babyjubjub_with_exception_handing_path/output/iphonesimulator_x86_64/$libName" -output "$framework_path/$xcframework_name.xcframework/ios-arm64_x86_64-simulator/$libName"

cp "$output_path_iphone_simulator_universal/$libName" "$framework_path/$lib.xcframework/ios-arm64_x86_64-simulator/$libName"

cp "$output_path_iphoneos_arm64/$libName" "$framework_path/$lib.xcframework/ios-arm64/$libName"

echo "Finished"