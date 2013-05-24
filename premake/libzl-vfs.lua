--------------------------------------------------------------------------------
-- libzl-vfs project build file
--

project "libzl-vfs"
  targetname "zl-vfs"
  kind "StaticLib"
  language "C++"
  files {
    ROOT_PATH .. "/src/zl-vfs/*.cpp",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/tlsf-2.0",
--      ROOT_PATH .. "/3rdparty/zlib-1.2.3",
  }

  configuration "debug"
    targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

  configuration "release"
    targetdir (OUT_PATH .. "/release/lib")

