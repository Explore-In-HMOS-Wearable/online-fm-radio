> **Note:** To access all shared projects, get information about environment setup, and view other guides, please visit [Explore-In-HMOS-Wearable Index](https://github.com/Explore-In-HMOS-Wearable/hmos-index).

# OnlineFM Radio
**OnlineFM Radio** is a IP-based radio streaming app built for HarmonyOS NEXT smartwatches.  
The app enables users to browse and play live internet radio stations over HTTP streaming protocols with minimal UI optimized for round screens.

# Preview
<div>
    <img src="./screenshots/_radio.gif" width="25%"/> 
</div>

# Use Cases
A user raises their HarmonyOS NEXT smartwatch, scrolls a lightweight station list, and instantly streams a favorite live internet radio station over HTTP—no phone required. The round-screen, tap-first UI makes quick station switches and volume tweaks effortless on the wrist.
# Tech Stack

- **Languages**: ArkTS
- **Frameworks**: HarmonyOS SDK 5.1.0(18)
- **Tools**: DevEco Studio Vers 5.1.0.842
- **Libraries**: @kit.ArkUI, @ohos.multimedia.media

# Directory Structure
```
entry/src/main/ets/

|-- common
|   |-- components
|   |   |-- ActionIcon.ets             # Reusable icon button
|   |   |-- BackButton.ets             # Custom back navigation button
|   |-- constants
|       |-- stations.ets               # Station list and defaults
|-- model
|   |-- StationModel.ets               # Station structure definition
|-- viewmodel
|   |-- StationViewModel.ets          # ViewModel for list and selection
|-- pages
|   |-- Index.ets                      # Landing screen with animation
|   |-- StationsListPage.ets          # List of all stations
|   |-- PlayerPage.ets                # Main playback UI
|-- services
|   |-- AudioService.ets              # Streaming logic and player control
|-- entryability/                      # Entry definitions (default)
|-- entrybackupability/               # (empty)
```

# Constraints and Restrictions
## Supported Devices
- Huawei Watch 5

# LICENSE

OnlineFM Radio is distributed under the terms of the MIT License.
See the [LICENSE](/LICENSE) for more information.
