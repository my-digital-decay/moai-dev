--------------------------------------------------------------------------------
-- libmoai-util project build file
--

project "libmoai-util"
  targetname "moai-util"
  kind "StaticLib"
  language "C++"
  defines (LIBMOAI_DEFINES)
  files {
    ROOT_PATH .. "/src/moai-util/*.cpp",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/jansson-2.1/src",
    ROOT_PATH .. "/3rdparty/lua-5.1.3/src",
    ROOT_PATH .. "/3rdparty/sfmt-1.4",
    ROOT_PATH .. "/3rdparty/tinyxml",
  }
  buildoptions { "-include zl-vfs/zl_replace.h" }

  -- cross-platform configuration specific settings
  configuration "debug"
    defines (LIBMOAI_DEBUG_DEFINES)
    targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

  configuration "release"
    defines (LIBMOAI_RELEASE_DEFINES)
    targetdir (OUT_PATH .. "/release/lib")

  -- platform specific settings
  configuration "osx"
    excludes {
      ROOT_PATH .. "/src/moaicore/MOAIMutex_win32.cpp",
      ROOT_PATH .. "/src/moaicore/MOAIThread_win32.cpp",
    }

  configuration "ios"
    includedirs {
--        ROOT_PATH .. "/3rdparty/openssl-1.0.0d/include-iphone",
--        ROOT_PATH .. "/3rdparty/curl-7.19.7/include-iphone",
      ROOT_PATH .. "/3rdparty/tapjoyiOS-8.1.9/TapjoyConnect",
      ROOT_PATH .. "/3rdparty/crittercismiOS-3.1.5/CrittercismSDK",
      ROOT_PATH .. "/3rdparty/adcolonyiOS-197/Library",
      ROOT_PATH .. "/3rdparty/chartboostiOS-2.9.1",
      ROOT_PATH .. "/3rdparty/facebookiOS-3.0.6.b/src",
    }

  configuration "linux"
    includedirs {
--        ROOT_PATH .. "/3rdparty/openssl-1.0.0d/include",
    }
    excludes {
      ROOT_PATH .. "/src/moaicore/MOAIMutex_win32.cpp",
      ROOT_PATH .. "/src/moaicore/MOAIThread_win32.cpp",
    }

