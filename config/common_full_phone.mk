# Inherit full common stuff
$(call inherit-product, vendor/x86/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Lineage LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/x86/overlay/dictionaries

$(call inherit-product, vendor/x86/config/telephony.mk)
