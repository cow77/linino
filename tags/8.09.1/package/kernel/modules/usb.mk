#
# Copyright (C) 2006-2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id$

USB_MENU:=USB Support

ifeq ($(KERNEL),2.4)
  USBNET_DIR:=usb/net
endif

ifeq ($(KERNEL_PATCHVER),2.6.21)
  USBNET_DIR:=usb/net
  USBHID_DIR:=usb/input
  USBINPUT_DIR:=usb/input
endif

USBNET_DIR?=net/usb
USBHID_DIR?=hid/usbhid
USBINPUT_DIR?=input/misc

define usbdep
  SUBMENU:=$(USB_MENU)
  DEPENDS:=kmod-usb-core $(1)
endef


define KernelPackage/usb-core
  SUBMENU:=$(USB_MENU)
  TITLE:=Support for USB
  DEPENDS:=@USB_SUPPORT
  KCONFIG:=CONFIG_USB
  AUTOLOAD:=$(call AutoLoad,20,usbcore)
endef

define KernelPackage/usb-core/2.4
  FILES:=$(LINUX_DIR)/drivers/usb/usbcore.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/usb-core/2.6
  FILES:=$(LINUX_DIR)/drivers/usb/core/usbcore.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/usb-core/description
 Kernel support for USB
endef

$(eval $(call KernelPackage,usb-core))


define KernelPackage/usb-uhci
  $(call usbdep,)
  TITLE:=Support for UHCI controllers
  KCONFIG:= \
	CONFIG_USB_UHCI_ALT \
	CONFIG_USB_UHCI_HCD
endef

define KernelPackage/usb-uhci/2.4
#  KCONFIG:=CONFIG_USB_UHCI_ALT
  FILES:=$(LINUX_DIR)/drivers/usb/host/uhci.o
  AUTOLOAD:=$(call AutoLoad,50,uhci)
endef

define KernelPackage/usb-uhci/2.6
#  KCONFIG:=CONFIG_USB_UHCI_HCD
  FILES:=$(LINUX_DIR)/drivers/usb/host/uhci-hcd.ko
  AUTOLOAD:=$(call AutoLoad,50,uhci-hcd)
endef

define KernelPackage/usb-uhci/description
 Kernel support for USB UHCI controllers
endef

$(eval $(call KernelPackage,usb-uhci))


define KernelPackage/usb-uhci-iv
  $(call usbdep,@LINUX_2_4)
  TITLE:=Support for Intel/VIA UHCI controllers
  KCONFIG:=CONFIG_USB_UHCI
  FILES:=$(LINUX_DIR)/drivers/usb/host/usb-uhci.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,usb-uhci)
endef

define KernelPackage/usb-uhci-iv/description
 Kernel support for Intel/VIA USB UHCI controllers
endef

$(eval $(call KernelPackage,usb-uhci-iv))


define KernelPackage/usb-ohci
  $(call usbdep,)
  TITLE:=Support for OHCI controllers
  KCONFIG:= \
	CONFIG_USB_OHCI \
	CONFIG_USB_OHCI_HCD
endef

define KernelPackage/usb-ohci/2.4
#  KCONFIG:=CONFIG_USB_OHCI
  FILES:=$(LINUX_DIR)/drivers/usb/host/usb-ohci.o
  AUTOLOAD:=$(call AutoLoad,50,usb-ohci)
endef

define KernelPackage/usb-ohci/2.6
#  KCONFIG:=CONFIG_USB_OHCI_HCD
  FILES:=$(LINUX_DIR)/drivers/usb/host/ohci-hcd.ko
  AUTOLOAD:=$(call AutoLoad,50,ohci-hcd)
endef

define KernelPackage/usb-ohci/description
 Kernel support for USB OHCI controllers
endef

$(eval $(call KernelPackage,usb-ohci))


define KernelPackage/usb-adm5120
  $(call usbdep,@TARGET_adm5120_router_be||@TARGET_adm5120_router_le)
  TITLE:=Support for the ADM5120 HCD controller
  KCONFIG:=CONFIG_USB_ADM5120_HCD
  FILES:=$(LINUX_DIR)/drivers/usb/host/adm5120-hcd.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,adm5120-hcd)
endef

define KernelPackage/usb-adm5120/description
 Kernel support for the ADM5120 HCD USB controller
endef

$(eval $(call KernelPackage,usb-adm5120))


define KernelPackage/usb2
  $(call usbdep,)
  TITLE:=Support for USB2 controllers
  KCONFIG:=CONFIG_USB_EHCI_HCD
  FILES:=$(LINUX_DIR)/drivers/usb/host/ehci-hcd.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,ehci-hcd)
endef

define KernelPackage/usb2/description
 Kernel support for USB2 (EHCI) controllers
endef

$(eval $(call KernelPackage,usb2))


define KernelPackage/usb-acm
  $(call usbdep,)
  TITLE:=Support for modems/isdn controllers
  KCONFIG:=CONFIG_USB_ACM
endef

define KernelPackage/usb-acm/2.4
  FILES:=$(LINUX_DIR)/drivers/usb/acm.o
  AUTOLOAD:=$(call AutoLoad,60,acm)
endef

define KernelPackage/usb-acm/2.6
  FILES:=$(LINUX_DIR)/drivers/usb/class/cdc-acm.ko
  AUTOLOAD:=$(call AutoLoad,60,cdc-acm)
endef

define KernelPackage/usb-acm/description
 Kernel support for USB ACM devices (modems/isdn controllers)
endef

$(eval $(call KernelPackage,usb-acm))


define KernelPackage/usb-audio
  $(call usbdep,+kmod-sound-core)
  TITLE:=Support for USB audio devices
  KCONFIG:= \
	CONFIG_USB_AUDIO \
	CONFIG_SND_USB_AUDIO
endef

define KernelPackage/usb-audio/2.4
#  KCONFIG:=CONFIG_USB_AUDIO
  FILES:=$(LINUX_DIR)/drivers/usb/audio.o
  AUTOLOAD:=$(call AutoLoad,60,audio)
endef

define KernelPackage/usb-audio/2.6
#  KCONFIG:=CONFIG_SND_USB_AUDIO
  FILES:= \
	$(LINUX_DIR)/sound/usb/snd-usb-lib.ko \
	$(LINUX_DIR)/sound/usb/snd-usb-audio.ko
  AUTOLOAD:=$(call AutoLoad,60,snd-usb-lib snd-usb-audio)
endef

define KernelPackage/usb-audio/description
 Kernel support for USB audio devices
endef

$(eval $(call KernelPackage,usb-audio))


define KernelPackage/usb-printer
  $(call usbdep,)
  TITLE:=Support for printers
  KCONFIG:=CONFIG_USB_PRINTER
endef

define KernelPackage/usb-printer/2.4
  FILES:=$(LINUX_DIR)/drivers/usb/printer.o
  AUTOLOAD:=$(call AutoLoad,60,printer)
endef

define KernelPackage/usb-printer/2.6
  FILES:=$(LINUX_DIR)/drivers/usb/class/usblp.ko
  AUTOLOAD:=$(call AutoLoad,60,usblp)
endef

define KernelPackage/usb-printer/description
 Kernel support for USB printers
endef

$(eval $(call KernelPackage,usb-printer))


define KernelPackage/usb-serial
  $(call usbdep,)
  TITLE:=Support for USB-to-Serial converters
  KCONFIG:=CONFIG_USB_SERIAL
  FILES:=$(LINUX_DIR)/drivers/usb/serial/usbserial.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,usbserial)
endef

define KernelPackage/usb-serial/description
 Kernel support for USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial))


define KernelPackage/usb-serial-airprime
  $(call usbdep,kmod-usb-serial @LINUX_2_6)
  TITLE:=Support for Airprime (EVDO)
  KCONFIG:=CONFIG_USB_SERIAL_AIRPRIME
  FILES:=$(LINUX_DIR)/drivers/usb/serial/airprime.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,airprime)
endef

define KernelPackage/usb-serial-airprime/description
 Kernel support for Airprime (EVDO)
endef

$(eval $(call KernelPackage,usb-serial-airprime))


define KernelPackage/usb-serial-belkin
  $(call usbdep,kmod-usb-serial)
  TITLE:=Support for Belkin devices
  KCONFIG:=CONFIG_USB_SERIAL_BELKIN
  FILES:=$(LINUX_DIR)/drivers/usb/serial/belkin_sa.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,belkin_sa)
endef

define KernelPackage/usb-serial-belkin/description
 Kernel support for Belkin USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-belkin))


define KernelPackage/usb-serial-ch341
  $(call usbdep,kmod-usb-serial @LINUX_2_6&&@!LINUX_2_6_23)
  TITLE:=Support for CH341 devices
  KCONFIG:=CONFIG_USB_SERIAL_CH341
  FILES:=$(LINUX_DIR)/drivers/usb/serial/ch341.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,ch341)
endef

define KernelPackage/usb-serial-belkin/description
 Kernel support for Winchiphead CH341 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-ch341))


define KernelPackage/usb-serial-ftdi
  $(call usbdep,kmod-usb-serial)
  TITLE:=Support for FTDI devices
  KCONFIG:=CONFIG_USB_SERIAL_FTDI_SIO
  FILES:=$(LINUX_DIR)/drivers/usb/serial/ftdi_sio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,ftdi_sio)
endef

define KernelPackage/usb-serial-ftdi/description
 Kernel support for FTDI USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-ftdi))


define KernelPackage/usb-serial-mct
  $(call usbdep,kmod-usb-serial)
  TITLE:=Support for Magic Control Tech. devices
  KCONFIG:=CONFIG_USB_SERIAL_MCT_U232
  FILES:=$(LINUX_DIR)/drivers/usb/serial/mct_u232.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,mct_u232)
endef

define KernelPackage/usb-serial-mct/description
 Kernel support for Magic Control Technology USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-mct))


define KernelPackage/usb-serial-pl2303
  $(call usbdep,kmod-usb-serial)
  TITLE:=Support for Prolific PL2303 devices
  KCONFIG:=CONFIG_USB_SERIAL_PL2303
  FILES:=$(LINUX_DIR)/drivers/usb/serial/pl2303.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,pl2303)
endef

define KernelPackage/usb-serial-pl2303/description
 Kernel support for Prolific PL2303 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-pl2303))


define KernelPackage/usb-serial-cp2101
  $(call usbdep,kmod-usb-serial)
  TITLE:=Support for Silicon Labs cp2101 devices
  KCONFIG:=CONFIG_USB_SERIAL_CP2101
  FILES:=$(LINUX_DIR)/drivers/usb/serial/cp2101.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,cp2101)
endef

define KernelPackage/usb-serial-cp2101/description
 Kernel support for Silicon Labs cp2101 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-cp2101))


define KernelPackage/usb-serial-ark3116
  $(call usbdep,kmod-usb-serial @LINUX_2_6)
  TITLE:=Support for ArkMicroChips ARK3116 devices
  KCONFIG:=CONFIG_USB_SERIAL_ARK3116
  FILES:=$(LINUX_DIR)/drivers/usb/serial/ark3116.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,ark3116)
endef

define KernelPackage/usb-serial-ark3116/description
 Kernel support for ArkMicroChips ARK3116 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-ark3116))


define KernelPackage/usb-serial-oti6858
  $(call usbdep,kmod-usb-serial @LINUX_2_6)
  TITLE:=Support for Ours Technology OTI6858 devices
  KCONFIG:=CONFIG_USB_SERIAL_OTI6858
  FILES:=$(LINUX_DIR)/drivers/usb/serial/oti6858.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,oti6858)
endef

define KernelPackage/usb-serial-oti6858/description
 Kernel support for Ours Technology OTI6858 USB-to-Serial converters
endef

$(eval $(call KernelPackage,usb-serial-oti6858))


define KernelPackage/usb-serial-sierrawireless
  $(call usbdep,kmod-usb-serial)
  TITLE:=Support for Sierra Wireless devices
  KCONFIG:=CONFIG_USB_SERIAL_SIERRAWIRELESS
  FILES:=$(LINUX_DIR)/drivers/usb/serial/sierra.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,sierra)
endef

define KernelPackage/usb-serial-sierrawireless/description
 Kernel support for Sierra Wireless devices
endef

$(eval $(call KernelPackage,usb-serial-sierrawireless))


define KernelPackage/usb-serial-visor
  $(call usbdep,kmod-usb-serial)
  TITLE:=Support for Handspring Visor devices
  KCONFIG:=CONFIG_USB_SERIAL_VISOR
  FILES:=$(LINUX_DIR)/drivers/usb/serial/visor.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,visor)
endef

define KernelPackage/usb-serial-visor/description
 Kernel support for Handspring Visor PDAs
endef

$(eval $(call KernelPackage,usb-serial-visor))


define KernelPackage/usb-serial-keyspan
  $(call usbdep,kmod-usb-serial)
  TITLE:=Support for Keyspan USB-to-Serial devices
  KCONFIG:= \
	CONFIG_USB_SERIAL_KEYSPAN \
	CONFIG_USB_SERIAL_KEYSPAN_USA28 \
	CONFIG_USB_SERIAL_KEYSPAN_USA28X \
	CONFIG_USB_SERIAL_KEYSPAN_USA28XA \
	CONFIG_USB_SERIAL_KEYSPAN_USA28XB \
	CONFIG_USB_SERIAL_KEYSPAN_USA19 \
	CONFIG_USB_SERIAL_KEYSPAN_USA18X \
	CONFIG_USB_SERIAL_KEYSPAN_USA19W \
	CONFIG_USB_SERIAL_KEYSPAN_USA19QW \
	CONFIG_USB_SERIAL_KEYSPAN_USA19QI \
	CONFIG_USB_SERIAL_KEYSPAN_MPR \
	CONFIG_USB_SERIAL_KEYSPAN_USA49W \
	CONFIG_USB_SERIAL_KEYSPAN_USA49WLC
  FILES:=$(LINUX_DIR)/drivers/usb/serial/keyspan.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,keyspan)
endef

define KernelPackage/usb-serial-keyspan/description
 Kernel support for Keyspan USB-to-Serial devices
endef

$(eval $(call KernelPackage,usb-serial-keyspan))


define KernelPackage/usb-serial-option
  $(call usbdep,kmod-usb-serial @LINUX_2_6)
  TITLE:=Support for Option HSDPA modems
  KCONFIG:=CONFIG_USB_SERIAL_OPTION
  FILES:=$(LINUX_DIR)/drivers/usb/serial/option.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,option)
endef

define KernelPackage/usb-serial-option/description
 Kernel support for Option HSDPA modems
endef

$(eval $(call KernelPackage,usb-serial-option))


define KernelPackage/usb-storage
  $(call usbdep,+kmod-scsi-core)
  TITLE:=USB Storage support
  KCONFIG:=CONFIG_USB_STORAGE
  FILES:=$(LINUX_DIR)/drivers/usb/storage/usb-storage.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,scsi_mod sd_mod usb-storage)
endef

define KernelPackage/usb-storage/description
 Kernel support for USB Mass Storage devices
endef

$(eval $(call KernelPackage,usb-storage))


define KernelPackage/usb-video
  $(call usbdep,@LINUX_2_6)
  TITLE:=Support for USB video devices
  KCONFIG:=CONFIG_VIDEO_USBVIDEO
  FILES:=$(LINUX_DIR)/drivers/media/video/usbvideo/usbvideo.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,usbvideo)
endef

define KernelPackage/usb-video/description
 Kernel support for USB video devices
endef

$(eval $(call KernelPackage,usb-video))


define KernelPackage/usb-atm
  $(call usbdep,@LINUX_2_6 +kmod-atm)
  TITLE:=Support for ATM on USB bus
  KCONFIG:=CONFIG_USB_ATM
  FILES:=$(LINUX_DIR)/drivers/usb/atm/usbatm.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,usbatm)
endef

define KernelPackage/usb-atm/description
 Kernel support for USB DSL modems
endef

$(eval $(call KernelPackage,usb-atm))


define KernelPackage/usb-atm-speedtouch
  $(call usbdep,kmod-usb-atm @LINUX_2_6)
  TITLE:=SpeedTouch USB ADSL modems support
  KCONFIG:=CONFIG_USB_SPEEDTOUCH
  FILES:=$(LINUX_DIR)/drivers/usb/atm/speedtch.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,70,speedtch)
endef

define KernelPackage/usb-atm-speedtouch/description
 Kernel support for SpeedTouch USB ADSL modems
endef

$(eval $(call KernelPackage,usb-atm-speedtouch))


define KernelPackage/usb-atm-ueagle
  $(call usbdep,kmod-usb-atm @LINUX_2_6)
  TITLE:=Eagle 8051 based USB ADSL modems support
  FILES:=$(LINUX_DIR)/drivers/usb/atm/ueagle-atm.$(LINUX_KMOD_SUFFIX)
  KCONFIG:=CONFIG_USB_UEAGLEATM
  AUTOLOAD:=$(call AutoLoad,70,ueagle-atm)
endef

define KernelPackage/usb-atm-ueagle/description
 Kernel support for Eagle 8051 based USB ADSL modems
endef

$(eval $(call KernelPackage,usb-atm-ueagle))

define KernelPackage/usb-atm-cxacru
  $(call usbdep,kmod-usb-atm @LINUX_2_6)
  TITLE:=cxacru
  FILES:=$(LINUX_DIR)/drivers/usb/atm/cxacru.$(LINUX_KMOD_SUFFIX)
  KCONFIG:=CONFIG_USB_CXACRU
  AUTOLOAD:=$(call AutoLoad,70,cxacru)
endef

define KernelPackage/usb-atm-cxacru/description
 Kernel support for cxacru based USB ADSL modems
endef

$(eval $(call KernelPackage,usb-atm-cxacru))


define KernelPackage/usb-net
  $(call usbdep,)
  TITLE:=Kernel modules for USB-to-Ethernet convertors
  KCONFIG:=CONFIG_USB_USBNET
  AUTOLOAD:=$(call AutoLoad,60,usbnet)
endef

define KernelPackage/usb-net/2.4
  FILES:=$(LINUX_DIR)/drivers/usb/usbnet.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/usb-net/2.6
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/usbnet.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/usb-net/description
 Kernel modules for USB-to-Ethernet convertors
endef

$(eval $(call KernelPackage,usb-net))


define KernelPackage/usb-net-asix
  $(call usbdep,kmod-usb-net @LINUX_2_6)
  TITLE:=Kernel module for USB-to-Ethernet Asix convertors
  KCONFIG:=CONFIG_USB_NET_AX8817X
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/asix.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,61,asix)
endef

define KernelPackage/usb-net-asix/description
 Kernel module for USB-to-Ethernet Asix convertors
endef

$(eval $(call KernelPackage,usb-net-asix))


define KernelPackage/usb-net-hso
  $(call usbdep,kmod-usb-net @LINUX_2_6_26)
  TITLE:=Kernel module for Option USB High Speed Mobile Devices
  KCONFIG:= \
	CONFIG_RFKILL \
	CONFIG_RFKILL_INPUT \
	CONFIG_USB_HSO
  FILES:= \
	$(LINUX_DIR)/net/rfkill/rfkill.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/$(USBNET_DIR)/hso.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,61,rfkill hso)
endef

define KernelPackage/usb-net-hso/description
 Kernel module for Option USB High Speed Mobile Devices
endef

$(eval $(call KernelPackage,usb-net-hso))


define KernelPackage/usb-net-kaweth
  $(call usbdep,kmod-usb-net @LINUX_2_6)
  TITLE:=Kernel module for USB-to-Ethernet Kaweth convertors
  KCONFIG:=CONFIG_USB_KAWETH
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/kaweth.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,61,kaweth)
endef

define KernelPackage/usb-net-kaweth/description
 Kernel module for USB-to-Ethernet Kaweth convertors
endef

$(eval $(call KernelPackage,usb-net-kaweth))


define KernelPackage/usb-net-pegasus
  $(call usbdep,kmod-usb-net @LINUX_2_6)
  TITLE:=Kernel module for USB-to-Ethernet Pegasus convertors
  KCONFIG:=CONFIG_USB_PEGASUS
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/pegasus.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,61,pegasus)
endef

define KernelPackage/usb-net-pegasus/description
 Kernel module for USB-to-Ethernet Pegasus convertors
endef

$(eval $(call KernelPackage,usb-net-pegasus))


define KernelPackage/usb-net-cdc-ether
  $(call usbdep,kmod-usb-net @LINUX_2_6)
  TITLE:=Support for cdc ethernet connections
  KCONFIG:=CONFIG_USB_NET_CDCETHER
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/cdc_ether.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,61,cdc_ether)
endef

define KernelPackage/usb-net-cdc-ether/description
 Kernel support for USB CDC Ethernet devices
endef

$(eval $(call KernelPackage,usb-net-cdc-ether))


define KernelPackage/usb-hid
  $(call usbdep,@LINUX_2_6 +kmod-input-core +kmod-input-evdev +kmod-hid)
  TITLE:=Support for USB Human Input Devices
  KCONFIG:=CONFIG_HID_SUPPORT=y CONFIG_USB_HID
  FILES:=$(LINUX_DIR)/drivers/$(USBHID_DIR)/usbhid.ko
  AUTOLOAD:=$(call AutoLoad,70,usbhid)
endef


define KernelPackage/usb-hid/description
 Kernel support for USB HID devices such as keyboards and mice
endef

$(eval $(call KernelPackage,usb-hid))


define KernelPackage/usb-yealink
  $(call usbdep,@LINUX_2_6 +kmod-input-core +kmod-input-evdev)
  TITLE:=USB Yealink VOIP phone
  KCONFIG:=CONFIG_USB_YEALINK CONFIG_INPUT_YEALINK CONFIG_INPUT=m CONFIG_INPUT_MISC=y
  FILES:=$(LINUX_DIR)/drivers/$(USBINPUT_DIR)/yealink.ko
  AUTOLOAD:=$(call AutoLoad,70,yealink)
endef

define KernelPackage/usb-yealink/description
 Kernel support for Yealink VOIP phone
endef

$(eval $(call KernelPackage,usb-yealink))

define KernelPackage/usb-test
  $(call usbdep,@LINUX_2_6 @DEVEL)
  TITLE:=USB Testing Driver
  KCONFIG:=CONFIG_USB_TEST
  FILES:=$(LINUX_DIR)/drivers/usb/misc/usbtest.ko
endef

define KernelPackage/usb-test/description
 Kernel support for testing USB Host Controller software.
endef

$(eval $(call KernelPackage,usb-test))

