### Script

**Introduction:**

Thanks for joining me on this PoC walkthrough
for our upcoming manifest builds feature.
In the next few minutes I'll walk you through
the basic idea
and demonstrate how it works.

**Ad-hoc Builds:**

But before we begin, I want to briefly talk about "ad-hoc" builds,
which is what I'm calling that process by which
a developer starts with a source repository
and iteratively hacks as they add packages to figure out
how to perform the build.
If they're lucky, they'll have a `README.md` file to guide their efforts,
and if successful they will end up
with a set of artifacts that can be used or tested in place.

But of course those artifacts can only be used from that one directory,
whereas our developer wants to make their package available for use in
flox environments, and that's where manifest builds come in.

**Flox Manifest Builds:**

The basic idea of the manifest build is simple:
first record those very same ad-hoc build commands
as a script in the manifest,
then when the user runs `flox build` we'll
run that script and scoop up the results into a package.

That all sounds pretty straightforward, and it really is,
right up until the point that you start encountering
the sorts of problems addressed by Nix,
and that's why we offer you two ways of building that package.

The first and default way is
what I call the "in-situ" mode,
and it is as close as you can get
to the "ad hoc" build.
In this mode the build script is invoked from the very same directory,
with no restrictions,
able to see all the same intermediate compilation artifacts
as if running that script on the command line.
Afterwards, Flox will scoop up the
installation path and do some fancy rewriting as it adds it to the Nix store.
Nothing more complicated than that.

After that we have the "sandbox" mode
which you can think of as the canonical Nix "pure" build.
In this mode that very same script is invoked from within a `runCommand()`
derivation with no access to the network or filesystem,
and everything required for the build must come from
the Flox environment or source directory.

Selecting between these two build modes is simply a matter of
defining the `sandbox` attribute in the manifest,
which I'll be demonstrating in a few minutes,
but before I do that I want to briefly speak
to the topics of incremental and staged builds.

**Flox buildCache:**

And by incremental builds I'm simply referring to that ability to
find and use object files created in previous build attempts.

With "in-situ" builds we get this ability "for free"
as we're literally performing the build in the very same directory as before,
but when working in a Nix sandbox we need to take extra steps
to save and restore these compilation artifacts across builds.

Fortunately, Nix provides a way for us to do this
using the `outputs` attribute.
The Flox `buildCache` feature instructs `flox build` to do just that,
restoring a copy of the previous build directory when performing subsequent builds.
As I understand it this is a feature unique to Flox,
and a potential differentiator for us.

**Staged Builds:**

So by this point we know how to record build instructions in the manifest,
and we have two ways to perform a build,
and we have great support for incremental builds,
but what if a build is comprised of multiple logical chunks,
only one of which requires "impure" network or filesystem access?

Fortunately, the Flox manifest supports multiple build stanzas,
indexed by package name,
each of which can specify different build and caching modes,
and these builds can refer to each other
using the canonical Nix `${pkgname}` syntax,
just like you would within a text block in a Nix expression.
Flox will then scan the entire set of build instructions
to derive a dependency graph for the entire series of builds,
substituting package references with their as-built storePaths
in the process.

It all sounds very complicated,
but in practice is easy to use and works extremely well!
We refer to this as the "staged build",
and I'll conclude the demonstration with an example of this approach.

**Demonstration:**

... speaking of which, enough talking! Let's see how this works.

**Stairway to Nix:**

Hopefully that all made sense!

But while our main aim is to provide the means by which to build
and publish a package, we are also looking to guide people along
a path of Nix enlightenment, a journey that Tom refers to as the
"stairway to Nix"!

Given that Flox is based on Nix it's unsurprising that our
manifest build modes have close analogs in the Nix world,
and this slide is my attempt to explore those similarities,
and how we help to guide users along this path to enlightenment.
I won't spend any more of your time to discuss this here,
but it's worth highlighting the ways that our product helps
to introduce Nix concepts in a user-friendly way.

**PoC Implementation overview:**

And just to lift the lid and shine a light on some implementation details,
this PoC is implemented as a 200-line makefile, 100 lines
of Nix expression code, and a trivial wrapper script.
That's pretty much it, and its one input is the rendered Flox environment.
It's installed as a standalone script, which ought to make it sufficiently
modular to be rapidly integrated into the CLI.

Our use of GNUmake also brings with it one other bonus feature,
which is the ability to render the dependency graph as a picture.
Let me quickly flip back to the demo to show you what that looks like ...

**Next steps:**

Of course the first next step
as mentioned in the previous slide
is to integrate the PoC with the Flox CLI,
and I've listed a few thoughts and estimates for that effort here.

In my opinion, the obvious next step would be to optimize the runtime
for manifest build packages.
The current Flox environment only includes a single set of symlinks,
which references all packages from all package groups,
while applications don't usually require all of those packages at runtime.
This effort to render a different runtime "environment"
for wrapping the contents of the `bin` directory
has a strong overlap with PR1268, so will likely be addresed at the same time.

Finally, we need to finish the Nix expression framework effort
so that we have a way to easily add and override Nix expression "recipes",
such as those found in Nixpkgs itself.

**Fine:**

I hope all of that was clear and made sense.
No doubt we'll be tearing it all to shreds in the coming weeks,
and I look forward to it!

Thanks ...
