# Quick Start

## Requirements

* [node.js][1]
* root on the server on which `banana` will run

You will need a [Debian][2]-based operating system if you utilize the Ansible
deployment playbook.  It is designed to allow [RHEL][3]-based systems, but
this feature is not implemented yet.

## Installation

### Manual

1. Log into the server(s) that will run `banana`.
2. Create an application user for `banana`. - OPTIONAL
3. Install node.js and CoffeeScript. (Outside the scope of this document)
4. Clone this repository. (`git clone https://github.com/supertylerc/banana`)
5. `cd` to the banana directory.
6. Compile the CoffeeScript. (`coffee -c banana.coffee`) - OPTIONAL
7. Run the application. (`sudo node banana.js` or `sudo coffee banana.coffee`)


### Automated

1. Install Ansible. (Outside the scope of this document)
2. Copy the roles in `deploy/roles` to your Ansible roles directory.
3. Copy the playbook in `deploy/` to your Ansible playbooks directory.
4. Modify variables as you see fit.
5. Run the `banana.yml` playbook.
6. Log into the server(s) and run the application. (`sudo node banana.js`)

### Permissions

`banana` requires elevated permissions.  This is because you must have
elevated permissions to craft ICMP packets.  This is obviously a security
concern, and I encourage you to read the source code to ensure I'm not
doing anything sneaky.  The code is pretty short and simple.

To get around some security concerns, you can add the following to your
`/etc/sudoers` file (by typing `sudo visudo`):

```
banana ALL=(ALL) NOPASSWD: /home/banana/.nvm/v0.10.35/bin/node banana.js
```

The above line allows the user `banana` to _only_ run `node` as root, and
further only allows it to happen when the only argument is `banana.js`.
This means that a malicious `banana` can only ever execute
`/home/banana/.nvm/v0.10.35/bin/node banana.js` with elevated permissions--
unless, of course, that `banana` is a member of a group that allows elevated
permissions.  If you choose to use the above example rule, please remember
to substitute whatever version of `node` you installed.

# What

`banana` is a tool designed for new deployments.

When a server is turned up, you need to be sure it can reach every single
host with which it must communicate.  `banana` was created to make this
as easy as possible.  Populate a configuration file, deploy `banana`, and
run it.

## Test Results

`banana` has been tested to hit 861 servers around the world--Singapore,
California (US), New York (US), and Virginia (US)--in under 1 second.
The average while testing a source in either California or New York has
been about 300ms when all hosts respond appropriately.  When one is not
reachable, it has been tested to take a minimum of 16 seconds to
complete.  The maximum varies based on how far the traceroute gets and
has taken as long as 30 seconds.

## The Future

`banana` is evolving into a continuous metric tool to measure latency from
all hosts to all other hosts.  The roadmap for `banana` also includes `nc`-
like features.  Because `banana` currently requires ICMP to work in both
directions for all hosts, it is not suited to all environments, particularly
those with stronger security requirements.  `banana` will be updated to
measure the time it takes to establish a connection to a remote TCP or UDP
port in the future.

# Why

Deploying new network segments can sometimes cause unforeseen connectivity
problems.  Instead of manually performing the same steps every time a new
segment is stood up, a more automated (fire and forget) approach was
necessary.

# Who

`banana` was written by Tyler Christiansen.

# When

IN THE FUTURE!

# Where

`banana` was developed primarily in spare time, although certain aspects
(such as the Ansible deployment roles and playbook) were written while
working at Adap.tv.

[1]: http://nodejs.org/ "node.js home page"
[2]: https://debian.org/ "Debian home page"
[3]: http://www.redhat.com/en/technologies/linux-platforms/enterprise-linux "RHEL Hhome page"
