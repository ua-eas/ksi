# RAMBLE for Kuali Service Installer (KSI)

## Disclaimer

This is a quick and dirty ramble on why and how KSI does what
it does, written by Mike Simpson in July 2012, and subject to
becoming increasingly inaccurate with the passage of time like
all documentation.

If all you need to do is run KSI, then you should go look at
the comments at the top of the "ksi.sh" shell script, which
will tell you what you need to know.

## Conceptual Design

### Services & Environments

Our world is made up of **services**.  Services are the things
that the enduser sees: functionality living at a particular
URL.

Services come in flavors called **environments**, e.g.
for the Kuali service, we have development ("DEV"), testing
("TST"), production ("PRD"), etc.

### Components & Versions

Services are composed of some operating system resources (a UNIX
user account and group to own files and do administrative tasks,
maybe some filesystems for storing data, etc.) along with
**components**.  A component is a particular piece of installed
software that cooperates with other components to provide
a service, e.g. Tomcat, along with a JDK installation, along
with a web server like Apache, cooperate together to provide a 
web service like Kuali.  For another service, it might be an
Apache web server, plus a Ruby installation, plus the Passenger
Apache module, plus a MySQL database instance, etc.

Like environments, components also come in flavors called
**versions**, e.g. Tomcat 7.0.28, Apache Httpd 2.2.18.

### Applications

**Applications** are the things that we develop and deploy
on top of the service components, e.g. for us, KFS and KC.
This tool (KSI) isn't about applications.  Applications exist
on their own deployment cycle, in their own code repositories,
with their own version and release numbers.  KSI is about
versioning and automating the deployment of the **service
infrastructure**, e.g. all of the cooperating components
and system resources that together provide the platform on
which the applications run.

### Confirmation of State

The end goal is to provide **confirmation of state** at the
service infrastructure level.  That is, at the application
level, we can look at the "3.0-57" local release of our KFS
software, and point to a specific tag in the code repository,
and a specific set of related JIRA tickets, and assert that
if a given environment has "3.0-57" deployed to it, we know
exactly what application state exists, and that it should
closely match any other environment in which "3.0-57" has
been deployed.  With KSI, we start to provide the same 
confirmation of state for the components that live beneath
the application, but above the operating system.

There are a lot of other places where confirmation of state
is either already implemented, or could be implemented in the
future: OS state can be maintained via a configuration 
management tool like Puppet or cfengine, database state can
be versioned and tracked with a tool like Liquibase, etc.
Eventually, a service can be thought of as a layered stack of
confirmed states, and you can do release management on
each layer exactly the way you do it for the application code:
"Today we are taking the operating system from rhel5-14 to
rhel5-15;" "Next week we are re-deploying our production
service infrastructure from version 2.0 to version 2.1."

> That's the grand idea, anyway.  Eventually you could also
> take a defined set of stacked states, and call it a
> "service release" or something like that: "Service Release 5
> of the Kuali service is composed of the rhel5-19 image,
> supporting the ksi-12 service infrastructure, supporting
> the kfs-5.0-15 application."  Then you could say, "We're
> taking the STG environment to SR5 this weekend," or even
> better, after you say that, you could have a tool with
> a big red "go" button and two input parameters: an 
> environment, and a service release number. But that's
> step 74, and we're on step 3 right now.

## System Resource Prerequisites

The part of the world that lives "below" KSI, and which we
assume is already in place before KSI starts its work, includes
basic system resources like:

* a **service user** and **service group** to be used to install
  and administer everything;

* a **service home** filesystem, traditionally living under
  the /opt hierarchy, where all of the mostly-static pieces
  of a component get installed (binaries, libraries, and
  other things that don't change much after installation);

* a **service configuration** filesystem, traditionally living
  under /etc/opt, where service and component configuration
  files get installed;

* a **service base** filesystem, traditionally living under
  the /var/opt hierarchy, where all of the dynamic pieces
  of a component get installed (web content for a webserver,
  log files, etc.).

> For the moment, the service configuration directory is mostly
> where SysVinit-type scripting get stashed, since a lot of
> components default to having their configurations closer to
< their home or base directories.  We're too busy right now to
> spend a lot of time fighting with Tomcat about where it wants
> its config files to live, but it's probably worth re-examination
> in the future, maybe each time we add in a new version of a
> component.

## How KSI Sees The World

If you look at the top of the KSI repository, you'll see that
we immediately split into two big trees: components and services.

### The Component Side

Under the component side, you'll see the hierarchy break down
by component, then by component version.  You'll see some ".env"
files, more on those later.  At the top of the component
tree, you'll also see templates for the service master init
script and profiles -- one of these for each service that
gets installed.  Inside any particular component version
directory, you'll see some distribution/source files, plus
the component-level init and profile scripts, plus some
**action scripts** -- as of today, we're just doing "install"
actions, although someday it might be useful to use "remove",
"upgrade", etc.

> On the other hand, what's an easier way to guarantee confirmation
> of state: installs followed by multiple upgrades, or tear down
> the filesystem and build everything from scratch every time?
> The upgrades-as-you-go path feels quicker and easier, but you
> do introduce ordering vulnerabilities: A then B then C may
> produce a different state than A then C then B.  If you can
> increase the level of automation to make full deployment from
> scratch cheap enough, why not do that instead?  "We start from
> absolute zero, and establish confirmed state layer by layer
> until we're done."

### The Service Side

On the service side, we tree out by service name (just "kuali"
for now); then we split into **properties** and **templates**.
There's one properties file for the service as a whole
(e.g., "kuali.env"), plus additional files for each environment
(e.g., "kuali-dev.env").  On the templates side, there's a
directory for each component that makes up a given service;
inside the component directory are template files that are 
used during the installation of that component into that service
(mostly configuration files).

> Note: things that live under the "components" side of KSI should
> be "stuff that might wind up in most any service".  Things that
> live under the "services" side of KSI are "things that have to
> be customized for each individual service and environment". YMMV.

If you look through the template files, you'll see that they're
littered with "{{placeholder}}" markers; if you look inside the
properties files, you'll find variables that match up with the
placeholders.  During installation of a component, the placeholders
in the templates get replaced with the variable definitions from
the properties files.  As a side effect, looking at the properties
files is a good way to quickly figure out what's different between
service environments.

So we have a big tree of standard components with installation
scripting and other bits of wiring; and a big tree of services
with templates and property files that define what is specific
to any given component inside a particular service.

## What Happens When You Run KSI

> The "ksi.sh" is basically a boot-strapping script -- it intermediates
> between the user and the KSI system, helping to set things up
> and call the appropriate action script to do installation tasks.
> You could do all of that work without "ksi.sh", but the goal is
> to automate and standardize the repetitive bits as much as 
> possible.

### Parsing of Command Line Arguments

For any given KSI action, you need to know six things specific
to the action, and six more that are more contextual to the
environment in which the action is invoked.  The internals of KSI
know to look for all of those things in specific environment
variables; "ksi.sh" sets them up and exports them for you based
on the command-line parameters (and other things that it knows
how to check) that you feed to it:

*   "SERVICE\_NAME" comes from the "-s" parameter.

*   "SERVICE\_ENVIRONMENT" comes from the "-e" parameter.

*   "SERVICE\_USER" gets figured out from the user running "ksi.sh".

*   "SERVICE\_GROUP" gets determined likewise.

*   "COMPONENT\_NAME" comes from the "-c" parameter.

*   "COMPONENT\_VERSION" comes from the "-v" parameter.

*   "COMPONENT\_INDEX" comes from the "-i" parameter.

*   "COMPONENT\_ACTION" comes from the "-a" parameter.

*   "INSTALLER\_REPOSITORY" gets figured out from the path where "ksi.sh"
    lives when it's invoked.

*   "INSTALLER\_HOME\_ROOT" defaults to /opt, but can be overridden
    by setting "KSI\_HOME" before invoking the "ksi.sh".

*   "INSTALLER\_HOME\_CONFIG" defaults to /etc/opt, override by
    setting "KSI\_CONFIG").

*   "INSTALLER\_BASE\_ROOT" defaults to /var/opt (override via
    "KSI\_ROOT").

### Sourcing of Helper Scripts

There are four "helper" scripts that are then sourced into "ksi.sh":

*   "\_setup.sh", which establishes and exports convenience 
    environment variables for every single path-of-interest that
    might be of use when running an action script -- there are
    extensive comments in that file that are also worth reading
    to get a feel for the default directory structure that KSI
    is going to build when installing service components.  The
    goal here is to never have to hardcode any path information
    anywhere in one of the installation scripts -- you should pretty
    much be able to just use the environment variables.

*   "\_custom.sh", which loads in four sets of properties, in the
    following order:

    *   Component properties (settings specific to a particular
        component, like Tomcat or the JDK).

    *   Version properties (settings specific to a particular
        version of a component, e.g. Tomcat 7.0.28, JDK 1.6.0_33).

    *   Service properties (settings specific to a particular
        service, like Kuali).

    *   Environment properties (settings specific to a particular
        environment for a service, e.g. Kuali DEV).

    These environment variables get added to the things that are
    visible in the installation script, again attempting to get
    away from hardcoding anything; additionally, they're used to
    do the placeholder replacements when running template files
    through the "process_template" function (see below).

> Note that this isn't quite optimized yet: most of the
> higher-level properties files are empty at this point, with all
> of the settings living down in the version and environment
> files -- some of those settings could probably migrate upwards
> into the component and service files.

> Also note that we're overloading the word "environment" rather
> badly at this point: it can now mean either the "service 
> environment" (DEV, TST, STG, etc.) or alternatively just plain
> old UNIX "environment variables" -- no good way to get around
> this, as using "environment" for the service side is already
> deep in KATT/UA culture, thus hard to change.  Back at my
> last job, we used "instance" to mean the same thing, e.g.
> "service instances" and "component versions".

*   "\_utilities.sh", which loads up any useful functions that
    can be used in the action scripts; the only thing here right
    now is the "process\_template()" function, which takes a file
    path as an argument, and outputs (to standard out) that same
    file with all of the "{{placeholder}}" annotations replaced
    by the value of the corresponding environment variable.

*  "\_stub.sh", which quickly checks to make sure that the basic
   directory hierarchy exists in the service directories for
   whatever service is having the action script applied.

> Note that I don't particularly like the stub script -- I think
> maybe this could live somewhere else, but I'm not sure, so
> for now, there it lives.

### Sourcing of the Action Script

Finally, all preliminary wiring established, "ksi.sh" sources in
the desired action script.  The action script takes care of 
everything necessary to accomplish the task, e.g. unpacking and
installing software, calling "configure/make/make install"-type
commands, deriving configuration files from templates, etc.

### Helpful Logfile Retention Suggestion

Lastly, "ksi.sh" suggests a standard location to which you could
choose to copy a log of the output of the run, assuming you 
produced such a log, and are interested in archiving it for
future use.

> Note that if we get fancy enough, there might be a way to 
> automate this, but the tap-dancing of saving output until
> we're far enough along in the process to determine exactly
> where to put that output is more work than it's worth
> for an initial pass.

## Unpacking The KSI Control Structure

The structure that is built under "/etc/opt/(service)" is worth
some quick explanation:

*   Each component and version gets its own subdirectory
    for configuration files et al. (but see note above about
    how many components are happier with these files living
    closer to the base or home).

*   Additionally, under "__control__", there are two sub-structures:

    *   "profile.sh" and "profile.d" provide environment variable
        sourcing for each component, e.g. the JDK likes to have
        JAVA_HOME set, etc.  The "profile.sh" master script just
        sources in anything it finds under "profile.d", so that
        you can drop per-component profile fragments and have them
        automatically included in the overall service profile.  The
        service user administrative account should probably source
        the master "profile.sh" in its shell startup files.

    *   "init.sh" and "init.d" provide a similar structure for 
        SysVinit-style startup/shutdown scripting; the master "init.sh"
        script takes the usual arguments (start, stop, restart) and
        sources whatever it finds inside "init.d" to take care of
        starting and stopping the individual components that make
        up a service; so during component installation, you can drop
        component init fragments that then automatically get 
        integrated into overall service startup/shutdown.

    *   Finally, we set a convenience symlink, "(service)ctl", 
        at the top of the configuration hierarchy, pointed at the
        master "init.sh" script -- this is just to follow the loose
        convention of having control scripts ("apachectl" etc.) for
        various software packages.  If you wanted to integrate a
        service into the OS-level SysVinit scripting, you could
        symlink from "/etc/init.d" et al. over to the service-level
        symlink.

*   Finally, note that the profile and init fragments always start
    with an index number (from the "-i" command line parameter used
    during "ksi.sh" invocation); these are used for sequencing, e.g.
    you usually want your web server to come down first, and your
    database to come down last, and you want them to come back up
    in reverse order.  The indexes let you control this.

## Afterword

For any further questions or comments, contact either Mike 
Simpson (mgsimpson@email.arizona.edu), Josh Shaloo
(shaloo@email.arizona.edu), or Heather Lo (hlo@email.arizona.edu).