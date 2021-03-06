#include "Updater.hpp"
#include "AbstractPlatformUpdater.hpp"
#include "ILatestReleaseQuerier.hpp"
#include "Release.hpp"
#include <MellowPlayer/Application/Logging/ILogger.hpp>
#include <MellowPlayer/Application/Logging/LoggingManager.hpp>
#include <MellowPlayer/Application/Logging/LoggingMacros.hpp>
#include <MellowPlayer/Application/Settings/Setting.hpp>
#include <MellowPlayer/Application/Settings/Settings.hpp>
#include <MellowPlayer/Application/Settings/SettingKey.hpp>

using namespace MellowPlayer::Application;

Updater::Updater(ILatestReleaseQuerier& releaseQuerier, Settings& settings, AbstractPlatformUpdater& platformUpdater)
        : logger_(LoggingManager::logger("Updater")),
          releaseQuerier_(releaseQuerier),
          platformUpdater_(platformUpdater),
          autoCheckEnabledSetting_(settings.get(SettingKey::MAIN_CHECK_FOR_UPDATES)),
          updateChannelSetting_(settings.get(SettingKey::MAIN_UPDATE_CHANNEL)),
          currentRelease_(&Release::current())
{
    releaseQuerier.setChannel(getChannel());
    connect(&releaseQuerier, &ILatestReleaseQuerier::latestReceived, this, &Updater::onLatestReleaseReceived);
    connect(&updateChannelSetting_, &Setting::valueChanged, this, &Updater::check);
    connect(&platformUpdater, &AbstractPlatformUpdater::progressUpdated, this, &Updater::progressUpdated);
    connect(&platformUpdater, &AbstractPlatformUpdater::downloadFinished, this, &Updater::onDownloadFinished);
    connect(&platformUpdater, &AbstractPlatformUpdater::installFinished, this, &Updater::onInstallFinished);
}

void Updater::check()
{
    LOG_DEBUG(logger_, "Checking for update");
    setStatus(Status::Checking);
    releaseQuerier_.setChannel(getChannel());
    releaseQuerier_.query();
}

UpdateChannel Updater::getChannel() const
{
    return static_cast<UpdateChannel>(updateChannelSetting_.value().toInt());
}

void Updater::install()
{
    LOG_DEBUG(logger_, "Downloading update");
    setStatus(Status::Downloading);
    platformUpdater_.download();
}

bool Updater::isUpdateAvailable() const
{
    return isUpdateAvailable_;
}

bool Updater::canInstall() const
{
    return platformUpdater_.canInstall();
}

const Release* Updater::latestRelease() const
{
    return latestRelease_;
}

void Updater::onLatestReleaseReceived(const Release* release)
{
    if (release != nullptr && *release > *currentRelease_) {
        LOG_DEBUG(logger_, QString("Latest release is an update (%1 < %2)").arg(currentRelease_->name()).arg(release->name()));
        setStatus(Status::UpdateAvailable);
        latestRelease_ = release;
        platformUpdater_.setRelease(latestRelease_);
        isUpdateAvailable_ = true;
        emit updateAvailable();
    } else {
        LOG_DEBUG(logger_, QString("Current release is up to date..."));
        setStatus(Status::None);
        latestRelease_ = nullptr;
        isUpdateAvailable_ = false;
        emit noUpdateAvailable();
    }
}

void Updater::setCurrentRelease(const Release* currentRelease)
{
    currentRelease_ = currentRelease;
}

Updater::Status Updater::status() const
{
    return status_;
}

void Updater::setStatus(Updater::Status status)
{
    if (status_ != status) {
        status_ = status;
        emit statusChanged();
    }
}

void Updater::onDownloadFinished(bool succes)
{
    if (succes) {
        LOG_DEBUG(logger_, "download finished, installing...")
        setStatus(Status::Installing);
        platformUpdater_.install();
    } else {
        LOG_DEBUG(logger_, "download failed")
        setStatus(Status::Failure);
    }
}
void Updater::onInstallFinished(bool succes)
{
    if (succes) {
        LOG_DEBUG(logger_, "install finished, you can now restart the application");
        setStatus(Status::Installed);
        emit installed();
    } else {
        LOG_DEBUG(logger_, "install failed");
        setStatus(Status::Failure);
    }
}
void Updater::restart()
{
    platformUpdater_.restart();
}
