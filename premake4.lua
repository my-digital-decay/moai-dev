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
      { "linux", "Linux" },
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

    if "linux" == _OPTIONS.gcc then
      location ("build/" .. _ACTION .. "-linux")
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
--    "FloatFast",
  }

  -- clean configuration to start
  configuration {}
    defines {
      "HAVE_MEMMOVE",
      "TIXML_USE_STL",
      "XML_STATIC",
      "SQLITE_ENABLE_COLUMN_METADATA",
      "SQLITE_ENABLE_FTS3",
      "SQLITE_ENABLE_FTS3_PARENTHESIS",
    }
    buildoptions {
--      "-nostdinc",
    }
    linkoptions {
      "-nodefaultlibs",
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
    flags {
      "EnableSSE2"
    }
    defines {
      "MACOSX",
      "DARWIN_NO_CARBON",
      "POSIX",
      "L_ENDIAN",
    }
    buildoptions {
      "-F\"" .. DEV_PATH .. "/SDKs/MacOSX10.8.sdk/System/Library/Frameworks\"",
      "-I\"" .. DEV_PATH .. "/SDKs/MacOSX10.8.sdk/usr/include\"",
    }
    linkoptions {
      "-F\"" .. DEV_PATH .. "/SDKs/MacOSX10.8.sdk/System/Library/Frameworks\"",
      "-L\"" .. DEV_PATH .. "/SDKs/MacOSX10.8.sdk/usr/lib\"",
    }

  configuration "linux"
    flags {
      "EnableSSE2"
    }
    defines {
      "LINUX",
      "L_ENDIAN",
      "POSIX",
      "__SDL__",
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
    "USE_UNTZ",
  }

  local LIBMOAI_DEBUG_DEFINES = {
    "FT_DEBUG_LEVEL_ERROR",
    "FT_DEBUG_LEVEL_TRACE",
  }

  local LIBMOAI_RELEASE_DEFINES = {
  }


  ------------------------------------------------------------------------------
  -- @section MOAI Libs

  ------------------------------------------------------------------------------
  project "libmoai-core"
    targetname "moai-core"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
      "src/moai-core/*.cpp",
      "3rdparty/luasocket-2.0.2-embed/*.c"
    }
    includedirs {
      "src",
      "src/config",
      "3rdparty",
      "3rdparty/lua-5.1.3/src",
      "3rdparty/contrib",
      "3rdparty/tinyxml",
--      "3rdparty/lpng140",
      "3rdparty/c-ares-1.7.5",
--      "3rdparty/curl-7.19.7/include",
--      "3rdparty/curl-7.19.7/lib",
      "3rdparty/expat-2.0.1/lib",
      "3rdparty/freetype-2.4.4/include",
      "3rdparty/box2d-2.2.1",
--      "3rdparty/chipmunk-5.3.4/include",
--      "3rdparty/chipmunk-5.3.4/include/chipmunk",
      "3rdparty/luacrypto-0.2.0/src",
      "3rdparty/luacurl-1.2.1/src",
      "3rdparty/luasocket-2.0.2/src",
      "3rdparty/luasql-2.2.0/src",
      "3rdparty/libogg-1.2.2/include",
      "3rdparty/jansson-2.1/src",
--      "3rdparty/jpeg-8c",
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
      "src/moai-core/MOAIFoo*.cpp",  -- Foo sample
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
--        "3rdparty/openssl-1.0.0d/include-iphone",
--        "3rdparty/curl-7.19.7/include-iphone",
        "3rdparty/tapjoyiOS-8.1.9/TapjoyConnect",
        "3rdparty/crittercismiOS-3.1.5/CrittercismSDK",
        "3rdparty/adcolonyiOS-197/Library",
        "3rdparty/chartboostiOS-2.9.1",
        "3rdparty/facebookiOS-3.0.6.b/src",
      }

    configuration "linux"
      includedirs {
--        "3rdparty/openssl-1.0.0d/include",
      }

  ------------------------------------------------------------------------------
  project "libmoai-util"
    targetname "moai-util"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
      "src/moai-util/*.cpp",
    }
    includedirs {
      "src",
      "src/config",
      "3rdparty",
      "3rdparty/jansson-2.1/src",
      "3rdparty/sfmt-1.4",
      "3rdparty/tinyxml",
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
        "src/moaicore/MOAIMutex_win32.cpp",
        "src/moaicore/MOAIThread_win32.cpp",
      }

    configuration "ios"
      includedirs {
--        "3rdparty/openssl-1.0.0d/include-iphone",
--        "3rdparty/curl-7.19.7/include-iphone",
        "3rdparty/tapjoyiOS-8.1.9/TapjoyConnect",
        "3rdparty/crittercismiOS-3.1.5/CrittercismSDK",
        "3rdparty/adcolonyiOS-197/Library",
        "3rdparty/chartboostiOS-2.9.1",
        "3rdparty/facebookiOS-3.0.6.b/src",
      }

    configuration "linux"
      includedirs {
--        "3rdparty/openssl-1.0.0d/include",
      }
      excludes {
        "src/moaicore/MOAIMutex_win32.cpp",
        "src/moaicore/MOAIThread_win32.cpp",
      }


  ------------------------------------------------------------------------------
  project "libmoai-3rdparty"
    targetname "moai-3rdparty"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
--      "3rdparty/curl-7.19.7/lib/*.c",
      "3rdparty/expat-2.01./lib/*.c",
      "3rdparty/freetype-2.4.4/src/autofit/autofit.c",
      "3rdparty/freetype-2.4.4/src/base/ftbase.c",
      "3rdparty/freetype-2.4.4/src/base/ftdebug.c",
      "3rdparty/freetype-2.4.4/src/base/ftinit.c",
      "3rdparty/freetype-2.4.4/src/base/ftsystem.c",
      "3rdparty/freetype-2.4.4/src/bdf/bdf.c",
      "3rdparty/freetype-2.4.4/src/cache/ftcache*.c",
      "3rdparty/freetype-2.4.4/src/cid/type1cid.c",
      "3rdparty/freetype-2.4.4/src/cff/cff.c",
      "3rdparty/freetype-2.4.4/src/gzip/ftgzip.c",
      "3rdparty/freetype-2.4.4/src/lzw/ftlzw.c",
      "3rdparty/freetype-2.4.4/src/pcf/pcf.c",
      "3rdparty/freetype-2.4.4/src/pfr/pfr.c",
      "3rdparty/freetype-2.4.4/src/psaux/psaux.c",
      "3rdparty/freetype-2.4.4/src/pshinter/pshinter.c",
      "3rdparty/freetype-2.4.4/src/psnames/psmodule.c",
      "3rdparty/freetype-2.4.4/src/raster/raster.c",
      "3rdparty/freetype-2.4.4/src/sfnt/sfnt.c",
      "3rdparty/freetype-2.4.4/src/smooth/smooth.c",
      "3rdparty/freetype-2.4.4/src/truetype/truetype.c",
      "3rdparty/freetype-2.4.4/src/type1/type1.c",
      "3rdparty/freetype-2.4.4/src/type42/type42.c",
      "3rdparty/freetype-2.4.4/src/winfonts/winfnt.c",
      "3rdparty/lpng140/*.c",
      "3rdparty/tinyxml/tinyxml.cpp",
      "3rdparty/tinyxml/tinyxmlerror.cpp",
      "3rdparty/tinyxml/tinyxmlparser.cpp",
      "3rdparty/luasql-2.2.0/src/luasql.c",
      "3rdparty/luasql-2.2.0/src/ls_sqlite3.c",
      "3rdparty/sqlite-3.6.16/sqlite3.c",
      "3rdparty/jansson-2.1/src/*.c",
      "3rdparty/lua-5.1.3/src/*.c",
--[[
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
--]]
      "3rdparty/tlsf-2.0/tlsf.c",
      "3rdparty/zlib-1.2.3/*.c",
      "3rdparty/contrib/whirlpool.c",
      "3rdparty/contrib/utf8.c",
      "3rdparty/sfmt-1.4/SFMT.c",
    }
    excludes {
--      "3rdparty/curl-7.19.7/lib/amigaos.c",
      "3rdparty/freetype-2.4.4/src/base/ftmac.c",
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
--      "3rdparty/jpeg-8c",
      "3rdparty/lua-5.1.3/src",
      "3rdparty/sqlite-3.6.16",
      "3rdparty/zlib-1.2.3",
    }
    buildoptions {
      "-std=c99",
--      "-include zl-vfs/zl_replace.h",
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

    configuration "linux"
      defines {
        "SQLITE_HOMEGROWN_RECURSIVE_MUTEX"
      }
      excludes {
        "3rdparty/freetype-2.4.4/src/winfonts/*.c",
      }


  ------------------------------------------------------------------------------
  project "libmoai-box2d"
    targetname "moai-box2d"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
      "src/moai-box2d/*.cpp",
      "3rdparty/box2d-2.2.1/Box2D/**.cpp",
    }
    includedirs {
      "src",
      "src/config",
      "3rdparty",
      "3rdparty/box2d-2.2.1",
      "3rdparty/tinyxml", -- dependency ??
      "3rdparty/freetype-2.4.4/include", -- remove dependency
    }
    buildoptions { "-include zl-vfs/zl_replace.h" }

    configuration "debug"
      defines (LIBMOAI_DEBUG_DEFINES)
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      defines (LIBMOAI_RELEASE_DEFINES)
      targetdir (OUT_PATH .. "/release/lib")


  ------------------------------------------------------------------------------
  project "libmoai-untz"
    targetname "moai-untz"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
      "src/moai-untz/*.cpp",
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
      "3rdparty",
      "3rdparty/untz/include",
      "3rdparty/untz/src",
      "3rdparty/libogg-1.2.2/include",
      "3rdparty/libvorbis-1.3.2/include",
      "3rdparty/libvorbis-1.3.2/lib",
      "3rdparty/tinyxml", -- dependency ??
      "3rdparty/freetype-2.4.4/include", -- remove dependency
    }
    buildoptions { "-include zl-vfs/zl_replace.h" }

    configuration "debug"
      defines (LIBMOAI_DEBUG_DEFINES)
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      defines (LIBMOAI_RELEASE_DEFINES)
      targetdir (OUT_PATH .. "/release/lib")

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

    configuration "linux"
      files {
        "3rdparty/untz/src/native/sdl/*.cpp",
      }
      includedirs {
        "3rdparty/untz/src/native/sdl",
      }

  ------------------------------------------------------------------------------
  project "libmoai-sim"
    targetname "moai-sim"
    kind "StaticLib"
    language "C++"
    defines (LIBMOAI_DEFINES)
    files {
      "src/moai-sim/*.cpp",
    }
    includedirs {
      "src",
      "src/config",
      "3rdparty",
      "3rdparty/box2d-2.2.1",
      "3rdparty/lpng140",
      "3rdparty/tinyxml", -- dependency ??
      "3rdparty/freetype-2.4.4/include",
    }
    buildoptions { "-include zl-vfs/zl_replace.h" }

    configuration "debug"
      defines (LIBMOAI_DEBUG_DEFINES)
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      defines (LIBMOAI_RELEASE_DEFINES)
      targetdir (OUT_PATH .. "/release/lib")

  ------------------------------------------------------------------------------
  -- @section ZL

  ------------------------------------------------------------------------------
  project "libzl-gfx"
    targetname "zl-gfx"
    kind "StaticLib"
    language "C++"
    files {
      "src/zl-gfx/pch.cpp",
      "3rdparty/glew-1.5.6/src/glew.c",
    }
    includedirs {
      "src",
      "src/config",
      "3rdparty",
      "3rdparty/glew-1.5.6/include",
      "3rdparty/glew-1.5.6/src",
--      "3rdparty/tlsf-2.0",
--      "3rdparty/zlib-1.2.3",
    }

    configuration "debug"
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      targetdir (OUT_PATH .. "/release/lib")

    configuration "osx"
      files {
        "src/zl-gfx/zl_gfx_opengl.cpp",
      }

    configuration "ios"
      files {
        "src/zl-gfx/zl_gfx_opengl.cpp",
      }

    configuration "linux"
      files {
        "src/zl-gfx/zl_gfx_opengl.cpp",
      }


  ------------------------------------------------------------------------------
  project "libzl-util"
    targetname "zl-util"
    kind "StaticLib"
    language "C++"
    files {
      "src/zl-util/*.cpp",
    }
    includedirs {
      "src",
      "src/config",
      "3rdparty",
      "3rdparty/ooid-0.99",
--      "3rdparty/tlsf-2.0",
--      "3rdparty/zlib-1.2.3",
    }

    configuration "debug"
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      targetdir (OUT_PATH .. "/release/lib")

    configuration "not windows"
      excludes {
        "src/zl-util/ZLUnique_win32.cpp",
      }

    configuration "windows"
      excludes {
        "src/zl-util/ZLUnique_linux.cpp",
      }


  ------------------------------------------------------------------------------
  project "libzl-vfs"
    targetname "zl-vfs"
    kind "StaticLib"
    language "C++"
    files {
      "src/zl-vfs/*.cpp",
    }
    includedirs {
      "src",
      "src/config",
      "3rdparty",
      "3rdparty/tlsf-2.0",
--      "3rdparty/zlib-1.2.3",
    }

    configuration "debug"
      targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

    configuration "release"
      targetdir (OUT_PATH .. "/release/lib")


  ------------------------------------------------------------------------------
  -- @section Hosts

  ------------------------------------------------------------------------------
  project "glut-host"
    kind "ConsoleApp"
    language "C++"
    defines {
      "ENABLE_CUSTOM_WEBVIEW",
--      "GLUTHOST_USE_LUAEXT",
      "GLUTHOST_USE_UNTZ",
    }
    files {
      "src/host-glut/GlutHost.cpp",
      "src/host-glut/GlutHostMain.cpp",
      "src/host-glut/ParticlePresets.cpp",
    }
    includedirs {
      "src",
      "src/config",
      "src/host-glut"
    }
    links {
      "libmoai-core",
      "libmoai-util",
      "libmoai-3rdparty",
      "libmoai-box2d",
      "libmoai-untz",
      "libmoai-sim",
      "libzl-gfx",
      "libzl-util",
      "libzl-vfs",
    }

    -- cross-platform configuration specific settings
    configuration "debug"
      targetdir (OUT_PATH .. "/debug")

    cfg = configuration "release"
      targetdir (OUT_PATH .. "/release")

    -- platform specific settings
    configuration "osx"
      targetname "moai-osx"
--      files {
--        "src/host-glut/FolderWatcher-mac.mm",
--      }
      linkoptions {
--        "-framework System",
        "-framework AudioToolbox",
        "-framework AudioUnit",
--        "-framework Carbon",
        "-framework CoreServices",
        "-framework CoreFoundation",
        "-framework Foundation",
--        "-framework IOKit",
        "-framework GLUT",
        "-framework OpenGL",
        "-lssl",
        "-lcrypto",
        "-lstdc++",
        "-lc",
      }

    configuration { "osx", "release" }
      postbuildcommands {
        "@mkdir ../../bin 2>/dev/null; true",
        "@cp " .. cfg.targetdir .. "/moai-osx ../../bin/"
      }

    configuration "ios"
      targetname "moai-ios"

    configuration { "ios", "release" }
      postbuildcommands {
        "@mkdir ../../bin 2>/dev/null; true",
        "@cp " .. cfg.targetdir .. "/moai-ios ../../bin/"
      }

    configuration "linux"
      targetname "moai-linux"
      linkoptions {
        "-L/usr/lib/i386-linux-gnu",
        "-lSDL",
        "-lSDL_sound",
        "-lglut",
      }

    configuration { "linux", "release" }
      postbuildcommands {
        "@mkdir ../../bin 2>/dev/null; true",
        "@cp " .. cfg.targetdir .. "/moai-linux ../../bin/"
      }

  ------------------------------------------------------------------------------

