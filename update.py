#!/usr/bin/python

from os.path import expanduser
from shutil import copytree, rmtree
from subprocess import call

if __name__ == "__main__":
    rmtree("./awesome")
    copytree(expanduser('~')+"/.config/awesome", "./awesome")

    try:
        call(["git", "commit", "-am", raw_input("Commit Message: ")])
        call(["git", "push"])
        print "Update complete!"
    except:
        print "Something went wrong. :/"
