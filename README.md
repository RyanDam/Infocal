# Infocal
Infocal, a watchface for Garmin devices

[Link to Garmin Connect IQ store](https://apps.garmin.com/en-US/apps/c97c4e34-55e4-4601-b5c2-45763bc481a2#0)

# Contribution

My work will stay free, if you want to donate for my work, it will help me a lot:

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/pyryandam)

## Code contribution
1. Fork the project
2. Develop your feature
3. Make a pull request to this project
4. I will review the code and test it, and then I'll consider merging your code.

# Description

Infocal is a digital and analogue watchface, carefully made with high quality rendering. It's both customizable and functional. With up to 8 complications on the screen, each complication can show a variety of data:

- Date
- Digital time/2nd timezone
- Battery
- Total/Active calories
- Live heart rate
- Moved distance (day/weekly)
- Move bar
- Daily steps
- Active minutes
- Notification/Alarm/Connection status
- Altitude
- Temperature (on-device sensor)
- Temperature (outside)
- Temperature (high/low)
- Sunrise/Sunset time
- Floor climbed
- Barometer data
- Countdown to event day
- Weather condition

Please configure your watch face via Garmin Connect Mobile or Garmin Express. Here is how to do it:

https://forums.garmin.com/developer/connect-iq/w/wiki/14/changing-your-app-settings-in-garmin-express-gcm-ciq-mobile-store

# FAQs

- Why Infocal need user profile permission?

Infocal needs your profile to calculate active calories, distance goal (based on your steps and stride length), moving distance for a whole week. Infocal is using your profile for that purposes and will not save it anywhere.

- Why Infocal need internet/background communication permission?

Infocal uses OpenWeatherMap API to fetch weather information, and only for that.

- Battery format in days isn't working?

The battery consumption estimate will need time to make an estimate, it will need at least 1 hour to complete. The estimate updates once every hour. If you restart your watch or switch from different watchface, it will need to calibrate again.

- Too much data on the screen?

You can set it to "Empty" complication, it won't draw anything.

- This watchface consumes too much energy?

Hey, there's a built-in power saving mode in the settings which will reduce the screen refresh rate to once per minute.

- How to see if the watch is connected to the phone?

By using the group notification complication, if a phone is connected it will show "C" (connected), otherwise is "D" (disconnected).

- If I update the watchface via Garmin connect, all the settings reset to default?

This is a bug of Garmin Connect iOS app, please update Garmin Connect to the latest version.

- Can't get sunrise/sunset to work?

Sunrise/sunset only works if the watch has a GPS signal, try to start any activity and wait for GPS signal, then return to watch face and then everything is good.

- Complication data just show "--" value?

Not all complications are supported for any device, it depends on your device whether it is supported or not.

- A square appeared instead of a character?

Currently, this watch face only supports English (or Latin characters), more language support will come in the next release.

- Why weather/outside temperature is not shown/update?

Weather/outside temperature needs internet and GPS information to work. Please set your GPS up (as instructed in the FAQs), and make sure your watch is connected to your phone (via Carmin Connect) with internet connected.

- What is the source of weather information?

This watchface get weather info from OpenWeatherMap API.

- Why weather does not update properly or showing the wrong number?

Infocal uses OpenWeatherMap API free tier, which is only allowed for 60 API calls per second or 1000 request per day. With many people using Infocal, it exceeds the limit. To make weather work better for you, please read API document from OpenWeatherMap here to get your own API key: https://openweathermap.org/guide#how (Your API key will need several hours to be activated by OpenWeatherMap)

- What is OpenWeatherMap API key?

It''s a key to allow you to get weather information from OpenWeatherMap, as describe in "Why weather does not update properly or showing the wrong number?".

**Currently this watch face only support English (or Latin characters), more language support will come in the next release.**

# Credits

- Special thanks to **[warmsound](https://github.com/warmsound)** for awesome [Crystal Watchface](https://github.com/warmsound/crystal-face). Without Crystal, I'm not able to add some features (suntime, sensor history, weather...) to this watchface.
- Special thanks to **[sunpazed](https://github.com/sunpazed)** for his awesome GitHub projects. I learned a lot from him for anti-aliasing and get inspired to create curved text, which makes Infocal today.
