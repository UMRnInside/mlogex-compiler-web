#!/bin/bash
PYODIDE_RELEASE_URL="https://github.com/pyodide/pyodide/releases/download/0.18.0/pyodide-build-0.18.0.tar.bz2"
PYODIDE_LOADER="https://cdn.jsdelivr.net/pyodide/v0.18.0/full/pyodide.js"
PYODIDE_FULL="https://cdn.jsdelivr.net/pyodide/v0.18.0/full/"

MLOG_EXTENDED_WHEEL_URL=$(wget -qO - "https://pypi.org/project/mlog-extended/#files" | grep mlog_extended | grep files.pythonhosted.org | grep whl | awk -F'"' '{print $2}')
MLOG_EXTENDED_LOADER="mlog_extended"
MLOG_EXTENDED_WHEEL_OUTPUT="./dist/mlog_extended-0.1.3-py3-none-any.whl"

features="$@"
echo "Features: ""$features"

mkdir -p dist/
cp -r index* README.md LICENSE js dist/

if [[ $features == *"static-mlog"* ]]; then
    MLOG_EXTENDED_LOADER="./mlog_extended-0.1.3-py3-none-any.whl"
    echo "Downloading mlog_extended..."
    wget -O $MLOG_EXTENDED_WHEEL_OUTPUT $MLOG_EXTENDED_WHEEL_URL
fi

if [[ $features == *"static-pyodide"* ]]; then
    OLD_PYODIDE_LOADER=$PYODIDE_LOADER
    PYODIDE_HINT="./pyodide/"
    PYODIDE_LOADER="./pyodide/pyodide.js"
    sed -i "s|$OLD_PYODIDE_LOADER|$PYODIDE_LOADER|" dist/index.html
    sed -i "s|$OLD_PYODIDE_LOADER|$PYODIDE_LOADER|" dist/index-zh.html

    pushd dist
    echo "Downloading pyodide..."
    wget -O - $PYODIDE_RELEASE_URL -O pyodide.tar.bz2
    echo "Extracting files..."
    if [[ $features == *"full-pyodide"* ]]; then
        tar -xjf pyodide.tar.bz2
    else
        tar -xjf pyodide.tar.bz2 --wildcards "pyodide/pyodide*" "pyodide/micropip*" "pyodide/pyparsing*" "pyodide/packaging*" "pyodide/distutils*"
    fi
    rm pyodide.tar.bz2
    popd
fi

cat > dist/js/config.js << EOF
PYODIDE_FULL_URL = "$PYODIDE_FULL"
MLOG_EXTENDED_INSTALLTION = "$MLOG_EXTENDED_LOADER"
let baseUrl = document.URL.substr(0,document.URL.lastIndexOf('/')) 
if (PYODIDE_FULL_URL.startsWith(".")) {
    PYODIDE_FULL_URL = baseUrl + "/" + PYODIDE_FULL_URL.slice(1)
}
if (MLOG_EXTENDED_INSTALLTION.startsWith(".")) {
    MLOG_EXTENDED_INSTALLTION = baseUrl + "/" + MLOG_EXTENDED_INSTALLTION.slice(1)
}
EOF
