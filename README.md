TODO Terraform module
=====================
TODO description.

Usage
-----

```hcl
module "this" {
  ...
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Tests
-----

This module has been packaged with [awspec](https://github.com/k1LoW/awspec)
tests through test kitchen. To run them:

1. Install [rvm][1] and the ruby version specified in the `Gemfile`
1. Install bundler and the gems from our Gemfile:

    ```bash
    gem install bundler && bundle install
    ```

1. Test using `bundle exec kitchen test` from the root of the repo.

License
-------

All Rights Reserved. See LICENSE for full details.

Repository Features
===================

setup
-----

1. Install packages

    ```bash
    pip install --user --requirement requirements-dev.txt
    ```

pre-commit
----------

1. Install the pre-commit hook

    ```bash
    pre-commit install
    ```

1. After pre-commit hook has been installed you can run it manually on all files
   in the repository

    ```bash
    pre-commit run -a
    ```

grip
----

1. Render local `README.md` files before sending off to GitHub.

    ```bash
    grip --browser
    ```
  

[1]: https://rvm.io/rvm/install
