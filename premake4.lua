--------------------------------------------------------------------------------
-- libmoai build
--

local match = string.match
function trim(s)
  return match(s,'^()%s*$') and '' or match(s,'^%s*(.*%S)')
end

--------------------------------------------------------------------------------
solution "moai"
  configurations { "debug", "release" }

  newoption {
    trigger = "gcc",
    value = "GCC",
    description = "Choose GCC flavor",
    allowed = {
      { "osx", "OS X" },
      { "ios", "iOS" },
    }
  }

  local DEV_PATH = ""
  local OUT_PATH = ("out/")
  if _ACTION == "gmake" then
    if nil == _OPTIONS.gcc then
      print("GCC flavor must be specified!")
      os.exit(1)
    end

    if "osx" == _OPTIONS.gcc then
      location ("build/" .. _ACTION .. "-osx")
      DEV_PATH = trim(os.outputof("xcode-select --print-path")) .. "/Platforms/MacOSX.platform/Developer"
    end

    if "ios" == _OPTIONS.gcc then
      location ("build/" .. _ACTION .. "-ios")
      DEV_PATH = trim(os.outputof("xcode-select --print-path")) .. "/Platforms/iPhoneOS.platform/Developer"
    end

    OUT_PATH = ("out/" .. _OPTIONS.gcc)
  elseif nil ~= _OPTIONS.os then
    OUT_PATH = ("out/" .. _OPTIONS.os)
  end

  objdir (OUT_PATH .. "/obj")

  flags {
    "StaticRuntime",
    "NoMinimalRebuild",
    "NoPCH",
--    "NativeWChar",
    "NoRTTI",
    "NoExceptions",
    "NoEditAndContinue",
  }

  -- clean configuration to start
  configuration {}
    defines {
      "HAVE_MEMMOVE",
      "TIXML_USE_STL",
      "XML_STATIC",
--      "SQLITE_ENABLE_COLUMN_METADATA",
--      "SQLITE_ENABLE_FTS3",
--      "SQLITE_ENABLE_FTS3_PARENTHESIS",
    }

  configuration "debug"
    defines {
      "_DEBUG",
      "DEBUG",
    }
    flags {
      "Symbols",
    }

  configuration "release"
    defines {
      "NDEBUG",
    }
    flags {
      "OptimizeSpeed",
 --     "Symbols",
    }

  configuration "osx"
    defines {
      "MACOSX",
      "DARWIN_NO_CARBON",
--      "POSIX",
      "L_ENDIAN",
    }

  local LIBMOAI_DEFINES = {
    "FT2_BUILD_LIBRARY",
--    "BUILDING_LIBCURL",
--    "USE_ARES",
--    "USE_OPENSSL",
--    "USE_SSLEAY",
--    "USE_SSL",
--    "OPENSSL_NO_GMP",
--    "OPENSSL_NO_JPAKE",
--    "OPENSSL_NO_MD2",
--    "OPENSSL_NO_RC5",
--    "OPENSSL_NO_RFC3779",
--    "OPENSSL_NO_STORE",
  }

  local LIBMOAI_DEBUG_DEFINES = {
    "FT_DEBUG_LEVEL_ERROR",
    "FT_DEBUG_LEVEL_TRACE",
  }

  local LIBMOAI_RELEASE_DEFINES = {
  }

  ------------------------------------------------------------------------------
  project "libmoai-core"
    targetname "moai-core"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
      "src/aku/AKU.cpp",
      "src/aku/AKU-particles.cpp",
      "src/aku/AKU-audiosampler.cpp",
      "src/aku/pch.cpp",
      "src/moaicore/**.cpp",
      "src/uslscore/**.cpp",
      "3rdparty/luasocket-2.0.2-embed/*.c"
    }
    includedirs {
      "src",
      "src/config",
      "3rdparty",
      "3rdparty/lua-5.1.3/src",
      "3rdparty/contrib",
      "3rdparty/tinyxml",
      "3rdparty/lpng140",
      "3rdparty/c-ares-1.7.5",
--      "3rdparty/curl-7.19.7/lib",
      "3rdparty/expat-2.0.1/lib",
      "3rdparty/freetype-2.4.4/include",
      "3rdparty/box2d-2.2.1",
--      "3rdparty/chipmunk-5.3.4/include",
--      "3rdparty/chipmunk-5.3.4/include/chipmunk",
      "3rdparty/luacrypto-0.2.0/src",
--      "3rdparty/luacurl-1.2.1/src",
      "3rdparty/luasocket-2.0.2/src",
      "3rdparty/luasql-2.2.0/src",
      "3rdparty/libogg-1.2.2/include",
      "3rdparty/jansson-2.1/src",
      "3rdparty/jpeg-8c",
      "3rdparty/untz/include",
      "3rdparty/untz/src",
      "3rdparty/libvorbis-1.3.2/lib",
      "3rdparty/libvorbis-1.3.2/include",
      "3rdparty/tlsf-2.0",
      "3rdparty/zlib-1.2.3",
      "3rdparty/ooid-0.99",
      "3rdparty/sfmt-1.4",
    }
    excludes {
      "src/moaicore/MOAICp*.cpp",
    }
    buildoptions { "-include zlcore/zl_replace.h" }

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
        "3rdparty/openssl-1.0.0d/include-iphone",
        "3rdparty/curl-7.19.7/include-iphone",
        "3rdparty/tapjoyiOS-8.1.9/TapjoyConnect",
        "3rdparty/crittercismiOS-3.1.5/CrittercismSDK",
        "3rdparty/adcolonyiOS-197/Library",
        "3rdparty/chartboostiOS-2.9.1",
        "3rdparty/facebookiOS-3.0.6.b/src",
      }


  ------------------------------------------------------------------------------
  project "libmoai-zlcore"
    targetname "moai-zlcore"
    kind "StaticLib"
    language "C++"
    files {
      "src/zlcore/**.cpp",
    }
    includedirs {
      "src",
      "3rdparty",
      "3rdparty/tlsf-2.0",
    }

    configuration "debug"
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      targetdir (OUT_PATH .. "/release/lib")

    configuration "osx"

    configuration "ios"


  ------------------------------------------------------------------------------
  project "libmoai-3rdparty"
    targetname "moai-3rdparty"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
--      "3rdparty/curl-7.19.7/lib/*.c",
      "3rdparty/expat-2.01./lib/*.c",
      "3rdparty/freetype-2.4.4/src/**.c",
      "3rdparty/lpng140/*.c",
      "3rdparty/tinyxml/tinyxml.cpp",
      "3rdparty/tinyxml/tinyxmlerror.cpp",
      "3rdparty/tinyxml/tinyxmlparser.cpp",
      "3rdparty/luasql-2.2.0/src/luasql.c",
      "3rdparty/luasql-2.2.0/src/ls_sqlite3.c",
--      "3rdparty/sqlite-3.6.16/sqlite3.c",
      "3rdparty/jansson-2.1/src/*.c",
      "3rdparty/lua-5.1.3/src/*.c",
      "3rdparty/jpeg-8c/jaricom.c",
      "3rdparty/jpeg-8c/jc*.c",
      "3rdparty/jpeg-8c/jd*.c",
      "3rdparty/jpeg-8c/jerror-moai.c",
      "3rdparty/jpeg-8c/jf*.c",
      "3rdparty/jpeg-8c/ji*.c",
      "3rdparty/jpeg-8c/jmemmgr.c",
      "3rdparty/jpeg-8c/jmemnobs.c",
      "3rdparty/jpeg-8c/jquant1.c",
      "3rdparty/jpeg-8c/jquant2.c",
      "3rdparty/jpeg-8c/jutils.c",
      "3rdparty/tlsf-2.0/tlsf.c",
      "3rdparty/zlib-1.2.3/*.c",
      "3rdparty/contrib/whirlpool.c",
      "3rdparty/contrib/utf8.c",
      "3rdparty/sfmt-1.4/sfmt.c",
    }
    excludes {
      "3rdparty/curl-7.19.7/lib/amigaos.c",
      "3rdparty/freetype-2.4.4/src/gzip/*",
      "3rdparty/freetype-2.4.4/src/autofit/aflatin2.c",
      "3rdparty/lpng140/example.c",
      "3rdparty/zlib-1.2.3/example.c",
      "3rdparty/zlib-1.2.3/minigzip.c",
    }
    includedirs {
      "src",
--      "3rdparty/curl-7.19.7/include-iphone",
--      "3rdparty/curl-7.19.7/lib",
      "3rdparty",
      "3rdparty/expat-2.0.1/lib",
      "3rdparty/freetype-2.4.4/include",
      "3rdparty/jansson-2.1/src",
      "3rdparty/jpeg-8c",
    }
    buildoptions {
      "-std=c99",
      "-include zlcore/zl_replace.h",
    }

    configuration "debug"
      defines (LIBMOAI_DEBUG_DEFINES)
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      defines (LIBMOAI_RELEASE_DEFINES)
      targetdir (OUT_PATH .. "/release/lib")

    configuration "osx"

    configuration "ios"


------------------------------------------------------------------------------
  project "libmoai-physics"
    targetname "moai-physics"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
      "3rdparty/box2d-2.2.1/Box2D/**.cpp",
--      "3rdparty/chipmunk-5.3.4/src/*.c",
--      "3rdparty/chipmunk-5.3.4/src/constraints/*.c",
    }
    includedirs {
      "src",
      "3rdparty",
      "3rdparty/box2d-2.2.1",
--      "3rdparty/chipmunk-5.3.4/include",
--      "3rdparty/chipmunk-5.3.4/include/chipmunk",
    }
    buildoptions { "-include zlcore/zl_replace.h" }

    configuration "debug"
      defines (LIBMOAI_DEBUG_DEFINES)
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      defines (LIBMOAI_RELEASE_DEFINES)
      targetdir (OUT_PATH .. "/release/lib")


------------------------------------------------------------------------------
  project "libmoai-audio"
    targetname "moai-audio"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
      "src/aku/AKU-untz.cpp",
      "src/moaiext-untz/*.cpp",
      "3rdparty/untz/src/*.cpp",
      "3rdparty/libogg-1.2.2/src/*.c",
      "3rdparty/libvorbis-1.3.2/lib/*.c",
    }
    excludes {
      "3rdparty/libvorbis-1.3.2/lib/barkmel.c",
      "3rdparty/libvorbis-1.3.2/lib/psytune.c",
      "3rdparty/libvorbis-1.3.2/lib/tone.c",
    }
    includedirs {
      "src",
      "src/config",
      "src/moaiext-untz",
      "3rdparty",
      "3rdparty/untz/include",
      "3rdparty/untz/src",
      "3rdparty/libogg-1.2.2/include",
      "3rdparty/libvorbis-1.3.2/include",
      "3rdparty/libvorbis-1.3.2/lib",
      "3rdparty/tinyxml",
      "3rdparty/freetype-2.4.4/include",
      "3rdparty/box2d-2.2.1",
    }
    buildoptions { "-include zlcore/zl_replace.h" }

    configuration "osx or ios"
      files {
        "3rdparty/untz/src/native/ios/*.cpp",
      }
      includedirs {
        "3rdparty/untz/src/native/ios",
      }

    configuration "windows"
      files {
        "3rdparty/untz/src/native/win/*.cpp",
      }
      includedirs {
        "3rdparty/untz/src/native/win",
      }

    configuration "debug"
      defines (LIBMOAI_DEBUG_DEFINES)
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      defines (LIBMOAI_RELEASE_DEFINES)
      targetdir (OUT_PATH .. "/release/lib")


  ------------------------------------------------------------------------------
  project "host"
    kind "ConsoleApp"
    language "C++"
    defines {
      "ENABLE_CUSTOM_WEBVIEW",
--      "GLUTHOST_USE_LUAEXT",
      "GLUTHOST_USE_UNTZ",
    }
    files {
      "src/hosts/GlutHost.cpp",
      "src/hosts/GlutHostMain.cpp",
      "src/hosts/ParticlePresets.cpp",
      "src/hosts/FolderWatcher-mac.mm",
    }
    includedirs {
      "src",
      "src/hosts"
    }
    links {
      "libmoai-core",
      "libmoai-zlcore",
      "libmoai-3rdparty",
      "libmoai-physics",
      "libmoai-audio",
    }

    -- cross-platform configuration specific settings
    configuration "debug"
      targetdir (OUT_PATH .. "/debug")

    cfg = configuration "release"
      targetdir (OUT_PATH .. "/release")

    -- platform specific settings
    configuration "osx"
      targetname "moai-osx"
      buildoptions {
        "-F\"" .. DEV_PATH .. "/SDKs/MacOSX10.8.sdk/System/Library/Frameworks\"",
      }
      linkoptions {
        "-F\"" .. DEV_PATH .. "/SDKs/MacOSX10.8.sdk/System/Library/Frameworks\"",
        "-framework System",
        "-framework AudioToolbox",
        "-framework AudioUnit",
        "-framework Carbon",
        "-framework CoreServices",
        "-framework CoreFoundation",
        "-framework Foundation",
--        "-framework IOKit",
        "-framework GLUT",
        "-framework OpenGL",
--        "-lssl",
        "-lcrypto"
      }

    configuration { "osx", "release" }
      postbuildcommands {
        "mkdir ../../bin 2>/dev/null; true",
        "cp " .. cfg.targetdir .. "/moai-osx ../../bin/"
      }

    configuration "ios"
      targetname "moai-ios"

    configuration { "ios", "release" }
      postbuildcommands {
        "mkdir ../../bin 2>/dev/null; true",
        "cp " .. cfg.targetdir .. "/moai-ios ../../bin/"
      }

  ------------------------------------------------------------------------------

