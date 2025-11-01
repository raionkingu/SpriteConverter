#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qqml.h>

#include "ImageView.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<ImageView>("ImageViewing", 1, 0, "ImageView");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SpriteConverter", "Main");

    return app.exec();
}
