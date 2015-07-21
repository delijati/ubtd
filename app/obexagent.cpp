#include "obexagent.h"

#include <QStandardPaths>

ObexAgent::ObexAgent(QObject *parent) :
    QObject(parent),
    m_dbus(QDBusConnection::sessionBus())
{
    qDebug() << "registering agent";
    m_agent = new ObexAgentAdaptor(this);
    if(!m_dbus.registerObject(DBUS_ADAPTER_AGENT_PATH, this))
        qCritical() << "Couldn't register agent at" << DBUS_ADAPTER_AGENT_PATH;

}

QString ObexAgent::Authorize(const QDBusObjectPath &transfer, const QString &bt_address, const QString &name, const QString &type, int length, int time)
{
    qDebug() << "authorize called" <<  transfer.path();

    QString targetPath = "/tmp/obexd/";
    QDir dir(targetPath);
    if (!dir.exists()) {
        dir.mkpath(targetPath);
    }

    emit authorized(transfer.path(), targetPath, name, bt_address, type, length);
    return targetPath + name;
}

