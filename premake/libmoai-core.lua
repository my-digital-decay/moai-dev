--------------------------------------------------------------------------------
-- libmoai-core project build file
--

project "libmoai-core"
  targetname "moai-core"
  kind "StaticLib"
  language "C++"
  defines (LIBMOAI_DEFINES)
  files {
    ROOT_PATH .. "/src/moai-core/*.cpp",
    ROOT_PATH .. "/3rdparty/luasocket-2.0.2-embed/*.c"
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/lua-5.1.3/src",
    ROOT_PATH .. "/3rdparty/contrib",
    ROOT_PATH .. "/3rdparty/tinyxml",
--      ROOT_PATH .. "/3rdparty/lpng140",
    ROOT_PATH .. "/3rdparty/c-ares-1.7.5",
--      ROOT_PATH .. "/3rdparty/curl-7.19.7/include",
--      ROOT_PATH .. "/3rdparty/curl-7.19.7/lib",
    ROOT_PATH .. "/3rdparty/expat-2.0.1/lib",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/include",
    ROOT_PATH .. "/3rdparty/box2d-2.2.1",
--      ROOT_PATH .. "/3rdparty/chipmunk-5.3.4/include",
--      ROOT_PATH .. "/3rdparty/chipmunk-5.3.4/include/chipmunk",
    ROOT_PATH .. "/3rdparty/luacrypto-0.2.0/src",
    ROOT_PATH .. "/3rdparty/luacurl-1.2.1/src",
    ROOT_PATH .. "/3rdparty/luasocket-2.0.2/src",
    ROOT_PATH .. "/3rdparty/luasql-2.2.0/src",
    ROOT_PATH .. "/3rdparty/libogg-1.2.2/include",
    ROOT_PATH .. "/3rdparty/jansson-2.1/src",
--      ROOT_PATH .. "/3rdparty/jpeg-8c",
    ROOT_PATH .. "/3rdparty/untz/include",
    ROOT_PATH .. "/3rdparty/untz/src",
    ROOT_PATH .. "/3rdparty/libvorbis-1.3.2/lib",
    ROOT_PATH .. "/3rdparty/libvorbis-1.3.2/include",
    ROOT_PATH .. "/3rdparty/tlsf-2.0",
    ROOT_PATH .. "/3rdparty/zlib-1.2.3",
    ROOT_PATH .. "/3rdparty/ooid-0.99",
    ROOT_PATH .. "/3rdparty/sfmt-1.4",
  }
  excludes {
    ROOT_PATH .. "/src/moai-core/MOAIFoo*.cpp",  -- Foo sample
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


