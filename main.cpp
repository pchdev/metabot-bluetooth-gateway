#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>
#include <stdio.h>
#include <QtDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
