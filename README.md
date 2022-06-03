# Rowdy

Pure Rust based Dart/Flutter audio playback library

# Installation


```bash
$ flutter pub add rowdy
```

# Configuration

You'll need the [Rust toolchain](https://rustup.rs) installed in your system

Create a file named `rowdy.cmake` in both `windows` & `linux` directory of the project with following content:

```cmake
include(FetchContent)

FetchContent_Declare(
    Corrosion
    GIT_REPOSITORY https://github.com/AndrewGaspar/corrosion.git
    GIT_TAG origin/master # Optionally specify a version tag or branch here
)

FetchContent_MakeAvailable(Corrosion)

corrosion_import_crate(MANIFEST_PATH flutter/ephemeral/.plugin_symlinks/rowdy/rustee_rowdy/Cargo.toml)

set(CRATE_NAME "rustee_rowdy")

cmake_policy(SET CMP0079 NEW)

target_link_libraries(${BINARY_NAME} PRIVATE ${CRATE_NAME})

list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${CRATE_NAME}-shared>)
```

Add the highlighted line in that place in both `windows/CMakeLists.txt` & `linux/CMakeLists.txt`

```diff
# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)

+ include(./rowdy.cmake)


# === Installation ===
# Support files are copied into place next to the executable, so that it can
# run in place. This is done instead of making a separate bundle (as on Linux)
# so that building and running from within Visual Studio will work.
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
```

# Impletmented Features set (Things that works)
- [x] Local Audio file
- [x] Formats: mp3, flac, wav & ogg. (acc is supported but the decoder is failing for some reason)
- [x] Play, Pause/Resume, Toggle Playback, Stop
- [x] Volume (in percentage)
- [x] Speed
- [x] Seek
- [x] Position (Steaming too)
- [x] On Change Event subscription:
  - [x] Duration
  - [x] PlayerState (TrackChange/Play/Pause/Resume)
  - [x] Speed
  - [x] Volume
  - [x] Playing
- [ ] Network Audio File
- [ ] Audio File Stream
