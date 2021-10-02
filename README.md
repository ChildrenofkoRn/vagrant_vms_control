# vagrant_vms_control
Simple CLI for manage vagrants VMs

The utility doesn't change any VMs settings.  
Its simply an interface for managing VMS status over Vagrant.

## requirements
Windows, ruby 2.5+, Vagrant, Virtualbox

## using
```
JSON file w VMS list hasn't been created yet.

Hi, dude!
This util for control vagrants VMs on Vbox.
Ctrl+C => Exiting

 #  name                        id      status
------------------------------------------------------------
 0  runner                 d68534c      saved
 1  deploy                 56f41c4      powered off
 2  ubu_dev                690abe3      powered off

Your choice:    2

Actions for vm: ubu_dev

 0  start
 1  stop
 2  pause
 3  resume
 4  remap
 5  return to main menu

Your choice:    0

Bringing machine 'ubu_dev' up with 'virtualbox' provider...
==> ubu_dev: Clearing any previously set network interfaces...
==> ubu_dev: Preparing network interfaces based on configuration...
    ubu_dev: Adapter 1: nat
    ubu_dev: Adapter 2: hostonly
==> ubu_dev: Forwarding ports...
==> ubu_dev: Booting VM...
==> ubu_dev: Waiting for machine to boot. This may take a few minutes...
    ubu_dev: SSH address: 192.168.58.8:2222
    ubu_dev: SSH username: vagrant
    ubu_dev: SSH auth method: private key
==> ubu_dev: Machine booted and ready!
==> ubu_dev: Checking for guest additions in VM...
==> ubu_dev: Mounting shared folders...
    ubu_dev: /home/vagrant/data/projects => L:/local/shared/path
==> ubu_dev: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> ubu_dev: flag to force provisioning. Provisioners marked to run always will still run.

 #  name                        id      status
------------------------------------------------------------
 0  runner                 d68534c      saved
 1  deploy                 56f41c4      powered off
 2  ubu_dev                690abe3      running

Your choice:

```

## TODO
 - the ability to change index for VM in the vagrant-index:  
   ```c:\Users\$USERNAME$\.vagrant.d\data\machine-index\index```
 - add column with uptime VM


[![badge-license][badge-license]][license]


[license]: https://github.com/ChildrenofkoRn/vagrant_vms_control/blob/main/LICENSE "MIT"
[badge-license]: https://img.shields.io/github/license/ChildrenofkoRn/vagrant_vms_control?color=%23239393 "license"
