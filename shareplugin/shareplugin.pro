TEMPLATE = app
TARGET = shareplugin

load(ubuntu-click)

QT += qml quick dbus bluetooth

SOURCES += main.cpp \
#    adapter.cpp \
#    obexd.cpp \
    obexagent.cpp \
    obexagentadaptor.cpp \
#    transfer.cpp
    bttransfer.cpp

RESOURCES += shareplugin.qrc

OTHER_FILES += shareplugin.apparmor \
               shareplugin.desktop \
               shareplugin.png \
               bluetooth-contenthub.json

#specify where the config files are installed to
config_files.path = /shareplugin
config_files.files += $${OTHER_FILES}
message($$config_files.files)
INSTALLS+=config_files

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

HEADERS += \
#    adapter.h \
#    obexd.h \
    obexagent.h \
    obexagentadaptor.h \
#    transfer.h
    bttransfer.h

