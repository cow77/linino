# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile 6582 2007-03-16 20:21:39Z nbd $

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=zd1211
PKG_VERSION:=r85
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-driver-$(PKG_VERSION).tgz
PKG_SOURCE_URL:=@openwrt/
PKG_MD5SUM:=885cf08742c95cc416258257b5842b22

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-driver-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

#FIXME: add proper dependency handling on kmod-usb-core packages
define KernelPackage/zd1211
  SUBMENU:=Wireless Drivers
  DEPENDS:=@LINUX_2_6&&!LINUX_2_6_UML
  TITLE:=Driver for Zydas 1211 based USB devices
  DESCRIPTION:=\
	This package contains a Linux driver for the ZyDAS ZD1211 802.11b/g \\\
	USB-WLAN-Chip.\\\
	Initially contributed by ZyDAS, this driver is actively maintained by the \\\
	open source community.
  VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
  FILES:=$(PKG_BUILD_DIR)/zd1211.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,zd1211) 
endef

define Package/zd1211-utils
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=zd1211 user-space utilities
  DESCRIPTION:=zd1211 user-space utilities : apdbg, zd1211-sta
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		CC="$(TARGET_CC)" \
		CPP="$(TARGET_CC)" \
		LD="$(TARGET_CROSS)ld" \
		KERNELVERSION="$(KERNEL)" \
		KERNEL_SOURCE="$(LINUX_DIR)" \
		KDIR="$(LINUX_DIR)" \
		all
	$(TARGET_CC) $(PKG_BUILD_DIR)/apdbg.c -o $(PKG_BUILD_DIR)/apdbg
endef

define Package/zd1211-utils/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/apdbg $(1)/usr/sbin/
	$(CP) $(PKG_BUILD_DIR)/sta $(1)/usr/sbin/$(PKG_NAME)-sta
endef

$(eval $(call Package,zd1211-utils))
$(eval $(call KernelPackage,zd1211))
