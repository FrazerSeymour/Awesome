#!/usr/bin/python

from os.path import expanduser
from shutil import copytree, rmtree
from subprocess import call

if __name__ == "__main__":
    rmtree("./awesome")
    copytree(expanduser('~')+"/.config/awesome", "./awesome")

    try:
        call(["hg", "commit", "-A", "-m", raw_input("Commit Message: ")])
        call(["hg", "push", "ssh://hg@bitbucket.org/FrazerS/awesome-stuff"])
        print "Update comlete!"
    except:
        print "Something went wrong. :/"
