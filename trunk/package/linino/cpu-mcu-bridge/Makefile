#
# Copyright (c) 2013 Arduino LLC. All right reserved.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cpu-mcu-bridge
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://downloads.arduino.cc/
#PKG_MD5SUM:=58133f3bb176ca54cfab7432fe22517c

include $(INCLUDE_DIR)/package.mk

define Package/cpu-mcu-bridge
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=CPU-MCU Bridge
  DEPENDS:=+python-mini
endef

define Package/cpu-mcu-bridge/description
 Bridge lets linux and arduino communicate
endef

define Build/Compile
	# NOOP
endef

define Package/cpu-mcu-bridge/install
	$(INSTALL_DIR) $(1)/usr/lib/python2.7/bridge

	$(RM) $(PKG_BUILD_DIR)/{contextlib,tty}.py*
	$(RM) $(PKG_BUILD_DIR)/termios.so

	$(INSTALL_DATA) $(PKG_BUILD_DIR)/*.py $(1)/usr/lib/python2.7/bridge
endef

$(eval $(call BuildPackage,cpu-mcu-bridge))
