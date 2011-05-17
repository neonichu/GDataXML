# GDataXML

This project is a repackaging of GDataXML and HtmlTidy for use on iOS with
Xcode4. It contains some added convenience code and unit tests written by
me, but it is mostly written by other people.

## Origin

This project is hosted on GitHub: https://github.com/neonichu/GDataXML

It depends on code which normally lives here:

* GDataXML: http://code.google.com/p/gdata-objectivec-client/
* HtmlTidy: http://tidy.sourceforge.net/

## License

* GDataXML is licensed under Apache 2.0 (see license-gdata.txt).
* HtmlTidy is licensed under a BSD-style license (see license-tidy.txt). 
* My code is licensed under BSD, without any attribution requirements.

## Usage

1. In Build Settings -> Header Search Paths, add "/usr/include/libxml2".
2. In Build Phases -> Target Dependencies, add "GDataXML".
3. In Build Phases -> Link Binary with Libraries, add "libGDataXML.a"

## Apps using it

Currently, there is only my very own app Republizierer, which has yet to be
submitted to the App Store. At this point in time, I can give you no 
guarantees that this library is save to use in your iOS applications.

--
Boris Buegling <boris@icculus.org>
