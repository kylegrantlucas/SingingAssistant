# SingingAssistant
A Sinatra server for local Alexa commands 🎤

## Install

```bash
git clone https://github.com/kylegrantlucas/readingit.git && cd SingingAssistant
```

```bash
bundle install
```

## Installing Plugins

Due to some fancy Ruby tricks, installation should be the same across all plugins and will involve the following steps:

1. Add the gem to the gemfile.
2. Add any configuration variables the plugin needs to the config/config.yml file.
3. Run ```bundle install```
4. Run ```rake skills_config:generate_sample_utterances && rake skills_config:generate_custom_slots && rake skills_config:generate_intent_schema```
5. Copy and paste the newly generated data files from skills_setup/ into the appropriate box in the Amazon Alexa skills configuration editor.


## Usage

You will need to connect the server externally, personally I do this using Nginx as a reverse proxy.
However this may be a little complicated to setup and is outside the scope of this document, so I recommend you use Ngrok.
Ngrok is a utility that allows you to externally port any local port to a domain.

Once this is done and you have your external server URL, go to config/config.yml and set the server settings.
Now you are ready to generate the Lambda Javascript router, go ahead and run ```rake skills_config:generate_lambda_router ```

This will generate a lambda_router.js file in the skills_setup/ directory.

Make sure you have your AWS key and secret set in the config/config.yml file and then run ```rake skills_config:upload_lambda_router```.

This will upload the newly created lambda router file to AWS and create a Lambda function that will allow for us to route the Alexa Skill to our home server.
## Plugins

I have built several plugins for 3rd party services:

* [alexa_hue](https://github.com/kylegrantlucas/alexa_hue) - A plugin for managing your Philips hue lights/rooms/colors/scenes.
* [alexa_couchpotato](https://github.com/kylegrantlucas/alexa_couchpotato) - A plugin for adding movies to Couchpotato.
* [alexa_sickbeard](https://github.com/kylegrantlucas/alexa_sickbeard) - A plugin for checking on the status of TV downloads in SickBeard.
* [alexa_transmission](https://github.com/kylegrantlucas/alexa_transmission) - A plugin for checking the status of downloads in Transmission.
