--------------------------------------------------------------------------------
-- moai solution
--

local match = string.match
function trim(s)
  return match(s,'^()%s*$') and '' or match(s,'^%s*(.*%S)')
end

ROOT_PATH = ".."
DEV_PATH = ""
OUT_PATH = (ROOT_PATH .. "/out/")

LIBMOAI_DEFINES = {
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

LIBMOAI_DEBUG_DEFINES = {
  "FT_DEBUG_LEVEL_ERROR",
  "FT_DEBUG_LEVEL_TRACE",
}

LIBMOAI_RELEASE_DEFINES = {
}

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

--  ROOT_PATH = ".."
--  local DEV_PATH = ""
--  local OUT_PATH = (ROOT_PATH .. "/out/")
  if _ACTION == "gmake" then
    if nil == _OPTIONS.gcc then
      print("GCC flavor must be specified!")
      os.exit(1)
    end

    if "osx" == _OPTIONS.gcc then
      location (ROOT_PATH .. "/build/" .. _ACTION .. "-osx")
      DEV_PATH = trim(os.outputof("xcode-select --print-path")) .. "/Platforms/MacOSX.platform/Developer"
    end

    if "ios" == _OPTIONS.gcc then
      location (ROOT_PATH .. "/build/" .. _ACTION .. "-ios")
      DEV_PATH = trim(os.outputof("xcode-select --print-path")) .. "/Platforms/iPhoneOS.platform/Developer"
    end

    if "linux" == _OPTIONS.gcc then
      location (ROOT_PATH .. "/build/" .. _ACTION .. "-linux")
    end

    OUT_PATH = (ROOT_PATH .. "/out/" .. _OPTIONS.gcc)
  elseif nil ~= _OPTIONS.os then
    OUT_PATH = (ROOT_PATH .. "/out/" .. _OPTIONS.os)
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

  ------------------------------------------------------------------------------
  -- @section MOAI Libs

  require "libmoai-3rdparty"
  require "libmoai-box2d"
  require "libmoai-core"
  require "libmoai-sim"
  require "libmoai-untz"
  require "libmoai-util"

  ------------------------------------------------------------------------------
  -- @section ZL

  require "libzl-gfx"
  require "libzl-util"
  require "libzl-vfs"

  ------------------------------------------------------------------------------
  -- @section Hosts

  require "host-glut"
  require "host-glfw"

  ------------------------------------------------------------------------------

