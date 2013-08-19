# How to Contribute

We would like to encourage you to contribute to the repository.
This should be as easy as possible for you but there are a few things to consider when contributing.
The following guidelines for contribution should be followed if you want to submit a pull request.

## How to Prepare

* You need a [GitHub account](https://github.com/signup/free)
* Submit an issue ticket to **this repository** for your issue if the is not one yet.
  * If the issue is about a specific cookbook in [rcbops-cookbooks](https://github.com/rcbops-cookbooks), the title
    should start with `[cookbook-name]`, (e.g. `[nova] live-migration block migration`)
	* Describe the issue and include steps to reproduce if it is a bug.
	* Ensure to mention the earliest version that you know is affected.
  * The issue will also be updated by our tracking system with a defect number like so:  `[DE123]: [nova] live-migration block migration`
* If you are able and want to fix this, fork the **cookbook** repository in [rcbops-cookbooks](https://github.com/rcbops-cookbooks) on GitHub
  and make your changes in a "feature branch".

## Make Changes

* In your forked repository, create a feature branch for your upcoming patch. (e.g. `feature-block-migration` or `bugfix-block-migration` or even `de123-block-migration`)
	* **All development happens on the master branch**
  * When in doubt, see previous. :-)
  * Create a branch based on master: `git checkout -b de123-block-migration`.
  * Please avoid working directly on the `master` branch.
* Make sure you stick to the coding style that is used already.
* Make commits of logical units and describe them properly.
* Check for unnecessary whitespace with `git diff --check` before committing.
* If possible, submit tests to your patch / new feature so it can be tested easily.
* Assure nothing is broken by running all the tests. See [TESTING.md](TESTING.md) within each cookbook repository for more detailed information.

## Submit Changes

* Push your changes to a feature branch in your fork of the repository.
* Open a pull request to the original repository and choose the correct original branch (that would be **master**) you want to patch.
	*Advanced users may use [`hub`](https://github.com/defunkt/hub#git-pull-request) gem for that.*
* If not done in commit messages (which you really should do) please reference and update your issue with the code changes. But **please do not close the issue yourself**.
  *Notice: You can [turn your previously filed issues into a pull-request here](http://issue2pr.herokuapp.com/).*
* Even if you have write access to the repository, do not directly push or merge pull-requests. Let another team member review your pull request and approve for repositories not automatically tested by Jenkins.
  In most cases, the build server will take care of applying, testing, and committing your pull request and updating its status on GitHub accordingly.

## Branching/Merging Workflow

A few words about the various branches in this repository, and the cookbook repositories.

* master branch ("trunk"):
  * **All development happens here!**
  * Submit your pull requests to this branch.
  * This branch will be gate tested but is not guaranteed to be a stable or deployable version.

* release branches (folsom, grizzly, etc)
  * **Do not submit pull requests to these branches!**
  * Versions will be tagged after release by QE.
  * Each tag is a stable, deployable release branch for that version of OpenStack
  * No new features will be added.
  * Bug fixes and security fixes will be cherry picked in on an as determined basis.

* version numbers
  * Version numbers are in the form x.y.z (Major, Minor, Revision)
  * Major numbers will be incremented when support for a new version of OpenStack has been added.
  * Minor numbers will be incremented when features are added.
  * Patch numbers will be incremented for bug fixes / security fixes.
  * When a new tag/release is set, it will be applied to the chef-cookbooks *as well as all of the individual cookbook repos*.
    Cookbook metadata will be updated, and the cookbook versions will be incremented to match the tagged release version.

# Additional Resources

* [General chef-cookbooks documentation](README.md)
* [General GitHub documentation](http://help.github.com/)
* [GitHub pull request documentation](http://help.github.com/send-pull-requests/)
