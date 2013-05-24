--------------------------------------------------------------------------------
-- host-glut project build file
--

project "host-glut"
  kind "ConsoleApp"
  language "C++"
  defines {
    "ENABLE_CUSTOM_WEBVIEW",
  }
  files {
    ROOT_PATH .. "/src/host-glut/GlutHost.cpp",
    ROOT_PATH .. "/src/host-glut/GlutHostMain.cpp",
    ROOT_PATH .. "/src/host-glut/ParticlePresets.cpp",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/src/host-glut"
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
  debug_cfg = configuration "debug"
    targetdir (OUT_PATH .. "/debug")

  release_cfg = configuration "release"
    targetdir (OUT_PATH .. "/release")

  -- platform specific settings
  configuration "osx"
    targetname "moai-osx"
--      files {
--        "src/host-glut/FolderWatcher-mac.mm",
--      }
    linkoptions {
      "-framework AudioToolbox",
      "-framework AudioUnit",
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
      "@cp " .. release_cfg.targetdir .. "/moai-osx ../../bin/"
    }

  configuration "ios"
    targetname "moai-ios"

  configuration { "ios", "release" }
    postbuildcommands {
      "@mkdir ../../bin 2>/dev/null; true",
      "@cp " .. release_cfg.targetdir .. "/moai-ios ../../bin/"
    }

  configuration "linux"
    targetname "moai-linux"
    linkoptions {
      "-L/usr/lib/i386-linux-gnu",
      "-lSDL",
      "-lSDL_sound",
      "-lglut",
      "-lstdc++",
      "-lc",
    }

  configuration { "linux", "release" }
    postbuildcommands {
      "@mkdir ../../bin 2>/dev/null; true",
      "@cp " .. release_cfg.targetdir .. "/moai-linux ../../bin/"
    }

