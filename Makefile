# SPDX-License-Identifier: MIT
#
# Copyright (C) 2025 Anya Lin <hukk1996@gmail.com>

include $(TOPDIR)/rules.mk

PKG_NAME:=iusebash
PKG_VERSION:=0.2025.12.20
PKG_RELEASE:=1

PKG_MAINTAINER:=Anya Lin <hukk1996@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Use bash as the default terminal
	URL:=https://github.com/muink/openwrt-iusebash
	DEPENDS:=+bash
	PKGARCH:=all
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(CURDIR)/files/iusebash.init $(1)/etc/init.d/iusebash
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
sed -i 's|/bin/ash|/bin/bash|g' "$$IPKG_INSTROOT/etc/passwd"
if [ -z "$$IPKG_INSTROOT" ]; then
	# system
	rm -f /tmp/.busybox_ash_history 2>/dev/null
	touch /root/.bash_history
	ln -s /root/.bash_history /tmp/.busybox_ash_history
fi
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
sed -i 's|/bin/bash|/bin/ash|g' "$$IPKG_INSTROOT/etc/passwd"
if [ -z "$$IPKG_INSTROOT" ]; then
	# system
	rm -f /tmp/.busybox_ash_history 2>/dev/null
fi
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
