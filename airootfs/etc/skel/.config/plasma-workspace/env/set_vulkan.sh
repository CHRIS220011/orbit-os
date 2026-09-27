#!/bin/sh
# ORBIT-OS: Prefer Vulkan for Qt Quick rendering
# Fallback to OpenGL if Vulkan is not available
export QSG_RHI_BACKEND=vulkan
