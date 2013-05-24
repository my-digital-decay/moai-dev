--------------------------------------------------------------------------------
-- libmoai-3rdparty project build file
--

project "libmoai-3rdparty"
  targetname "moai-3rdparty"
  kind "StaticLib"
  language "C++"
  defines (LIBMOAI_DEFINES)
  files {
--      "3rdparty/curl-7.19.7/lib/*.c",
    ROOT_PATH .. "/3rdparty/expat-2.01./lib/*.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/autofit/autofit.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/base/ftbase.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/base/ftdebug.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/base/ftinit.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/base/ftsystem.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/bdf/bdf.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/cache/ftcache*.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/cid/type1cid.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/cff/cff.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/gzip/ftgzip.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/lzw/ftlzw.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/pcf/pcf.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/pfr/pfr.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/psaux/psaux.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/pshinter/pshinter.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/psnames/psmodule.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/raster/raster.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/sfnt/sfnt.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/smooth/smooth.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/truetype/truetype.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/type1/type1.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/type42/type42.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/winfonts/winfnt.c",
    ROOT_PATH .. "/3rdparty/lpng140/*.c",
    ROOT_PATH .. "/3rdparty/tinyxml/tinyxml.cpp",
    ROOT_PATH .. "/3rdparty/tinyxml/tinyxmlerror.cpp",
    ROOT_PATH .. "/3rdparty/tinyxml/tinyxmlparser.cpp",
    ROOT_PATH .. "/3rdparty/luasql-2.2.0/src/luasql.c",
    ROOT_PATH .. "/3rdparty/luasql-2.2.0/src/ls_sqlite3.c",
    ROOT_PATH .. "/3rdparty/sqlite-3.6.16/sqlite3.c",
    ROOT_PATH .. "/3rdparty/jansson-2.1/src/*.c",
    ROOT_PATH .. "/3rdparty/lua-5.1.3/src/*.c",
--[[
    ROOT_PATH .. "/3rdparty/jpeg-8c/jaricom.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jc*.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jd*.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jerror-moai.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jf*.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/ji*.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jmemmgr.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jmemnobs.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jquant1.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jquant2.c",
    ROOT_PATH .. "/3rdparty/jpeg-8c/jutils.c",
--]]
    ROOT_PATH .. "/3rdparty/tlsf-2.0/tlsf.c",
    ROOT_PATH .. "/3rdparty/zlib-1.2.3/*.c",
    ROOT_PATH .. "/3rdparty/contrib/whirlpool.c",
    ROOT_PATH .. "/3rdparty/contrib/utf8.c",
    ROOT_PATH .. "/3rdparty/sfmt-1.4/SFMT.c",
  }
  excludes {
--      ROOT_PATH .. "/3rdparty/curl-7.19.7/lib/amigaos.c",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/base/ftmac.c",
    ROOT_PATH .. "/3rdparty/lpng140/example.c",
    ROOT_PATH .. "/3rdparty/zlib-1.2.3/example.c",
    ROOT_PATH .. "/3rdparty/zlib-1.2.3/minigzip.c",
  }
  includedirs {
    ROOT_PATH .. "/src",
--      ROOT_PATH .. "/3rdparty/curl-7.19.7/include-iphone",
--      ROOT_PATH .. "/3rdparty/curl-7.19.7/lib",
    ROOT_PATH .. "/3rdparty",
    ROOT_PATH .. "/3rdparty/expat-2.0.1/lib",
    ROOT_PATH .. "/3rdparty/freetype-2.4.4/include",
    ROOT_PATH .. "/3rdparty/jansson-2.1/src",
--      ROOT_PATH .. "/3rdparty/jpeg-8c",
    ROOT_PATH .. "/3rdparty/lua-5.1.3/src",
    ROOT_PATH .. "/3rdparty/sqlite-3.6.16",
    ROOT_PATH .. "/3rdparty/zlib-1.2.3",
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
      ROOT_PATH .. "/3rdparty/freetype-2.4.4/src/winfonts/*.c",
    }

