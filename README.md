# Doxygen Plugin for DITA-OT [<img src="https://jason-fox.github.io/fox.jason.passthrough.doxygen/doxygen.png" align="right" width="300">](http://doxygendita-ot.rtfd.io/)

[![license](https://img.shields.io/github/license/jason-fox/fox.jason.passthrough.doxygen.svg)](http://www.apache.org/licenses/LICENSE-2.0)
[![DITA-OT 4.0](https://img.shields.io/badge/DITA--OT-4.0-green.svg)](http://www.dita-ot.org/4.0)
[![CI](https://github.com/jason-fox/fox.jason.passthrough.doxygen/workflows/CI/badge.svg)](https://github.com/jason-fox/fox.jason.passthrough.doxygen/actions?query=workflow%3ACI)
[![Coverage Status](https://coveralls.io/repos/github/jason-fox/fox.jason.passthrough.doxygen/badge.svg?branch=master)](https://coveralls.io/github/jason-fox/fox.jason.passthrough.doxygen?branch=master)

This is a [DITA-OT Plug-in](https://www.dita-ot.org/plugins) used to auto-create valid DITA-based Doxygen documentation.
The initial source of the documentation can be generated directly using the
[Doxygen XML](http://www.doxygen.nl/manual/customize.html#xmlgenerator). The XML file can be added to the source and
processed as if it had been written in DITA.

<details>
<summary><strong>Table of Contents</strong></summary>

-   [Background](#background)
-   [Install](#install)
    -   [Installing DITA-OT](#installing-dita-ot)
    -   [Installing the Plug-in](#installing-the-plug-in)
-   [Usage](#usage)
-   [License](#license)

</details>

## Background

[<img src="https://jason-fox.github.io/fox.jason.passthrough.doxygen/doxygen-logo.png" align="right" height="55">](https://docs.oracle.com/javase/1.5.0/docs/guide/doxygen/index.html)

[Doxygen](http://www.doxygen.nl/manual/) is a tool that parses the declarations and
documentation comments in a set of source files and produces a set of HTML pages describing the classes, interfaces,
constructors, methods, and fields.


#### Sample doxygen

```c++
namespace transport
{
    /** Mountain bike implementation of a `Bicycle`.
     *
     * MountainBike is an implementation of a Bicycle
     * providing a bike for cycling on rough terrain. Mountain bikes
     * are pretty cool because they have stuff like **Suspension** (and
     * you can even adjust it using SetSuspension). If you're looking
     * for a bike for use on the road, you might be better off using a
     * RacingBike though.
     *
     * @ingroup mountainbike
     */
	class MountainBike : public Bicycle
	{
	public:
		/** Set suspension stiffness.
		 * @stiffness the suspension stiffness.
		 *
		 * SetSuspension changes the stiffness of the suspension
		 * on the bike. The method will return false if the stiffness
		 * could not be adjusted.
		 *
		 * @return true if the suspension was adjusted successfully,
		 *         false otherwise.
		 */
		bool SetSuspension(double stiffness);
```

#### Sample DITA Output

> ![](https://jason-fox.github.io/fox.jason.passthrough.doxygen/mountainbike.png)

## Install

The DITA-OT doxygen plug-in has been tested against [DITA-OT 3.x](http://www.dita-ot.org/download). The plugin requires
the XSLT 3.0 support found in the [Saxon9.8HE](https://www.saxonica.com/html/download/java.html) library, so the mimimum
DITA-OT version is therefore 3.3. It is recommended that you upgrade to the latest version.

### Installing DITA-OT

<a href="https://www.dita-ot.org"><img src="https://www.dita-ot.org/images/dita-ot-logo.svg" align="right" height="55"></a>

The DITA-OT doxygen plug-in is a file reader for the DITA Open Toolkit.

-   Full installation instructions for downloading DITA-OT can be found
    [here](https://www.dita-ot.org/4.0/topics/installing-client.html).

    1.  Download the `dita-ot-4.0.zip` package from the project website at
        [dita-ot.org/download](https://www.dita-ot.org/download)
    2.  Extract the contents of the package to the directory where you want to install DITA-OT.
    3.  **Optional**: Add the absolute path for the `bin` directory to the _PATH_ system variable.

    This defines the necessary environment variable to run the `dita` command from the command line.

```console
curl -LO https://github.com/dita-ot/dita-ot/releases/download/4.0/dita-ot-4.0.zip
unzip -q dita-ot-4.0.zip
rm dita-ot-4.0.zip
```

### Installing the Plug-in

-   Run the plug-in installation commands:

```console
dita install https://github.com/jason-fox/fox.jason.passthrough.doxygen/archive/master.zip
```

The `dita` command line tool requires no additional configuration.

---

## Usage

To do generate Doxygen XML set `GENERATE_XML` to `YES`.

The XML output consists of an index file named `index.xml` which lists all items extracted by doxygen with references to the other XML files for details. The structure of the index is described by a schema file `index.xsd`. The Doxygen source should be concatenated into one single XML file using the instructions found in the XSLT file `combine.xslt`.

Once the source XML has been created, add it to the `*.ditamap` and mark it for **doxygen** processing, by labelling it
with `format="doxygen"` within the `*.ditamap` as shown:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE bookmap PUBLIC "-//OASIS//DTD DITA BookMap//EN" "bookmap.dtd">
<bookmap>
    ...etc
    <appendices toc="yes" print="yes">
      <topicmeta>
        <navtitle>Appendices</navtitle>
      </topicmeta>
      <appendix format="dita" href="topic.dita">
        <topicref format="doxygen" type="topic" href="doxygen.xml"/>
      </appendix>
   </appendices>
</bookmap>
```

The additional file will be converted to a `*.dita` file and will be added to the build job without further processing.
Unless overridden, the `navtitle` of the included topic will be the same as root name of the file. Any underscores in
the filename will be replaced by spaces in title.

## License

[Apache 2.0](LICENSE) © 2020 - 2022 Jason Fox
