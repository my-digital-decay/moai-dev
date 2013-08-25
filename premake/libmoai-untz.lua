--------------------------------------------------------------------------------
-- libmoai-untz project build file
--

project "libmoai-untz"
  targetname "moai-untz"
  kind "StaticLib"
  language "C++"
  defines (LIBMOAI_DEFINES)
  files {
    ROOT_PATH .. "/src/moai-untz/*.cpp",
    ROOT_PATH .. "/3rdparty/untz/src/*.cpp",
    ROOT_PATH .. "/3rdparty/libogg-1.2.2/src/*.c",
    ROOT_PATH .. "/3rdparty/libvorbis-1.3.2/lib/*.c",
  }
  excludes {
    ROOT_PATH .. "/3rdparty/libvorbis-1.3.2/lib/barkmel.c",
    ROOT_PATH .. "/3rdparty/libvorbis-1.3.2/lib/psytune.c",
    ROOT_PATH .. "/3rdparty/libvorbis-1.3.2/lib/tone.c",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/untz/include",
    ROOT_PATH .. "/3rdparty/untz/src",
    ROOT_PATH .. "/3rdparty/libogg-1.2.2/include",
    ROOT_PATH .. "/3rdparty/libvorbis-1.3.2/include",
    ROOT_PATH .. "/3rdparty/libvorbis-1.3.2/lib",
    ROOT_PATH .. "/3rdparty/lua-5.1.3/src",
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

  configuration "osx or ios"
    files {
      ROOT_PATH .. "/3rdparty/untz/src/native/ios/*.cpp",
    }
    includedirs {
      ROOT_PATH .. "/3rdparty/untz/src/native/ios",
    }

  configuration "windows"
    files {
      ROOT_PATH .. "/3rdparty/untz/src/native/win/*.cpp",
    }
    includedirs {
      ROOT_PATH .. "/3rdparty/untz/src/native/win",
    }

  configuration "linux"
    files {
      ROOT_PATH .. "/3rdparty/untz/src/native/sdl/*.cpp",
    }
    includedirs {
      ROOT_PATH .. "/3rdparty/untz/src/native/sdl",
    }

