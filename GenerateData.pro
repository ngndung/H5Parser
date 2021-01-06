TARGET = ReadH5
QT += quick

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        generatedata.cpp \
        main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    generatedata.h

INCLUDEPATH += $$PWD/3rdparty/include

# Copies the given files to the destination directory
defineTest(copyToDestDir) {
    files = $$1
    dir = $$2
    # replace slashes in destination path for Windows
    win32:dir ~= s,/,\\,g

    # check if the directory not exist => create directory
    !exists($$dir) {
        QMAKE_POST_LINK += $$QMAKE_MKDIR $$dir $$escape_expand(\\n\\t)
    }

    for(file, files) {
        # replace slashes in source path for Windows
        win32:file ~= s,/,\\,g
        QMAKE_POST_LINK += $$QMAKE_COPY_DIR $$file $$dir $$escape_expand(\\n\\t)
    }

    export(QMAKE_POST_LINK)
}

CONFIG(debug, debug|release): {
    BUILD_DIR = $${PWD}/../$${TARGET}/debug
}

CONFIG(release, debug|release): {
    BUILD_DIR = $${PWD}/../$${TARGET}/release
}

windows {
    TARGET_BUILD = x64
    !contains(QMAKE_TARGET.arch, x86_64) {
        message("x86 build")
        TARGET_BUILD = x86
    }

    LIBS += -L$$PWD/3rdparty/lib/$$TARGET_BUILD -lTofDaqDll \
            -L$$PWD/3rdparty/lib/$$TARGET_BUILD -lTwH5Dll \
            -L$$PWD/3rdparty/lib/$$TARGET_BUILD -lTwToolDll
    DEFINES += QT_DLL

    DESTDIR = $${BUILD_DIR}/windows

    H5_FILES += $$PWD/example.h5
    copyToDestDir($$H5_FILES, $$DESTDIR)
}
