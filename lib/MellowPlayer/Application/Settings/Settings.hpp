#pragma once

#include <QtCore/QObject>
#include <QtCore/QList>
#include "SettingKey.hpp"

namespace MellowPlayer::Application {

    class ISettingsProvider;
    class ISettingsSchemaLoader;
    class SettingsCategory;
    class Setting;

    class Settings: public QObject {
        Q_OBJECT
    public:
        Settings(ISettingsSchemaLoader& configurationLoader, ISettingsProvider& settingsProvider);

        const QList<SettingsCategory*>& getCategories() const;

        SettingsCategory& getCategory(const QString& key) const;
        Setting& get(const QString& key) const;
        Setting& get(SettingKey::Keys key);

        ISettingsProvider& getSettingsProvider() const;

        void restoreDefaults();

    private:
        ISettingsProvider& settingsProvider;
        QList<SettingsCategory*> categories;
    };

}
