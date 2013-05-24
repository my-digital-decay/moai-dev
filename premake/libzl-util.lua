--------------------------------------------------------------------------------
-- libzl-util project build file
--

project "libzl-util"
  targetname "zl-util"
  kind "StaticLib"
  language "C++"
  files {
    ROOT_PATH .. "/src/zl-util/*.cpp",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/ooid-0.99",
--      ROOT_PATH .. "/3rdparty/tlsf-2.0",
--      ROOT_PATH .. "/3rdparty/zlib-1.2.3",
  }

  configuration "debug"
    targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

  configuration "release"
    targetdir (OUT_PATH .. "/release/lib")

  configuration "not windows"
    excludes {
      ROOT_PATH .. "/src/zl-util/ZLUnique_win32.cpp",
    }

  configuration "windows"
    excludes {
      ROOT_PATH .. "/src/zl-util/ZLUnique_linux.cpp",
    }

