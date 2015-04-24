# Xapian Sorting Remote Database


## Preconditions

* Can `ssh localhost`
* Have xapian and ruby bindings installed

## Run the tests
Test that it works for local sorting:
```bash
$ ./sort_test_local.rb
In order: 100
```

Test that it fails for remote sorting:
```bash
$ ./sort_test_remote.rb
Out of order: 100
```
