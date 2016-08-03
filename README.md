# SingingAssistant
A Sinatra server for local Alexa commands 🎤

## Install

```bash
git clone https://github.com/kylegrantlucas/readingit.git && cd SingingAssistant
```

```bash
bundle install
```

## Usage

You will need to connect the server externally, personally I do this using Nginx as a reverse proxy.
However this may be a little complicated to setup and is outside the scope of this document, so I recommend you use Ngrok.
Ngrok is a utility that allows you to externally port any local port to a domain.

## Plugins

I have built several plugins for 3rd party services:

* [alexa_hue](https://github.com/kylegrantlucas/alexa_hue) - A plugin for managing your Philips hue lights/rooms/colors/scenes.
* [alexa_couchpotato](https://github.com/kylegrantlucas/alexa_couchpotato) - A plugin for adding movies to Couchpotato.
* [alexa_sickbeard](https://github.com/kylegrantlucas/alexa_sickbeard) - A plugin for checking on the status of TV downloads in SickBeard.
* [alexa_transmission](https://github.com/kylegrantlucas/alexa_transmission) - A plugin for checking the status of downloads in Transmission.
