include theos/makefiles/common.mk

export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2223

export ARCHS=armv7
export TARGET=iphone:5.0
export TARGET_CC = xcrun -sdk iphoneos clang
export TARGET_CXX = xcrun -sdk iphoneos clang++
export TARGET_LD = xcrun -sdk iphoneos clang++


TWEAK_NAME = harlem
harlem_FILES = Tweak.xm VLMHarlemShake.m
harlem_FRAMEWORKS = UIKit QuartzCore CoreGraphics AVFoundation
harlem_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk
