# Bedrock Project: Bootstrap a Bare Host

The software in this repository prepares a bare host. It applies to
physical and virtual hosts.

# Assumptions and Requirements

  * Bedrock supports CentOS 7 servers and Mac OS X workstations.
  * CentOS requirements:
    * Version 7 is installed on the host and the following core services
      are operational:
      * The DNS resolver can resolve AZ FQDNs
      * The LDAP client can authenticate shell users
      * The host is connected to an AZ network
  * Mac OS X requirements:
    * Version 10.10/Yosemite or newer
    * Xcode Command Line Tools are installed.

# Install prerequisite software

## Mac OS X

OS X users must install Xcode Command Line Tools before
bootstrapping. To determine if you have it, run this command:

    xcode-select --print-path

If installed, it will return a path beginning with one of the
following prefixes:

    /Applications/Xcode.app
    /Library/Developer/CommandLineTools

If not, run this command to begin the installation:

    xcode-select --install

This will open a graphical dialog box. Click "Install" to install the
package.

# Bootstrap the Host

## Open a root shell

Open a root shell on the target host.

## Clone this repository

Clone this repository to the target host and change into its directory.

## Bootstrap the host

The bootstrap process can customize the host using an environment file
in the `chef/environments` directory. After creating the file, invoke
this command with the environment's name as an argument:

```
./run/bootstrap_host <environment name>
```

If you do not specify an environment, the process will associate the
host with the `_default` environment.

You can override the default run list by setting the `CHEF_RUN_LIST`
environment variable, as follows:

```
CHEF_RUN_LIST='recipe[widget]' ./run/bootstrap_host <environment name>
```

It will do all of the following:

  * Install the Chef client package
  * Invoke Chef client's "local mode" to provision the host:
    * Configure YUM repositories
    * Configure sudo
	* Create a Chef client configuration and register the client with
      the specified Chef server.

# Development Process

This section explains how to develop the bootstrap software.

## Install Chef DK

Install Chef DK.

## Activate Chef DK on your workstation

```
eval "$(/opt/chefdk/bin/chef shell-init bash)"
```

## Create a local cookbook archive

```
cd chef
rake archive_cookbooks
```

Add the changes to Git's index and commit them.
