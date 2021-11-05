+++
title = "Deploying an ox-hugo blog with GitHub Actions"
author = ["Krishan Wyse"]
publishDate = 2020-01-03T00:00:00+00:00
tags = ["blogging", "softdev"]
categories = ["blogging"]
draft = false
+++

The blogging flow [provided](https://ox-hugo.scripter.co/doc/blogging-flow/) by ox-hugo suggests that Markdown files should be
committed to the source repository along with the Org file.  I'm reluctant to do
that because the Markdown files are effectively a build artefact in this flow.
I also couldn't find any information on how to integrate ox-hugo's export
functionality with a continuous integration service.

Fortunately, it's quite simple to do with GitHub Actions.  After following the
instructions for the [hugo-setup](https://github.com/marketplace/actions/hugo-setup) Action ([these](https://github.com/peaceiris/actions-hugo/blob/d006b81d1845f59bb755a221aff0b61bbff15375/README.md) at the time of writing), we must
then export the Org file as part of the workflow.  [set-up-emacs](https://github.com/marketplace/actions/set-up-emacs) will install
emacs and Org.  [ox-hugo](https://github.com/kaushalmodi/ox-hugo) must be cloned separately.  Add a step to the job:

```yaml
- name: Clone Org-mode exporter
  run: git clone https://github.com/kaushalmodi/ox-hugo.git ox-hugo
```

Then add another step to call the export function:

```yaml
- name: Export Org file to Markdown
  run: emacs ./posts.org --batch -L ./ox-hugo -l ox-hugo.el --eval='(org-hugo-export-wim-to-md t)' --kill
```

As written, we are assuming the Org file containing the posts is `posts.org` and
located in the root of the repository.  All applicable subtrees are exported but
the first argument to `org-hugo-export-wim-to-md` dictates that behaviour and
can be changed.

That's it!  You can view my [workflow file](https://github.com/kwyse/kwyse.github.io/blob/5bac2286c9ad84a411b8ac73da12e1f80b6e7c5f/.github/workflows/gh-pages.yml) to see how it looked just after this
change was made.