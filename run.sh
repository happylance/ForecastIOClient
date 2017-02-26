DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR/Sources"
swiftFiles="$(find . | grep .swift | grep -v "main.swift" | paste -sd " " -) main.swift"
cat $swiftFiles | swift -target x86_64-apple-macosx$(xcrun --show-sdk-version) -F ../Carthage/Build/Mac/ -
