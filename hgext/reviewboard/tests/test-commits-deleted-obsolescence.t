  changeset:  6:0b3e14fe3ff1
  changeset:  7:bce658a3f6d6
  changeset:  8:713878e22d95
  changeset:  9:4d0f846364eb
  changeset:  10:4e50148c492d
  $ hg strip -r 4e50148c492d --no-backup
  changeset:  6:0b3e14fe3ff1
  changeset:  7:bce658a3f6d6
  changeset:  8:713878e22d95
  changeset:  9:4d0f846364eb
    p2rb.reviewer_map: '{}'
  commit_extra_data:
    p2rb.commits: '[["0b3e14fe3ff19019110705e72dcf563c0ef551f6", 2], ["bce658a3f6d6aa04bf5c449e0e779e839de4690e",
      3], ["713878e22d952d478e88bfdef897fdfc73060351", 4], ["4d0f846364eb509a1b6ae3294f05439101f6e7d3",
      5], ["4e50148c492dde95397cd666f2d4e4ad4fd2176f", 6]]'
  approval_failure: Commit 0b3e14fe3ff19019110705e72dcf563c0ef551f6 is not approved.
      p2rb.reviewer_map: '{}'
    commit_extra_data:
      p2rb.commits: '[["0b3e14fe3ff19019110705e72dcf563c0ef551f6", 2], ["bce658a3f6d6aa04bf5c449e0e779e839de4690e",
        3], ["713878e22d952d478e88bfdef897fdfc73060351", 4], ["4d0f846364eb509a1b6ae3294f05439101f6e7d3",
    p2rb.reviewer_map: '{}'
  commit_extra_data:
    p2rb.commits: '[["0b3e14fe3ff19019110705e72dcf563c0ef551f6", 2], ["bce658a3f6d6aa04bf5c449e0e779e839de4690e",
      3], ["713878e22d952d478e88bfdef897fdfc73060351", 4], ["4d0f846364eb509a1b6ae3294f05439101f6e7d3",
  approval_failure: Commit 0b3e14fe3ff19019110705e72dcf563c0ef551f6 is not approved.
  description:
  - Bug 1 - Foo 5
  - ''
  - 'MozReview-Commit-ID: JmjAjw'
  commit_extra_data:
    p2rb.commit_id: 4e50148c492dde95397cd666f2d4e4ad4fd2176f
    base_commit_id: 4d0f846364eb509a1b6ae3294f05439101f6e7d3
  $ hg -q rebase -s bce658a3f6d6 -d 0
  changeset:  10:eeb6d49dcb09
  changeset:  11:607f375f35c0
  changeset:  12:81ee86efd38f
    p2rb.reviewer_map: '{}'
  commit_extra_data:
    p2rb.commits: '[["0b3e14fe3ff19019110705e72dcf563c0ef551f6", 2], ["bce658a3f6d6aa04bf5c449e0e779e839de4690e",
      3], ["713878e22d952d478e88bfdef897fdfc73060351", 4], ["4d0f846364eb509a1b6ae3294f05439101f6e7d3",
  approval_failure: Commit 0b3e14fe3ff19019110705e72dcf563c0ef551f6 is not approved.
      p2rb.reviewer_map: '{"3": [], "2": [], "5": [], "4": []}'
    commit_extra_data:
      p2rb.commits: '[["eeb6d49dcb0950d771959358f662cf2e5ddc9dc1", 3], ["607f375f35c0866a8e08bc1d6aaecc6ad259ed6e",
        4], ["81ee86efd38ff60717aeeeff153292e84e58be0b", 5]]'
  description:
  - Bug 1 - Foo 1
  - ''
  - 'MozReview-Commit-ID: 124Bxg'
  commit_extra_data:
    p2rb.commit_id: 0b3e14fe3ff19019110705e72dcf563c0ef551f6
  $ hg -q rebase -s 81ee86efd38f -d eeb6d49dcb09
  changeset:  10:eeb6d49dcb09
  changeset:  13:a27a94c54524
    p2rb.reviewer_map: '{"3": [], "5": [], "4": []}'
  commit_extra_data:
    p2rb.commits: '[["eeb6d49dcb0950d771959358f662cf2e5ddc9dc1", 3], ["a27a94c54524d4331dec2f92f647067bfd6dfbd4",
  approval_failure: Commit eeb6d49dcb0950d771959358f662cf2e5ddc9dc1 is not approved.

Deleting a commit and adding a commit will not recycle a review request
because the new commit is logically different

  $ hg -q up eeb6d49dcb09

  $ echo foo6 > foo6
  $ hg -q commit -A -m 'Bug 1 - Foo 6'
  $ hg --config mozreview.autopublish=true push
  pushing to ssh://$DOCKER_HOSTNAME:$HGPORT6/test-repo
  searching for changes
  remote: adding changesets
  remote: adding manifests
  remote: adding file changes
  remote: added 1 changesets with 1 changes to 1 files (+1 heads)
  remote: recorded push in pushlog
  submitting 2 changesets for review
  
  changeset:  10:eeb6d49dcb09
  summary:    Bug 1 - Foo 2
  review:     http://$DOCKER_HOSTNAME:$HGPORT1/r/3
  
  changeset:  14:3b99865d1bab
  summary:    Bug 1 - Foo 6
  review:     http://$DOCKER_HOSTNAME:$HGPORT1/r/7 (draft)
  
  review id:  bz://1/mynick
  review url: http://$DOCKER_HOSTNAME:$HGPORT1/r/1 (draft)
  (review requests lack reviewers; visit review url to assign reviewers)
  (visit review url to publish these review requests so others can see them)

  $ rbmanage dumpreview 1
  id: 1
  status: pending
  public: true
  bugs:
  - '1'
  commit: bz://1/mynick
  submitter: default+5
  summary: bz://1/mynick
  description: This is the parent review request
  target_people: []
  extra_data:
    calculated_trophies: true
    p2rb.reviewer_map: '{"3": [], "5": [], "4": []}'
  commit_extra_data:
    p2rb: true
    p2rb.base_commit: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
    p2rb.commits: '[["eeb6d49dcb0950d771959358f662cf2e5ddc9dc1", 3], ["a27a94c54524d4331dec2f92f647067bfd6dfbd4",
      5]]'
    p2rb.discard_on_publish_rids: '[5]'
    p2rb.first_public_ancestor: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
    p2rb.identifier: bz://1/mynick
    p2rb.is_squashed: true
    p2rb.unpublished_rids: '[7]'
  diffs:
  - id: 1
    revision: 1
    base_commit_id: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
    name: diff
    extra: {}
    patch:
    - diff --git a/foo1 b/foo1
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo1
    - '@@ -0,0 +1,1 @@'
    - +foo1
    - diff --git a/foo2 b/foo2
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo2
    - '@@ -0,0 +1,1 @@'
    - +foo2
    - diff --git a/foo3 b/foo3
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo3
    - '@@ -0,0 +1,1 @@'
    - +foo3
    - diff --git a/foo4 b/foo4
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo4
    - '@@ -0,0 +1,1 @@'
    - +foo4
    - diff --git a/foo5 b/foo5
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo5
    - '@@ -0,0 +1,1 @@'
    - +foo5
    - ''
  - id: 7
    revision: 2
    base_commit_id: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
    name: diff
    extra: {}
    patch:
    - diff --git a/foo1 b/foo1
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo1
    - '@@ -0,0 +1,1 @@'
    - +foo1
    - diff --git a/foo2 b/foo2
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo2
    - '@@ -0,0 +1,1 @@'
    - +foo2
    - diff --git a/foo3 b/foo3
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo3
    - '@@ -0,0 +1,1 @@'
    - +foo3
    - diff --git a/foo4 b/foo4
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo4
    - '@@ -0,0 +1,1 @@'
    - +foo4
    - ''
  - id: 8
    revision: 3
    base_commit_id: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
    name: diff
    extra: {}
    patch:
    - diff --git a/foo2 b/foo2
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo2
    - '@@ -0,0 +1,1 @@'
    - +foo2
    - diff --git a/foo3 b/foo3
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo3
    - '@@ -0,0 +1,1 @@'
    - +foo3
    - diff --git a/foo4 b/foo4
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo4
    - '@@ -0,0 +1,1 @@'
    - +foo4
    - ''
  - id: 12
    revision: 4
    base_commit_id: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
    name: diff
    extra: {}
    patch:
    - diff --git a/foo2 b/foo2
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo2
    - '@@ -0,0 +1,1 @@'
    - +foo2
    - diff --git a/foo4 b/foo4
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo4
    - '@@ -0,0 +1,1 @@'
    - +foo4
    - ''
  approved: false
  approval_failure: Commit eeb6d49dcb0950d771959358f662cf2e5ddc9dc1 is not approved.
  draft:
    bugs:
    - '1'
    commit: bz://1/mynick
    summary: bz://1/mynick
    description: This is the parent review request
    target_people: []
    extra:
      calculated_trophies: true
      p2rb.reviewer_map: '{"3": [], "5": []}'
    commit_extra_data:
      p2rb: true
      p2rb.base_commit: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
      p2rb.commits: '[["eeb6d49dcb0950d771959358f662cf2e5ddc9dc1", 3], ["3b99865d1bab8480235d913f4bcfc951fd9e3032",
        7]]'
      p2rb.discard_on_publish_rids: '[]'
      p2rb.first_public_ancestor: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
      p2rb.identifier: bz://1/mynick
      p2rb.is_squashed: true
      p2rb.unpublished_rids: '[]'
    diffs:
    - id: 14
      revision: 5
      base_commit_id: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
      name: diff
      extra: {}
      patch:
      - diff --git a/foo2 b/foo2
      - new file mode 100644
      - '--- /dev/null'
      - +++ b/foo2
      - '@@ -0,0 +1,1 @@'
      - +foo2
      - diff --git a/foo6 b/foo6
      - new file mode 100644
      - '--- /dev/null'
      - +++ b/foo6
      - '@@ -0,0 +1,1 @@'
      - +foo6
      - ''

Review request 5 (whose commit was deleted) should be discarded

  $ rbmanage dumpreview 5
  id: 5
  status: pending
  public: true
  bugs:
  - '1'
  commit: null
  submitter: default+5
  summary: Bug 1 - Foo 4
  description:
  - Bug 1 - Foo 4
  - ''
  - 'MozReview-Commit-ID: F63vXs'
  target_people: []
  extra_data:
    calculated_trophies: true
  commit_extra_data:
    p2rb: true
    p2rb.commit_id: a27a94c54524d4331dec2f92f647067bfd6dfbd4
    p2rb.first_public_ancestor: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
    p2rb.identifier: bz://1/mynick
    p2rb.is_squashed: false
  diffs:
  - id: 5
    revision: 1
    base_commit_id: 713878e22d952d478e88bfdef897fdfc73060351
    name: diff
    extra: {}
    patch:
    - diff --git a/foo4 b/foo4
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo4
    - '@@ -0,0 +1,1 @@'
    - +foo4
    - ''
  - id: 11
    revision: 2
    base_commit_id: 607f375f35c0866a8e08bc1d6aaecc6ad259ed6e
    name: diff
    extra: {}
    patch:
    - diff --git a/foo4 b/foo4
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo4
    - '@@ -0,0 +1,1 @@'
    - +foo4
    - ''
  - id: 13
    revision: 3
    base_commit_id: eeb6d49dcb0950d771959358f662cf2e5ddc9dc1
    name: diff
    extra: {}
    patch:
    - diff --git a/foo4 b/foo4
    - new file mode 100644
    - '--- /dev/null'
    - +++ b/foo4
    - '@@ -0,0 +1,1 @@'
    - +foo4
    - ''
  approved: false
  approval_failure: A suitable reviewer has not given a "Ship It!"

  $ rbmanage dumpreview 7
  id: 7
  status: pending
  public: false
  bugs: []
  commit: null
  submitter: default+5
  summary: ''
  description: ''
  target_people: []
  extra_data: {}
  commit_extra_data:
    p2rb: true
    p2rb.identifier: bz://1/mynick
    p2rb.is_squashed: false
  diffs: []
  approved: false
  approval_failure: The review request is not public.
  draft:
    bugs:
    - '1'
    commit: null
    summary: Bug 1 - Foo 6
    description:
    - Bug 1 - Foo 6
    - ''
    - 'MozReview-Commit-ID: OTOPw0'
    target_people: []
    extra: {}
    commit_extra_data:
      p2rb: true
      p2rb.commit_id: 3b99865d1bab8480235d913f4bcfc951fd9e3032
      p2rb.first_public_ancestor: 93d9429b41ecf0d2ad8c62b6ea26686dd20330f4
      p2rb.identifier: bz://1/mynick
      p2rb.is_squashed: false
    diffs:
    - id: 15
      revision: 1
      base_commit_id: eeb6d49dcb0950d771959358f662cf2e5ddc9dc1
      name: diff
      extra: {}
      patch:
      - diff --git a/foo6 b/foo6
      - new file mode 100644
      - '--- /dev/null'
      - +++ b/foo6
      - '@@ -0,0 +1,1 @@'
      - +foo6
      - ''