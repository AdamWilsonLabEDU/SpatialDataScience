# Version Control (with Git)


# Background

> "The goal of reproducible research is to tie specific instructions to data analysis and experimental data so that scholarship can be recreated, better understood and verified."  <small> Max Kuhn, CRAN Task View: Reproducible Research </small>


## Our work exists on a spectrum of reproducibility
<img src="11_assets/peng-spectrum.jpg" alt="alt text" width="800">

<small>Peng 2011, Science 334(6060) pp. 1226-1227</small>

In this module you will explore the use of software called Git to manage 'versions' of files.  Similar to 'track-changes' in Microsoft Word, Git keeps track of any edits and makes it possible to track who made the change and when.  Git (and other version control software) are most commonly used to manage collaboratively edited code, but it can keep track of any file. 

## Benefits are straightforward

- **Verification & Reliability**: Find and fix bugs. Today's results == tomorrow's.
- **Transparency**: increased citation count, broader impact, improved institutional memory
- **Efficiency**: Reduces duplication of effort. Payoff in the (not so) long run
- **Flexibility**: When you don’t 'point-and-click' you gain many new analytic options.

## Common practices of many scientists

- Enter data in Excel
- Use Excel for data cleaning & descriptive statistics
- Import data into SPSS/SAS/Stata for further analysis
- Use point-and-click options to run statistical analyses
- Copy & paste output to Word document, repeatedly

These steps can be very difficult to reproduce (even for the same person at a later date)!

# Version Control

## Tracking changes with version control 

**Payoffs**

- Eases collaboration
- Can track changes in any file type (ideally plain text)
- Can revert file to any point in its tracked history

**Costs**

- Learning curve

## Git
<img src="11_assets/git.png" alt="alt text" width="30%">

* **Strong support for non-linear development:** Rapid branching and merging,  specific tools for visualizing and navigating a non-linear development history. 
* **Distributed development:** No central server needed, each user has a full copy
* **Efficient handling of large projects:** Designed to manage the Linux OS
* **Cryptographic authentication of history:** The ID of a particular version depends uponthe complete history. Once published, it is not possible to change the old versions without it being noticed. 

## Git Has Integrity
Everything _checksummed_ before storage and then referred by _checksum_. 

> It’s impossible to change the contents of any file or directory without Git knowing. You can’t lose information in transit or get file corruption without Git being able to detect it.

## Checksum
A way of reducing digital information to a unique ID:

<img src="11_assets/checksum.jpg" alt="alt text" width="50%">

A 40-character hexadecimal SHA-1 hash: `24b9da6552252987aa493b52f8696cd6d3b00373`

Git doesn't care about filenames, extensions, etc.  It's the information that matters...

#  Git Tutorial: let's get started


<div class="well">
## Your turn
Take 15 minutes or so at [this site to walk through some basic git commands](https://try.github.io/levels/1/challenges/1)<br>
<a href=https://try.github.io/levels/1/challenges/1> <img src="11_assets/trygit.png" alt="alt text" width="75%"></a>

</div>
</div>

## The 3 states of files

### staged, modified, committed
<img src="11_assets/staging.png" alt="alt text" width="75%">

The important stuff is hidden in the `.git` folder.

## Github
> GitHub is a web-based Git repository hosting service. It offers all of the distributed version control and source code management (SCM) functionality of Git as well as adding its own features. It provides access control and several collaboration features such as bug tracking, feature requests, task management, and wikis for every project. <small> <a href=https://en.wikipedia.org/wiki/GitHub> Wikipedia </a> </small>

There are other ways to use Git, you can host your own server or use another private company, such as BitBucket.


You can think of GitHub as part:

* Server to back up your files
* Website to share your files
* Method to track changes to your files
* Platform to collaboratively develop code (or other files)

### Example: this course website is managed using Git & GitHub

<a href=https://github.com/adammwilson/RDataScience/tree/gh-pages> <img src="11_assets/githubcoursewebsite.png" alt="alt text" width="100%"></a>


## Install Git on your computer

### Windows and OSX
http://git-scm.com/downloads

### Linux
` sudo apt-get install git `
or similar


## Creating an account on [GitHub](github.com)

1. Create a GitHub account at [https://github.com/](https://github.com/)
    * This will be a public account associated with your name
    * Choose a username wisely for future use
    * Don't worry about details, you can fill them in later
2. Create a repository called _demo_
    * Add a brief and informative description
    * Choose "Public"
    * Check the box for "Initialize this repository with a README"
3. Click "Create Repository"


## In RStudio: `clone` the repository

1. Go to RStudio
    * File -> New Project
    * Version Control: Checkout a project from a version control repository
    * Git: Clone a project from a repository
2. Fill in the info:
    * URL: use HTTPS address
    * Create as a subdirectory of: Browse and create a new folder called `GEO503` (or similar)

To set up a connection that doesn't require you to type in your password every time, [see here](GitSSHNotes.html)    

## Commit to GitHub from within RStudio

### Steps:

1. Edit: make changes to a file in the repository you cloned above
2. Stage: tell git which changes you want to commit
3. Commit (with a message)
4. Push: send the updated files to GitHub

## Staging
<img src="11_assets/Stage.png" alt="alt text" width="75%">

Select which changed  files (added, deleted, or edited) you want to commit.

## Committing
<img src="11_assets/Commit.png" alt="alt text" width="100%">

Add a _commit message_ and click commit.

## Syncing (`push`)
<img src="11_assets/Push.png" alt="alt text" width="100%">

Click the green arrow to sync with GitHub.

## Git File Lifecycle

<img src="11_assets/Lifecycle.png" alt="alt text" width="100%">


## Git command line from RStudio

RStudio has limited functionality.  

<img src="11_assets/CommandLine.png" alt="alt text" width="75%">


## Git help

```{}
$ git help <verb>
$ git <verb> --help
$ man git-<verb>
```
For example, you can get the manpage help for the config command by running `git help config`

## Git status
<img src="11_assets/GitCL.png" alt="alt text" width="75%">

Similar to info in git tab in RStudio

## Git config
`git config` shows you all the git configuration settings:

* `user.email`
* `remote.origin.url`  (e.g. to connect to GitHub)

## Branching
Branches used to develop features isolated from each other. 
<img src="11_assets/merge.png" alt="alt text" width="100%">

Default: _master_ branch. Use other branches for development/collaboration and merge them back upon completion.

## Basic Branching

```{}
$ git checkout -b devel   # create new branch and switch to it


$ git checkout master  #switch back to master
$ git merge devel  #merge in changes from devel branch
```
But we won't do much with branching in this course...

## Git can do far more!

Check out the (free) book [ProGIT](https://git-scm.com/book/en/v2)

<img src="11_assets/progit2.png" alt="alt text" width="30%">


Or the [cheatsheet](https://training.github.com/kit/downloads/github-git-cheat-sheet.pdf).

## Philosphy  
Remember, the data and code are _real_, the products (tables, figures) are ephemeral...  


## Git and RMarkdown

### Visualize .md on GitHub

Update the YAML header to keep the markdown file

From this:

```r
title: "Untitled"
author: "Adam M. Wilson"
output: html_document
```

To this:

```r
title: "Demo"
author: "Adam M. Wilson"
output: 
  html_document:
      keep_md: true
```

And click `knit HTML` to generate the output

## Visualize example
<img src="11_assets/ghmd.png" alt="alt text" width="50%">


### Explore markdown<->Git

1. Use _File -> New File -> R Markdown_ to create a new markdown file.  
2. Use the Cheatsheet to add sections (`#` and `##`) and some example narrative.  
3. `Stage`, `Commit`, `Push`!
4. Make more changes then `Stage`, `Commit`, `Push`!
4. Explore the markdown file on your GitHub website.  

<br>


## Motivations: Claerbout's principle

> "An article about computational result is advertising, not scholarship. The actual scholarship is the full software environment, code and data, that produced the result." <small> Claerbout and Karrenbach, Proceedings of the 62nd Annual International Meeting of the Society of Exploration Geophysics. 1992</small>

## Colophon

* [Slides based on Ben Marwick's presentation to the UW Center for Statistics and Social Sciences (12 March 2014)](https://github.com/benmarwick/CSSS-Primer-Reproducible-Research) ([OrcID](http://orcid.org/0000-0001-7879-4531))
* Git Slides based on materials from Dr. Çetinkaya-Rundel
