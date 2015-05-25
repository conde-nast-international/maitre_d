# Maître_d

## What?

Sync a user's `authorized_keys` file with one in a Git repository.

## Install

First, create a simple git repositiory with an `authorized_keys` file.

```
mkdir publickeys
cd publickeys
touch authorized_keys
git init
git add authorized_keys
git commit -m "Creating authorized_keys file for maitre_d"
git remote add origin ssh://some.repo
git push origin master
```

To add or remove keys once `maitred` is running, simply update the `authorized_keys` file and push to `origin`. For example, to add your own key (from the root of the repository directory):

```
cat ~/.ssh/id_rsa.pub >> ./authorized_keys
git add authorized_keys
git commit -m "Authorising key"
git push origin master
```

### init.d service

To sync the `logviewer` user with the `authorized_keys` file from the `ssh://some.repo` repository, create the following configuration at `/etc/maitred.conf`:

```
LOG_USER=logviewer
LOG_REPO=ssh://some.repo
```

Now run the service with:

```
sudo service maitre_d start
```

### maitred daemon

Runs a `matried_refresh` process for each user configured. Takes one argument, the path to a `maitred.conf` configuration file. See above for example.

```
maitred /path/to/maitred.conf
```

### matried_refresh

Process that watches a Git repository and updates a user's `authorized_keys` file. Expects 3 arguments; the target user, the Git repository and the path to a log file.

```
maitred_refresh richard git@cruxdigit.al:/publickeys.git /var/log/maitred.log
```

The target user is expected to have a home directory of the same name under `/home` (e.g. `/home/richard`).

## Config

A configuration file is expected to have at least one `":prefix_USER` and `:prefix_REPO` entry, where `:prefix` is any word (upper or lowercase). For example:

```
blah_USER=richard
blah_REPO=/valid/repo.git
```

A `:prefix` should be unique, allowing many to be specified.

```
blah_USER=richard
blah_REPO=/valid/repo.git

another_USER=guest
another_REPO=/valid/other.git
```

The value for `:prefix_USER` should refer to a valid local user with a home directory under `/home`. A `:prefix_REPO` without a corresponding `:prefix_USER` is ignored. A `:prefix_USER` without a corresponding `:prefix_REPO` will error.

The value for `:prefix_REPO` should be any valid Git repository that can be cloned from.

The default log file path can be overridden by specifying `LOG`.

A full example:

```
logviewer_USER=logviewer
logviewer_REPO=git@github.com:/mycompany-publickeys

LOG=/var/log/public/maitred.log
```
