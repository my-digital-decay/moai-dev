--------------------------------------------------------------------------------
-- libmoai-sim project build file
--

project "libmoai-sim"
  targetname "moai-sim"
  kind "StaticLib"
  language "C++"
  defines (LIBMOAI_DEFINES)
  files {
    ROOT_PATH .. "/src/moai-sim/*.cpp",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/box2d-2.2.1",
    ROOT_PATH .. "/3rdparty/lpng140",
    ROOT_PATH .. "/3rdparty/tinyxml", -- dependency ??
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/include",
  }
  buildoptions { "-include zl-vfs/zl_replace.h" }

  configuration "debug"
    defines (LIBMOAI_DEBUG_DEFINES)
    targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

  configuration "release"
    defines (LIBMOAI_RELEASE_DEFINES)
    targetdir (OUT_PATH .. "/release/lib")

