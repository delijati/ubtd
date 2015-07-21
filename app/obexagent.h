#ifndef OBEXAGENT_H
#define OBEXAGENT_H

#include <QObject>
#include <QDBusObjectPath>
#include <QDebug>
#include <QDBusConnection>
#include <QDBusAbstractAdaptor>

#define DBUS_ADAPTER_AGENT_PATH "/test/agent"

#include "obexagentadaptor.h"

class ObexAgent : public QObject
{
    Q_OBJECT
public:
    explicit ObexAgent(QObject *parent = 0);

signals:
    void authorized(const QString &path, const QString &filePath, const QString &filename, const QString btAddress, const QString &type, int length);

public slots:
    QString Authorize(const QDBusObjectPath &transfer, const QString &bt_address, const QString &name, const QString &type, int length, int time);

private:
    QDBusConnection m_dbus;
    ObexAgentAdaptor *m_agent;
};

#endif // OBEXAGENT_H
