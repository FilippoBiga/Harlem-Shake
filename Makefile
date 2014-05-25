export TARGET = iphone:latest:6.0
export ARCHS = armv7 armv7s arm64
export CFLAGS = -Wall

export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2226

include theos/makefiles/common.mk

TWEAK_NAME = harlem
harlem_FILES = Tweak.xm VLMHarlemShake.m
harlem_FRAMEWORKS = UIKit QuartzCore CoreGraphics AVFoundation
harlem_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
