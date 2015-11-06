#require hgmodocker

  $ . $TESTDIR/pylib/vcsreplicator/tests/helpers.sh
  $ vcsrenv

Create the repository and push a change

  $ hgmo exec hgssh /create-repo mozilla-central scm_level_1 --non-publishing
  (recorded repository creation in replication log)
  marking repo as non-publishing
  $ hgmo exec hgssh /repo/hg/venv_pash/bin/hg -R /repo/hg/mozilla/mozilla-central replicatehgrc
  recorded hgrc in replication log
  $ standarduser
  $ consumer --onetime
  $ consumer --onetime
  WARNING:vcsreplicator.consumer:created Mercurial repository: $TESTTMP/repos/mozilla-central
  $ consumer --onetime
  WARNING:vcsreplicator.consumer:wrote hgrc: $TESTTMP/repos/mozilla-central/.hg/hgrc

  $ hg -q clone ssh://${SSH_SERVER}:${SSH_PORT}/mozilla-central
  $ cd mozilla-central
  $ touch foo
  $ hg -q commit -A -m initial

  $ hg log -T '{rev} {phase}\n'
  0 draft

  $ hg push
  pushing to ssh://*:$HGPORT/mozilla-central (glob)
  searching for changes
  remote: adding changesets
  remote: adding manifests
  remote: adding file changes
  remote: added 1 changesets with 1 changes to 1 files
  remote: recorded push in pushlog
  remote: legacy replication of changegroup disabled because vcsreplicator is loaded
  remote: 
  remote: View your change here:
  remote:   https://hg.mozilla.org/mozilla-central/rev/77538e1ce4be
  remote: recorded changegroup in replication log in \d\.\d+s (re)

  $ hg log -T '{rev} {phase}\n'
  0 draft

There should be no pushkey on a push with a draft changeset

  $ consumer --dump
  - name: heartbeat-1
  - name: heartbeat-1
  - heads:
    - 77538e1ce4bec5f7aac58a7ceca2da0e38e90a72
    name: hg-changegroup-1
    nodes:
    - 77538e1ce4bec5f7aac58a7ceca2da0e38e90a72
    path: '{moz}/mozilla-central'
    source: serve

  $ consumer --onetime
  $ consumer --onetime
  $ consumer --onetime
  WARNING:vcsreplicator.consumer:pulling 1 heads from ssh://*:$HGPORT/mozilla-central into $TESTTMP/repos/mozilla-central (glob)
  WARNING:vcsreplicator.consumer:pulled 1 changesets into $TESTTMP/repos/mozilla-central

  $ hg -R $TESTTMP/repos/mozilla-central log -T '{rev} {phase}\n'
  0 draft

Locally bumping changeset to public will trigger a pushkey

  $ hg phase --public -r .
  $ hg push
  pushing to ssh://*:$HGPORT/mozilla-central (glob)
  searching for changes
  no changes found
  remote: legacy replication of phases disabled because vcsreplicator is loaded
  remote: recorded updates to phases in replication log in \d\.\d+s (re)
  [1]

  $ consumer --dump
  - name: heartbeat-1
  - name: heartbeat-1
  - key: 77538e1ce4bec5f7aac58a7ceca2da0e38e90a72
    name: hg-pushkey-1
    namespace: phases
    new: '0'
    old: '1'
    path: '{moz}/mozilla-central'
    ret: 1

  $ hg -R $TESTTMP/repos/mozilla-central log -T '{rev} {phase}\n'
  0 draft
  $ consumer --onetime
  $ consumer --onetime
  $ consumer --onetime
  $ hg -R $TESTTMP/repos/mozilla-central log -T '{rev} {phase}\n'
  0 public

Cleanup

  $ hgmo stop
