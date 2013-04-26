# ------------------------------------------------------------------------------
# Moai Makefile

all: osx ios
.PHONY: all


#
# Mac OSX
#

premake-osx: premake4.lua
	@echo "Generating makefiles for osx ..."
	@premake --file=./premake4.lua --gcc=osx --platform=x32 gmake
.PHONY: premake-osx

osx-debug:
	@${MAKE} premake-osx
	@${MAKE} -C build/gmake-osx config=debug32
.PHONY: osx-debug

osx-release:
	@${MAKE} premake-osx
	@${MAKE} -C build/gmake-osx config=release32
.PHONY: osx-release

osx: osx-debug osx-release
.PHONY: osx


#
# iOS
#

premake-ios: premake4.lua
	@echo "Generating makefiles for ios ..."
	@premake --file=./premake4.lua --gcc=ios --platform=x32 gmake
.PHONY: premake-ios

ios-debug:
	@${MAKE} premake-ios
	@${MAKE} -C build/gmake-ios config=debug32
.PHONY: ios-debug

ios-release:
	@${MAKE} premake-ios
	@${MAKE} -C build/gmake-ios config=release32
.PHONY: ios-release

ios: ios-debug ios-release
.PHONY: ios


clean:
	@test -d build/gmake-osx && ${MAKE} -C build/gmake-osx clean; true
	@test -d build/gmake-ios && ${MAKE} -C build/gmake-ios clean; true
	@test -d out && rm -fdr out/; true
.PHONY: clean

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "TARGETS:"
	@echo "   all (default)"
	@echo "   osx"
	@echo "   osx-debug"
	@echo "   osx-release"
	@echo "   ios"
	@echo "   ios-debug"
	@echo "   ios-release"
	@echo "   clean"
	@echo "   help"
.PHONY: help

