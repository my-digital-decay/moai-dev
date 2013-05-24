--------------------------------------------------------------------------------
-- libmoai-box2d project build file
--

project "libmoai-box2d"
  targetname "moai-box2d"
  kind "StaticLib"
  language "C++"
  defines (LIBMOAI_DEFINES)
  files {
    ROOT_PATH .. "/src/moai-box2d/*.cpp",
    ROOT_PATH .. "/3rdparty/box2d-2.2.1/Box2D/**.cpp",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/box2d-2.2.1",
    ROOT_PATH .. "/3rdparty/tinyxml", -- dependency ??
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/include", -- remove dependency
  }
  buildoptions { "-include zl-vfs/zl_replace.h" }

  configuration "debug"
    defines (LIBMOAI_DEBUG_DEFINES)
    targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

  configuration "release"
    defines (LIBMOAI_RELEASE_DEFINES)
    targetdir (OUT_PATH .. "/release/lib")

