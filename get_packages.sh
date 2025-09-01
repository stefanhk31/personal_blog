#!/bin/bash

# Get packages script - runs dart pub get for all packages in the packages directory

echo "🚀 Starting to fetch dependencies for all packages..."
echo ""

# Store the root directory
ROOT_DIR=$(pwd)

# Check if packages directory exists
if [ ! -d "packages" ]; then
    echo "❌ Error: packages directory not found!"
    echo "Please run this script from the root of your project."
    exit 1
fi

# Counter for tracking progress
PACKAGE_COUNT=0
SUCCESS_COUNT=0
FAILED_PACKAGES=()

# Iterate through all directories in packages/
for package_dir in packages/*/; do
    # Skip if not a directory
    if [ ! -d "$package_dir" ]; then
        continue
    fi

    # Get package name from directory path
    package_name=$(basename "$package_dir")

    # Skip if no pubspec.yaml exists
    if [ ! -f "$package_dir/pubspec.yaml" ]; then
        echo "⚠️  Skipping $package_name (no pubspec.yaml found)"
        continue
    fi

    PACKAGE_COUNT=$((PACKAGE_COUNT + 1))

    echo "📦 Fetching dependencies for: $package_name"

    # Change to package directory
    cd "$package_dir" || {
        echo "❌ Failed to enter directory: $package_name"
        FAILED_PACKAGES+=("$package_name")
        cd "$ROOT_DIR"
        continue
    }

    # Run dart pub get
    if dart pub get; then
        echo "✅ Successfully fetched dependencies for: $package_name"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo "❌ Failed to fetch dependencies for: $package_name"
        FAILED_PACKAGES+=("$package_name")
    fi

    # Return to root directory
    cd "$ROOT_DIR"
    echo ""
done

# Summary
echo "🎉 Package dependency fetch complete!"
echo "📊 Summary:"
echo "   • Total packages processed: $PACKAGE_COUNT"
echo "   • Successful: $SUCCESS_COUNT"
echo "   • Failed: ${#FAILED_PACKAGES[@]}"

if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
    echo ""
    echo "❌ Failed packages:"
    for failed_package in "${FAILED_PACKAGES[@]}"; do
        echo "   • $failed_package"
    done
    exit 1
fi

echo ""
echo "✨ All package dependencies have been successfully fetched!"
