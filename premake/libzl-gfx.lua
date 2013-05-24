--------------------------------------------------------------------------------
-- libzl-gfx project build file
--

project "libzl-gfx"
  targetname "zl-gfx"
  kind "StaticLib"
  language "C++"
  files {
    ROOT_PATH .. "/src/zl-gfx/pch.cpp",
    ROOT_PATH .. "/3rdparty/glew-1.5.6/src/glew.c",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/glew-1.5.6/include",
    ROOT_PATH .. "/3rdparty/glew-1.5.6/src",
--      ROOT_PATH .. "/3rdparty/tlsf-2.0",
--      ROOT_PATH .. "/3rdparty/zlib-1.2.3",
  }

  configuration "debug"
    targetdir (OUT_PATH .. "/debug/lib")
--      targetsuffix "-d"

  configuration "release"
    targetdir (OUT_PATH .. "/release/lib")

  configuration "osx"
    files {
      ROOT_PATH .. "/src/zl-gfx/zl_gfx_opengl.cpp",
    }

  configuration "ios"
    files {
      ROOT_PATH .. "/src/zl-gfx/zl_gfx_opengl.cpp",
    }

  configuration "linux"
    files {
      ROOT_PATH .. "/src/zl-gfx/zl_gfx_opengl.cpp",
    }

