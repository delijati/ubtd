#include "bttransfer.h"
#include "obexagent.h"

#include <QDebug>
#include <QFile>
#include <QBluetoothTransferRequest>
#include <QDBusReply>

BtTransfer::BtTransfer(QObject *parent) :
    QObject(parent),
    reply(0),
    m_progress(0),
    m_finished(false),
    m_error(QBluetoothTransferReply::NoError)
{
}

qreal BtTransfer::progress() const
{
    return m_progress;
}

bool BtTransfer::finished() const
{
    return m_finished;
}

bool BtTransfer::error() const
{
    return m_error != QBluetoothTransferReply::NoError;
}

void BtTransfer::sendFile(const QString &address, const QString &fileName)
{
    qDebug() << "Begin sharing file: " << address << fileName;
    QBluetoothAddress btAddress = QBluetoothAddress(address);
    QBluetoothTransferRequest request(btAddress);
    QFile *file = new QFile(fileName);
    reply = manager.put(request, file);
    connect(reply, SIGNAL(transferProgress(qint64,qint64)), this, SLOT(updateProgress(qint64,qint64)));
    connect(reply, SIGNAL(finished(QBluetoothTransferReply*)), this, SLOT(transferFinished(QBluetoothTransferReply*)));
    connect(reply, SIGNAL(error(QBluetoothTransferReply::TransferError)), this, SLOT(transferError(QBluetoothTransferReply::TransferError)));
}

void BtTransfer::updateProgress(qint64 transferred, qint64 total)
{
    m_progress = ((float)transferred)/((float)total);
    emit progressChanged();
}

void BtTransfer::transferFinished(QBluetoothTransferReply *reply)
{
    reply->deleteLater();
    this->reply = 0;
    m_finished = true;
    emit finishedChanged();
}

void BtTransfer::transferError(QBluetoothTransferReply::TransferError lastError)
{
    m_error = lastError;
    emit errorChanged();
}
