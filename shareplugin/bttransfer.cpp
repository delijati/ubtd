#include "bttransfer.h"
#include "obexagent.h"

#include <QDebug>
#include <QFile>
#include <QBluetoothTransferRequest>
#include <QDBusReply>

BtTransfer::BtTransfer(QObject *parent) :
    QObject(parent),
    m_dbus(QDBusConnection::sessionBus()),
    m_manager("org.openobex.client", "/", "org.openobex.Client", m_dbus)
{
}

qreal BtTransfer::progress() const
{
    return m_progress;
}

void BtTransfer::sendFile(const QString &address, const QString &fileName)
{
    // Not working atm... TODO: Figure if this is working with BlueZ 5
//    qDebug() << "Begin sharing file: " << address << fileName;
//    QBluetoothAddress btAddress = QBluetoothAddress(address);
//    QBluetoothTransferRequest request(btAddress);
//    QFile *file = new QFile(fileName);
//    reply = manager.put(request, file);
//    connect(reply, SIGNAL(transferProgress(qint64,qint64)), this, SLOT(updateProgress(qint64,qint64)));

    ObexAgent *agent = new ObexAgent();

    QVariantMap deviceMap;
    deviceMap.insert(QString::fromLatin1("Destination"), address);

    QStringList files;
    files << fileName;


    QDBusObjectPath path(DBUS_ADAPTER_AGENT_PATH);


    QDBusReply<void > reply = m_manager.call("SendFiles", qVariantFromValue(deviceMap), files, qVariantFromValue(path));
    if (!reply.isValid())
        qWarning() << "Error registering agent for the default adapter:" << reply.error();
    else
        qDebug() << "sending...";

}

void BtTransfer::updateProgress(qint64 transferred, qint64 total)
{
    m_progress = ((float)transferred)/((float)total);
    emit progressChanged();
}
