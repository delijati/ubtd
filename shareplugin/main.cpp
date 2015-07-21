#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>

#include "adapter.h"
#include "bttransfer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

//    Adapter adapter;
//    Obexd obexd;

    QQuickView view;

    qmlRegisterType<BtTransfer>("Shareplugin", 0, 1, "BtTransfer");

//    view.rootContext()->setContextProperty("obexd", &obexd);

    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
    return app.exec();
}

