# dotsetup
Bash script used to set up my dotfiles.

## Warning Stuff
I wanted to include this message at the end of the README but I feel like I have to say this before doing anything else:

I am not responsible for the damages this script could cause to your system, bla bla bla, you get it. If you use this script and it breaks your Arch installation, do not create issues on this repo, don't message me asking for help.

What I'm saying sounds pretty harsh, but I'm serious, if you decide to use this script, be prepared that it can cause trouble. I have not prepared it for every possible case where it can break. If you can, test it in a VM before actually using it. Or don't use it at all if you believe that it can break or you're hesitant. You don't have to do it. It's a script I created for myself.

Ok, I'm done. If you want to use it, read further.

## Current Features and Upcoming Ones
dotsetup is a pretty ambitious setup script, current features include:

- Pretty printing of setup steps
- Backups of files overwritten by dotfiles with the option of deletion
- Tracking of the time it took to finish setup
- Option to dry run the script before actually committing (`--dry-run`)
- And of course the setup part of the script, but I don't think I have to mention this

Planned features include:

- Setup from `archiso` to complete evironment ready to run on first reboot
- Ability to run each script included with dotsetup seperately by calling dotsetup with options
- Running from one script and letting dotsetup download everything

## Supported Distributions
Currently dotsetup is only available on Arch Linux and I do not believe that will change. Unless I stop using Arch Linux and move to a different distro.

## Installation
As dotsetup is a pretty big script, it's not actually one script. If you're reading this README on GitHub, you can see that there are multiple `.sh` files. These are the scripts that `dotsetup` calls to run each "part" or "step" of the setup. You could run these scripts seperately but why would you since dotsetup already does that for you (unless a step failed and you need to rerun only that step).

This unfortunately means that you need to download the whole directory. But fortunately if the CLI program you use to download stuff off the Internet can download a zip file, then you're good to go.

### Prerequisites
Before you do anything, you have to install the utility with which you'll download dotsetup and depending on which option you choose, you'll have to install one additional tool.

Below is a list of Arch Linux packages for the three options listed in the [Downloading](#Downloading) section:

- `curl` + `unzip` (Option 1)
- `wget` + `unzip` (Option 2)
- `git` (Option 3)

Depending on how you've set up your Arch installation, `curl` should already be installed (testing in a VM after using `archinstall` showed curl already being present on the system).

### Downloading
Below are three ways you can download dotsetup on your system. I recommend using git as it is by far the easiest to use. It does not require installing `unzip` and you get everything with one command.

#### cURL

```bash
$ curl -LO https://github.com/smooll-d/dotsetup/archive/refs/heads/master.zip
$ unzip master.zip
```

#### wget

```bash
$ wget https://github.com/smooll-d/dotsetup/archive/refs/heads/master.zip -O dotsetup.zip
$ unzip dotsetup.zip
```

#### git

```bash
$ git clone --depth 1 https://github.com/smooll-d/dotsetup.git
```

Of course these aren't the only three options, you can download dotsetup with whichever tool you like to use, just remember to install it first.

## Usage
Even though dotsetup comes with many scripts, it was designed with ease of use in mind. That means, to run dotsetup, the only thing you need to do is:

```bash
$ dotsetup/dotsetup
```

You do not have to cd into the directory, you can run it, sit back, relax, enjoy a cup of coffee, eat something, watch a movie, ~jerk off~, anything. After a while (depending mainly on your internet connection but also your computer's speed), you can reboot your computer and everything ~should~ will be up and running.

> [!TIP]
> If at any point, one of the steps fails, you can rerun that step (though this has not been tested) by executing that step's script.
> If for example installation of packages fails, you can execute the `install-packages.sh` script, though be mindful that you need to give it permissions to execute:
> ```bash
> $ cd dotsetup/
> $ chmod +x ./install-packages.sh
> $ ./install-packages.sh
> ```

## Adding Packages
Pretty much all of the setup script is hardcoded as it should be because it's a setup script for me and my specific needs, but there is one piece of this "software" that isn't 100% hardcoded and that is, package installation.

You can add/remove your own packages by editing the `packages-pacman.txt` and `packages-aur.txt` for pacman and yay respectively. You could even generate your own package files by running:

```bash
$ pacman -Qqn > packages-pacman.txt
$ pacman -Qqm > packages-aur.txt
```

Edit the files to remove any unwanted packages and dotsetup will install them.

> [!CAUTION]
> Before installing packages from `packages-pacman.txt`, pacman will also install `vulkan-radeon`, `lib32-vulkan-radeon`, `virtualbox-host-modules-arch` and `man-db`. If you don't want them, you'll have to edit the `install-packages.sh` script and remove them yourself.

In actuality, you could customize everything, you just need to know a bit of shell scripting.
