#!/bin/sh

BUNDLE_DIR=$(dirname $0)

if [ $BUNDLE_DIR = '.' ]
then
BUNDLE_DIR=$(dirname `pwd`)
else
BUNDLE_DIR=$(dirname $BUNDLE_DIR)
fi

SANDBOX_DIR="$HOME/Library/Application Support/PADrend"
RESOURCES_DIR="$BUNDLE_DIR/Resources"

if [ ! -e "$SANDBOX_DIR" ]; then
        mkdir -p "$SANDBOX_DIR"
        if [ $? -ne 0 ] ; then
                echo "Workspace directory: $SANDBOX_DIR"
        else
                echo "created: $SANDBOX_DIR"
                cp -R "$RESOURCES_DIR/bin/extPlugins" "$SANDBOX_DIR"
                cp -R "$RESOURCES_DIR/bin/plugins" "$SANDBOX_DIR"
                cp -R "$RESOURCES_DIR/bin/resources" "$SANDBOX_DIR"
        fi
fi

export "DYLD_LIBRARY_PATH=/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Resources:$RESOURCES_DIR/lib"
cd "$SANDBOX_DIR"

exec "$RESOURCES_DIR/bin/PADrend" "--script=$SANDBOX_DIR/plugins/main.escript"

