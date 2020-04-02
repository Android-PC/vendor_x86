my_path := $(call my-dir)

LOCAL_PATH := $(my_path)
include $(CLEAR_VARS)

# Inherit common stuff
$(call inherit-product, vendor/x86/config/common.mk)
$(call inherit-product, vendor/x86/config/common_full.mk)
$(call inherit-product, vendor/x86/config/common_full_tablet_wifionly.mk)


# Boot animation
TARGET_SCREEN_HEIGHT := 1080
TARGET_SCREEN_WIDTH := 1080
TARGET_BOOTANIMATION_HALF_RES := true

# If using gms
ifeq ($(USE_GMS),true)
$(call inherit-product, vendor/gms/config.mk)
endif

# If using fdroid
ifeq ($(USE_FDROID),true)
$(call inherit-product-if-exists, vendor/foss/foss.mk)
# Get GMS
$(call inherit-product-if-exists,vendor/microg/microg.mk)
# FOSS apps
PRODUCT_PACKAGES += \
	FDroid \
	FDroidPrivilegedExtension \
	FakeStore \
	Phonesky \
	DroidGuard \
	GmsCore \
	privapp-permissions-com.google.android.gms.xml \
	GsfProxy \
	MozillaNlpBackend \
	NominatimNlpBackend \
	com.google.android.maps \
	com.google.android.maps.jar \
	com.google.android.maps.xml \
	OpenWeatherMapWeatherProvider \
	additional_repos.xml

endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.mot.deep.sleep.supported=true 
    
# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include x86 overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/x86/overlay/

PRODUCT_SHIPPING_API_LEVEL := 19

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:system/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:system/etc/permissions/android.software.picture_in_picture.xml \
    frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.webview.xml:system/etc/permissions/android.software.webview.xml \
    frameworks/native/data/etc/android.hardware.gamepad.xml:system/etc/permissions/android.hardware.gamepad.xml \

# Enable MultiWindow
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.debug.multi_window=true
    persist.sys.debug.desktop_mode=true

# Optional packages
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    PhotoTable \
    Terminal

# Custom x86 packages
PRODUCT_PACKAGES += \
    htop \
    nano 

# We add in gBoard now, so make it override latinIME
GAPPS_EXCLUDED_PACKAGES += \
    LatinIME \
    
# Exchange support
PRODUCT_PACKAGES += \
    Exchange2 \

# !!EXPERIMENTAL!!
# QEMU-based native bridge for Android-x86 - https://github.com/goffioul/ax86-nb-qemu
ifeq ($(USE_X86LIBNB),true)

# Remove packages
PRODUCT_PACKAGES += \
    libnb-qemu \
    libnb-qemu-guest

endif

# Legacy houdini files
define addon-copy-from-system
$(shell python "vendor/x86/copy_files.py" "vendor/x86/$(1)/" "$(2)" "$(PLATFORM_SDK_VERSION)")
endef

define addon-copy-to-system
$(shell python "vendor/x86/copy_files.py" "vendor/google/chromeos-x86/proprietary/$(1)/" "$(2)" "$(PLATFORM_SDK_VERSION)")
endef

# Houdini addons

ifeq ($(USE_PRIV_HOUDINI),true)

$(call inherit-product, vendor/bliss_priv/device-vendor.mk)

endif


# ifeq ($(USE_HOUDINI),true)

# PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.nativebridge=1 
	
# PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.enable.native.bridge.exec=1
	
# Copy files
#PRODUCT_COPY_FILES += $(call addon-copy-from-system,system,bin) 
#PRODUCT_COPY_FILES += $(call addon-copy-from-system,system,lib) 
#PRODUCT_COPY_FILES += $(call addon-copy-to-system,houdini,bin) 
#PRODUCT_COPY_FILES += $(call addon-copy-to-system,houdini,etc) 
#PRODUCT_COPY_FILES += $(call addon-copy-to-system,houdini,lib) 

# endif

# Widevine addons
ifeq ($(USE_WIDEVINE),true)
# Copy files
PRODUCT_COPY_FILES += $(call addon-copy-to-system,widevine,vendor) 

endif

# Bootanimation
PRODUCT_COPY_FILES += \
    vendor/x86/bootanimation/bootanimation.zip:system/media/bootanimation.zip
    
