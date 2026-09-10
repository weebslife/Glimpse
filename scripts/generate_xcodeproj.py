#!/usr/bin/env python3
import os
import sys

def main():
    project_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    xcodeproj_dir = os.path.join(project_dir, "Glimpse.xcodeproj")
    os.makedirs(xcodeproj_dir, exist_ok=True)
    pbxproj_path = os.path.join(xcodeproj_dir, "project.pbxproj")

    pbxproj_content = """// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		100000000000000000000001 /* GlimpseApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000001 /* GlimpseApp.swift */; };
		100000000000000000000002 /* CameraState.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000002 /* CameraState.swift */; };
		100000000000000000000003 /* SystemSettings.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000003 /* SystemSettings.swift */; };
		100000000000000000000004 /* CameraManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000004 /* CameraManager.swift */; };
		100000000000000000000005 /* CameraPreview.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000005 /* CameraPreview.swift */; };
		100000000000000000000006 /* CameraErrorView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000006 /* CameraErrorView.swift */; };
		100000000000000000000007 /* MirrorView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000007 /* MirrorView.swift */; };
		100000000000000000000008 /* MirrorWindowController.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000010 /* MirrorWindowController.swift */; };
		100000000000000000000009 /* MirrorSettings.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000011 /* MirrorSettings.swift */; };
		100000000000000000000010 /* EdgeLightView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000012 /* EdgeLightView.swift */; };
		100000000000000000000011 /* MirrorSettingsHUD.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000013 /* MirrorSettingsHUD.swift */; };
		100000000000000000000012 /* FullScreenEdgeLightView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000014 /* FullScreenEdgeLightView.swift */; };
		100000000000000000000013 /* FullScreenEdgeLightController.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000015 /* FullScreenEdgeLightController.swift */; };
		100000000000000000000014 /* UpdateChecker.swift in Sources */ = {isa = PBXBuildFile; fileRef = 200000000000000000000016 /* UpdateChecker.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		000000000000000000000001 /* Glimpse.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = Glimpse.app; sourceTree = BUILT_PRODUCTS_DIR; };
		200000000000000000000001 /* GlimpseApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = GlimpseApp.swift; sourceTree = "<group>"; };
		200000000000000000000002 /* CameraState.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CameraState.swift; sourceTree = "<group>"; };
		200000000000000000000003 /* SystemSettings.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SystemSettings.swift; sourceTree = "<group>"; };
		200000000000000000000004 /* CameraManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CameraManager.swift; sourceTree = "<group>"; };
		200000000000000000000005 /* CameraPreview.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CameraPreview.swift; sourceTree = "<group>"; };
		200000000000000000000006 /* CameraErrorView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CameraErrorView.swift; sourceTree = "<group>"; };
		200000000000000000000007 /* MirrorView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MirrorView.swift; sourceTree = "<group>"; };
		200000000000000000000008 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		200000000000000000000009 /* Glimpse.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = Glimpse.entitlements; sourceTree = "<group>"; };
		200000000000000000000010 /* MirrorWindowController.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MirrorWindowController.swift; sourceTree = "<group>"; };
		200000000000000000000011 /* MirrorSettings.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MirrorSettings.swift; sourceTree = "<group>"; };
		200000000000000000000012 /* EdgeLightView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = EdgeLightView.swift; sourceTree = "<group>"; };
		200000000000000000000013 /* MirrorSettingsHUD.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MirrorSettingsHUD.swift; sourceTree = "<group>"; };
		200000000000000000000014 /* FullScreenEdgeLightView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FullScreenEdgeLightView.swift; sourceTree = "<group>"; };
		200000000000000000000015 /* FullScreenEdgeLightController.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FullScreenEdgeLightController.swift; sourceTree = "<group>"; };
		200000000000000000000016 /* UpdateChecker.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = UpdateChecker.swift; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		300000000000000000000001 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		400000000000000000000000 /* Main */ = {
			isa = PBXGroup;
			children = (
				400000000000000000000001 /* Glimpse */,
				400000000000000000000006 /* Products */,
			);
			sourceTree = "<group>";
		};
		400000000000000000000001 /* Glimpse */ = {
			isa = PBXGroup;
			children = (
				200000000000000000000001 /* GlimpseApp.swift */,
				400000000000000000000002 /* Models */,
				400000000000000000000003 /* Camera */,
				400000000000000000000004 /* Views */,
				400000000000000000000005 /* Utilities */,
				400000000000000000000007 /* Window */,
				200000000000000000000008 /* Info.plist */,
				200000000000000000000009 /* Glimpse.entitlements */,
			);
			path = Glimpse;
			sourceTree = "<group>";
		};
		400000000000000000000002 /* Models */ = {
			isa = PBXGroup;
			children = (
				200000000000000000000002 /* CameraState.swift */,
				200000000000000000000011 /* MirrorSettings.swift */,
			);
			path = Models;
			sourceTree = "<group>";
		};
		400000000000000000000003 /* Camera */ = {
			isa = PBXGroup;
			children = (
				200000000000000000000004 /* CameraManager.swift */,
				200000000000000000000005 /* CameraPreview.swift */,
			);
			path = Camera;
			sourceTree = "<group>";
		};
		400000000000000000000004 /* Views */ = {
			isa = PBXGroup;
			children = (
				200000000000000000000006 /* CameraErrorView.swift */,
				200000000000000000000007 /* MirrorView.swift */,
				200000000000000000000012 /* EdgeLightView.swift */,
				200000000000000000000013 /* MirrorSettingsHUD.swift */,
				200000000000000000000014 /* FullScreenEdgeLightView.swift */,
			);
			path = Views;
			sourceTree = "<group>";
		};
		400000000000000000000005 /* Utilities */ = {
			isa = PBXGroup;
			children = (
				200000000000000000000003 /* SystemSettings.swift */,
				200000000000000000000016 /* UpdateChecker.swift */,
			);
			path = Utilities;
			sourceTree = "<group>";
		};
		400000000000000000000007 /* Window */ = {
			isa = PBXGroup;
			children = (
				200000000000000000000010 /* MirrorWindowController.swift */,
				200000000000000000000015 /* FullScreenEdgeLightController.swift */,
			);
			path = Window;
			sourceTree = "<group>";
		};
		400000000000000000000006 /* Products */ = {
			isa = PBXGroup;
			children = (
				000000000000000000000001 /* Glimpse.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		500000000000000000000001 /* Glimpse */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 600000000000000000000001 /* Build configuration list for PBXNativeTarget "Glimpse" */;
			buildPhases = (
				700000000000000000000001 /* Sources */,
				300000000000000000000001 /* Frameworks */,
				800000000000000000000001 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = Glimpse;
			productName = Glimpse;
			productReference = 000000000000000000000001 /* Glimpse.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		900000000000000000000001 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					500000000000000000000001 = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = 600000000000000000000000 /* Build configuration list for PBXProject "Glimpse" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = 400000000000000000000000 /* Main */;
			productRefGroup = 400000000000000000000006 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				500000000000000000000001 /* Glimpse */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		800000000000000000000001 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		700000000000000000000001 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				100000000000000000000001 /* GlimpseApp.swift in Sources */,
				100000000000000000000002 /* CameraState.swift in Sources */,
				100000000000000000000003 /* SystemSettings.swift in Sources */,
				100000000000000000000004 /* CameraManager.swift in Sources */,
				100000000000000000000005 /* CameraPreview.swift in Sources */,
				100000000000000000000006 /* CameraErrorView.swift in Sources */,
				100000000000000000000007 /* MirrorView.swift in Sources */,
				100000000000000000000008 /* MirrorWindowController.swift in Sources */,
				100000000000000000000009 /* MirrorSettings.swift in Sources */,
				100000000000000000000010 /* EdgeLightView.swift in Sources */,
				100000000000000000000011 /* MirrorSettingsHUD.swift in Sources */,
				100000000000000000000012 /* FullScreenEdgeLightView.swift in Sources */,
				100000000000000000000013 /* FullScreenEdgeLightController.swift in Sources */,
				100000000000000000000014 /* UpdateChecker.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		A00000000000000000000001 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				MACOSX_DEPLOYMENT_TARGET = 13.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = macosx;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		A00000000000000000000002 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				MACOSX_DEPLOYMENT_TARGET = 13.0;
				MTL_FAST_MATH = YES;
				SDKROOT = macosx;
				SWIFT_COMPILATION_MODE = "wholemodule";
				SWIFT_OPTIMIZATION_LEVEL = "-O";
			};
			name = Release;
		};
		A00000000000000000000003 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_ENTITLEMENTS = Glimpse/Glimpse.entitlements;
				CODE_SIGN_IDENTITY = "-";
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_HARDENED_RUNTIME = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Glimpse/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0.0;
				OTHER_CODE_SIGN_FLAGS = "--requirements '=designated => identifier \\\"com.adinshobirin.glimpse\\\"'";
				PRODUCT_BUNDLE_IDENTIFIER = com.adinshobirin.glimpse;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Debug;
		};
		A00000000000000000000004 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_ENTITLEMENTS = Glimpse/Glimpse.entitlements;
				CODE_SIGN_IDENTITY = "-";
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_HARDENED_RUNTIME = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Glimpse/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0.0;
				OTHER_CODE_SIGN_FLAGS = "--requirements '=designated => identifier \\\"com.adinshobirin.glimpse\\\"'";
				PRODUCT_BUNDLE_IDENTIFIER = com.adinshobirin.glimpse;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		600000000000000000000000 /* Build configuration list for PBXProject "Glimpse" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A00000000000000000000001 /* Debug */,
				A00000000000000000000002 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		600000000000000000000001 /* Build configuration list for PBXNativeTarget "Glimpse" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A00000000000000000000003 /* Debug */,
				A00000000000000000000004 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = 900000000000000000000001 /* Project object */;
}
"""
    with open(pbxproj_path, "w") as f:
        f.write(pbxproj_content)
    print(f"Generated {pbxproj_path}")

if __name__ == "__main__":
    main()
