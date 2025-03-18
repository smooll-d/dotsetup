# dotsetup
Bash script used to set up my dotfiles.

## Warning Stuff
I wanted to include this message at the end of the README but I feel like I have to say this before doing anything else:

I am not responsible for the damages this script could cause to your system, bla bla bla, you get it. If you use this script and it breaks your Arch installation, do not create issues on this repo, don't message me asking for help.

What I'm saying sounds pretty harsh, but I'm serious, if you decide to use this script, be prepared that it can cause trouble. I have not prepared it for every possible case where it can break. If you can, test it in a VM before actually using it. Or don't use it at all if you believe that it can break or you're hesitant. You don't have to do it. It's a script I created for myself.

Ok, I'm done. If you want to use it, read further.

## Current Features and Upcoming Ones
dotsetup is a pretty ambitious setup script, current features include:

- Pretty printing of setup steps (v1.0.0)
- Backups of files overwritten by dotfiles with the option of deletion (v1.0.0)
- Tracking of the time it took to finish setup (v1.0.0)
- Option to dry run the script before actually committing (`--dry-run`, v1.0.0)
- Running from one script and letting dotsetup download everything (v1.1.0)
- Download of dotfiles if it hasn't been downloaded already (v1.2.1)
- Ability to run each script included with dotsetup seperately by calling dotsetup with options (`--rerun`, v1.3.0)

Planned features include:

- Setup from `archiso` to complete evironment ready to run on first reboot

## Supported Distributions
Currently dotsetup is only available on Arch Linux and I do not believe that will change. Unless I stop using Arch Linux and move to a different distro.

## Installation
As dotsetup is a pretty big script, it's not actually one script. If you're reading this README on GitHub, you can see that there are multiple `.sh` files. These are the scripts that `dotsetup` calls to run each "part" or "step" of the setup. You could run these scripts seperately but why would you since dotsetup already does that for you (unless a step failed and you need to rerun only that step).

This unfortunately means that you need to download the whole directory. But fortunately if the CLI program you use to download stuff off the Internet can download a zip file, then you're good to go.

### Prerequisites
Before you do anything, you have to install the utility with which you'll download dotsetup and depending on which option you choose, you'll have to install one additional tool.

Below is a list of Arch Linux packages for the three options listed in the [Downloading](#Downloading) section:

- `curl` + `unzip` (Option 1, `unzip` is not required if using single file download)
- `wget` + `unzip` (Option 2, `unzip` is not required if using single file download)
- `git` (Option 3)

Depending on how you've set up your Arch installation, `curl` should already be installed (testing in a VM after using `archinstall` showed curl already being present on the system).

### Downloading

#### Single File
As of `v1.1.0` dotsetup can be downloaded as a single file. After downloading and running, dotsetup will download the missing files itself.

> [!IMPORTANT]
> Make sure `curl` is installed. Without it, dotsetup will not be able to download the missing files.

> [!CAUTION]
> Using process substitution (e.g. `bash <(curl -sL <URL>)`) or piping (e.g. `curl -sL | bash`) to run dotsetup is not supported.
> This is because bash does not run dotsetup from the directory you are currently in nor does it actually download dotsetup itself.
> It might look like dotsetup downloads the missing files, that is because it actually downloads them, but unfortunately it is not able to run them.
>
> Other shells will also handle this differently and I cannot support every possible shell. If I wanted to, I would've written this script in an actual programming language instead.

##### cURL

```bash
$ curl -sLO https://github.com/smooll-d/dotsetup/raw/refs/heads/master/dotsetup
$ chmod +x ./dotsetup
```

##### wget

```bash
$ wget -O dotsetup https://github.com/smooll-d/dotsetup/raw/refs/heads/master/dotsetup
$ chmod +x ./dotsetup
```

#### Directory
For versions <v1.1.0 you have to download the whole dotsetup directory.

##### cURL

```bash
$ curl -LO https://github.com/smooll-d/dotsetup/archive/refs/heads/master.zip
$ unzip master.zip
```

##### wget

```bash
$ wget https://github.com/smooll-d/dotsetup/archive/refs/heads/master.zip -O dotsetup.zip
$ unzip dotsetup.zip
```

##### git (Recommended)

```bash
$ git clone --depth 1 https://github.com/smooll-d/dotsetup.git
```

## Usage
Even though dotsetup comes with many scripts, it was designed with ease of use in mind. That means, to run dotsetup, the only thing you need to do is:

### Single File

```bash
$ path/to/dotsetup
```

### Directory

```bash
$ path/to/dotsetup/dotsetup
```

You do not have to cd into the directory, you can run it, sit back, relax, enjoy a cup of coffee, eat something, watch a movie, ~~jerk off~~, anything. After a while (depending mainly on your internet connection but also your computer's speed), you can reboot your computer and everything ~~should~~ will be up and running.

**Be sure to check out the [wiki](https://github.com/smooll-d/dotsetup/wiki) for tips and tricks as well as explanations of useful options!** 
