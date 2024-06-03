# Batocera Wine Manager

<p align="center">
  <img src="https://github.com/Gr3gorywolf/batocera_wine_manager/blob/main/assets/icons/art.png?raw=true" alt="Batocera Wine Manager Logo">
</p>

Batocera Wine Manager is an application designed to manage Wine Proton on the Batocera ecosystem. It simplifies the process of installing, configuring, and managing Wine Proton to run Windows applications and games on Batocera systems improving the batocera windows experience.
<br/>
<br/>
[![Github All Releases](https://img.shields.io/github/downloads/Gr3gorywolf/batocera_wine_manager/total.svg)]()
![GitHub last commit](https://img.shields.io/github/last-commit/Gr3gorywolf/batocera_wine_manager)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/Gr3gorywolf/batocera_wine_manager?label=latest%20release)
## Features

- **Easy Installation**: With a simple script, you can quickly set up Batocera Wine Manager on your Batocera system.
- **User-Friendly Interface**: The application provides a straightforward interface for managing Wine Proton, making it accessible to users of all skill levels.
- **Wine Proton Management**: You can install, update, and remove Wine Proton versions effortlessly.
- **Windows redistributables management**: By downloading the redistributables on the app you will be able to activate the redist installation before the game launch

## Installation

To install Batocera Wine Manager, run the following command in your Batocera system terminal:

```bash
curl -L cdn.gregoryc.dev/wine-manager | bash
```

This script will automatically download and install Batocera Wine Manager on your system.
## Compatibility
The Wine manager is compatible and tested with all batocera versions that uses proton

### Note for  batocera < v39
please set proton as default windows emulator in order to use the correct version
### Note for  batocera >= v40
Since on v40 the batocera team added the new runners option on windows games, wine selection is managed by batocera on the game settings, the protons will be downloaded on the proper folder for you to select any downloaded proton version on the game's runner selection option, note that every time that you change the proton version it creates a new bottle for that game on a different folder so you should move the saves manually between bottles

## Usage

After installation, launch Batocera Wine Manager from the applications menu on your Batocera system. Follow the on-screen instructions to manage Wine Protons.

## Redist management

The installation also creates a shortcut on the batocera's "Ports" section and also 2 scripts to enable and disable the redist installation. if the redist installation is on the only thing that gonna run on the wine bottles is the redist installator, you should disable the redist in order to run the game normally

## Support and Contributions

If you encounter any issues or have suggestions for improvements, please [submit an issue](https://github.com/Gr3gorywolf/batocera_wine_manager/issues) on the GitHub repository.

Contributions are welcome! If you'd like to contribute to the development of Batocera Wine Manager, fork the [GitHub repository](https://github.com/Gr3gorywolf/batocera_wine_manager) and submit a pull request.

## License

This application is licensed under the [MIT License](https://github.com/Gr3gorywolf/batocera_wine_manager/blob/main/LICENSE). Feel free to modify and distribute it according to the terms of the license.

---

*Batocera Wine Manager is not affiliated with Batocera or Wine. "Batocera" is a registered trademark of its respective owners.*
