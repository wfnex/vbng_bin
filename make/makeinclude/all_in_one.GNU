# -*- Makefile -*-
# Only include once.
ifndef ALL_IN_ONE_GNU
ALL_IN_ONE_GNU = 1

# Include wrapper macros to all user defines, etc.
include $(USER_ROOT)/make/makeinclude/wrapper_macros.GNU

ifneq ($(ADDITIONAL_INCLUDE),)
  include $(ADDITIONAL_INCLUDE)
endif

# Now test for installed components, and set the BIN. LIB, and SHLIB
# targets from the *_UNCHECKED ones if the component checks 
# succeed.  Client Makefile must set the variable REQUIRED_COMPONENTS
# with a list of required components.  If no additional components
# are required, REQUIRED_COMPONENTS need not be set.
include $(USER_ROOT)/make/makeinclude/component_check.GNU

# If no required components are missing, set the real targets
ifeq ($(MISSING_COMPONENTS),)
  ifdef BIN_UNCHECKED
    BIN += $(BIN_UNCHECKED)
  endif # !BIN_UNCHECKED
  ifdef static_libs
    ifdef LIB_UNCHECKED
      LIB += $(LIB_UNCHECKED)
    endif # !LIB_UNCHECKED
  endif # static_libs
  ifdef shared_libs
    ifdef SHLIB_UNCHECKED
      SHLIB += $(SHLIB_UNCHECKED)
    endif # !SHLIB_UNCHECKED
  endif # !shared_libs
endif # COMPILE_COMPONENT

include $(USER_ROOT)/make/makeinclude/macros.GNU
include $(USER_ROOT)/make/makeinclude/rules.common.GNU

ifdef DIRS
  include $(USER_ROOT)/make/makeinclude/rules.nested.GNU
else # !DIRS
  include $(USER_ROOT)/make/makeinclude/rules.nonested.GNU
endif # DIRS
ifdef CLEANUP_LIB
  include_lib = 1
endif # LIB

ifdef CLEANUP_SHLIB
  include_lib = 1
endif # SHLIB

ifeq ($(include_lib),1)
  include $(USER_ROOT)/make/makeinclude/rules.lib.GNU
endif

include $(USER_ROOT)/make/makeinclude/rules.local.GNU

# Remove the -g option if requested.
SUPPRESS_DASH_G ?=
ifeq ($(SUPPRESS_DASH_G),1)
  DCFLAGS := $(filter-out -g, $DCFLAGS)
endif

endif # ALL_IN_ONE_GNU
