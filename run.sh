DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR/ForecastIOClient"
cat ForecastIOService.swift Config.swift main.swift | swift -target x86_64-apple-macosx$(xcrun --show-sdk-version) -F ../Carthage/Build/Mac/ -
