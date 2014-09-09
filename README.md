#Finder API

##Purpose
Finder API has historically been used for two purposes:

1. To serve schemas containing details about filterable fields.
  These schemas are used for:
  * Generating lists of filters in [alphagov/finder-frontend](https://github.com/alphagov/finder-frontend).
  * Converting metadata keys into human-readable values in
    [alphagov/specialist-frontend](https://github.com/alphagov/specialist-frontend).
2. As a search backend for [alphagov/finder-frontend](https://github.com/alphagov/finder-frontend).
  * This behaviour has been deprecated -- [alphagov/rummager](https://github.com/alphagov/rummager) will
    replace this in [alphagov/finder-frontend](https://github.com/alphagov/finder-frontend)

##Deprecation warning
Due to rummager replacing finder-api as a search backend, the only route that should be in use within finder-api is:

`GET /finders/:finder_slug/schema.json`

All other routes are deprecated.

##Running the application

```
$ ./startup.sh
```

If you are using the GDS development virtual machine then the application will be available on the host at [http://finder-api.dev.gov.uk/](http://finder-api.dev.gov.uk/)

##Running the test suite

```
$ bundle exec rake
```
