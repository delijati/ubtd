#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>

#include "adapter.h"
#include "obexd.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Adapter adapter;
    Obexd obexd;

    QQuickView view;

    view.rootContext()->setContextProperty("obexd", &obexd);

    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
    return app.exec();
}

