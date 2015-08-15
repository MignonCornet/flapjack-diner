# Flapjack::Diner

[![Travis CI Status][id_travis_img]][id_travis_link]

[id_travis_link]: https://travis-ci.org/flapjack/flapjack-diner
[id_travis_img]: https://travis-ci.org/flapjack/flapjack-diner.png

Access the JSON API of a [Flapjack](http://flapjack.io/) system monitoring server.

Please note that the following documentation refers to the `v2.0.0-alpha.3` pre-release of this gem. You may instead be looking for [documentation for the latest stable version](https://github.com/flapjack/flapjack-diner/blob/maint/1.x/README.md).

## Installation

Add this line to your application's Gemfile:

    gem 'flapjack-diner', :github => 'flapjack/flapjack-diner'

And then execute:

    $ bundle

Note, you can also install from [RubyGems.org](https://rubygems.org/gems/flapjack-diner) as usual.

## Usage

Set the URI of the Flapjack server:

```ruby
Flapjack::Diner.base_uri('127.0.0.1:5000')
```

Optionally, set a logger to log requests & responses:

```ruby
Flapjack::Diner.logger = Logger.new('logs/flapjack_diner.log')
```

If you want to alter timeout periods for HTTP connection open and reading responses:

```ruby
# Set HTTP connect timeout to 30 seconds
Flapjack::Diner.open_timeout(30)

# Set HTTP read timeout to 5 minutes
Flapjack::Diner.read_timeout(300)
```

If you want the old behaviour wrt returning hashes with keys as strings (they're now symbols by default) then:

```ruby
Flapjack::Diner.return_keys_as_strings = true
```

## Functions

Options for all of **flapjack-diner**'s functions are organised as either:

* Ids &emdash; One or more String or Integer values; or
* Parameters &emdash; One or more Hashes

While these can be passed in in any order, the convention is that they will be ordered as listed above.

If any operation fails (returning nil), the `Flapjack::Diner.last_error` method will return an error message regarding the failure.

<a name="contents_section_checks">&nbsp;</a>
### <a name="contents_section_checks">&nbsp;</a>[Checks](#section_checks)

* <a name="contents_create_checks">&nbsp;</a>[create_checks](#create_checks)
* <a name="contents_checks">&nbsp;</a>[checks](#get_checks)
* <a name="contents_update_checks">&nbsp;</a>[update_checks](#update_checks)
* <a name="contents_delete_checks">&nbsp;</a>[delete_checks](#delete_checks)

### <a name="contents_section_contacts">&nbsp;</a>[Contacts](#section_contacts)

* <a name="contents_create_contacts">&nbsp;</a>[create_contacts](#create_contacts)
* <a name="contents_contacts">&nbsp;</a>[contacts](#get_contacts)
* <a name="contents_update_contacts">&nbsp;</a>[update_contacts](#update_contacts)
* <a name="contents_delete_contacts">&nbsp;</a>[delete_contacts](#delete_contacts)

### <a name="contents_section_media">&nbsp;</a>[Media](#section_media)

* <a name="contents_create_media">&nbsp;</a>[create_media](#create_media)
* <a name="contents_media">&nbsp;</a>[media](#get_media)
* <a name="contents_update_media">&nbsp;</a>[update_media](#update_media)
* <a name="contents_delete_media">&nbsp;</a>[delete_media](#delete_media)

### <a name="contents_section_acceptors">&nbsp;</a>[Acceptors](#section_acceptors)

* <a name="contents_create_acceptors">&nbsp;</a>[create_acceptors](#create_acceptors)
* <a name="contents_acceptors">&nbsp;</a>[acceptors](#get_acceptors)
* <a name="contents_update_acceptors">&nbsp;</a>[update_acceptors](#update_acceptors)
* <a name="contents_delete_acceptors">&nbsp;</a>[delete_acceptors](#delete_acceptors)

### <a name="contents_section_rejectors">&nbsp;</a>[Rejectors](#section_rejectors)

* <a name="contents_create_rejectors">&nbsp;</a>[create_rejectors](#create_rejectors)
* <a name="contents_rejectors">&nbsp;</a>[rejectors](#get_rejectors)
* <a name="contents_update_rejectors">&nbsp;</a>[update_rejectors](#update_rejectors)
* <a name="contents_delete_rejectors">&nbsp;</a>[delete_rejectors](#delete_rejectors)

### <a name="contents_section_tags">&nbsp;</a>[Tags](#section_tags)

* <a name="contents_create_tags">&nbsp;</a>[create_tags](#create_tags)
* <a name="contents_tags">&nbsp;</a>[tags](#get_tags)
* <a name="contents_update_tags">&nbsp;</a>[update_tags](#update_tags)
* <a name="contents_delete_tags">&nbsp;</a>[delete_tags](#delete_tags)

### <a name="contents_section_maintenance_periods">&nbsp;</a>[Maintenance periods](#section_maintenance_periods)

* <a name="contents_create_scheduled_maintenances">&nbsp;</a>[create_scheduled_maintenances](#create_scheduled_maintenances)
* <a name="contents_scheduled_maintenances">&nbsp;</a>[scheduled_maintenances](#get_scheduled_maintenances)
* <a name="contents_update_scheduled_maintenances">&nbsp;</a>[update_scheduled_maintenances](#update_scheduled_maintenances)
* <a name="contents_delete_scheduled_maintenances">&nbsp;</a>[delete_scheduled_maintenances](#delete_scheduled_maintenances)
* <a name="contents_unscheduled_maintenances">&nbsp;</a>[unscheduled_maintenances](#get_unscheduled_maintenances)
* <a name="contents_update_unscheduled_maintenances">&nbsp;</a>[update_unscheduled_maintenances](#update_unscheduled_maintenances)
* <a name="contents_delete_unscheduled_maintenances">&nbsp;</a>[delete_unscheduled_maintenances](#delete_unscheduled_maintenances)

### <a name="contents_section_events">&nbsp;</a>[Events](#section_events)

* <a name="contents_create_acknowledgements">&nbsp;</a>[create_acknowledgements](#create_acknowledgements)
* <a name="contents_create_test_notifications">&nbsp;</a>[create_test_notifications](#create_test_notifications)

### <a name="contents_section_miscellaneous">&nbsp;</a>[Miscellaneous](#section_miscellaneous)

* <a name="contents_states">&nbsp;</a>[states](#get_states)
* <a name="contents_metrics">&nbsp;</a>[metrics](#get_metrics)
* <a name="contents_statistics">&nbsp;</a>[statistics](#get_statistics)

---

<a name="section_checks">&nbsp;</a>
### Checks [^](#contents_section_checks)

<a name="create_checks">&nbsp;</a>
### create_checks

Create one or more checks.

```ruby
Flapjack::Diner.create_checks(CHECK, ...)
```

```
CHECK
{
  :id      => STRING,
  :name    => STRING,
  :enabled => BOOLEAN,
  :tags    => [TAG_NAME, ...]
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_checks)

<a name="get_checks">&nbsp;</a>
### checks

Return data for one, some or all checks.

```ruby
check = Flapjack::Diner.checks(CHECK_ID)
some_checks = Flapjack::Diner.checks(CHECK_ID, CHECK_ID, ...)
first_page_of_checks = Flapjack::Diner.checks
```

[^](#contents_checks)

<a name="update_checks">&nbsp;</a>
### update_checks

Update data for one or more checks.

```ruby
# update values for one check
Flapjack::Diner.update_checks(CHECK_ID, KEY => VALUE, ...)

# update values for multiple checks
Flapjack::Diner.update_checks({CHECK_ID, KEY => VALUE, ...}, {CHECK_ID, KEY => VALUE, ...})
```

Acceptable update field keys are

`:enabled`, `:name` and `:tags`

Returns true if updating succeeded or false if updating failed.

[^](#contents_update_checks)

<a name="delete_checks">&nbsp;</a>
#### delete_checks

Delete one or more checks.

```ruby
# delete one check
Flapjack::Diner.delete_checks(CHECK_ID)

# delete multiple check
Flapjack::Diner.delete_checks(CHECK_ID, CHECK_ID, ...)
```

Returns true if deletion succeeded or false if deletion failed.

[^](#contents_delete_checks)

---

<a name="section_contacts">&nbsp;</a>
### Contacts [^](#contents_section_contacts)

<a name="create_contacts">&nbsp;</a>
#### create_contacts

Create one or more contacts.

```ruby
Flapjack::Diner.create_contacts(CONTACT, ...)
```

```
CONTACT
{
  :id => STRING,
  :name => STRING,
  :timezone => STRING,
  :tags => [TAG_NAME, ...]
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_contacts)

<a name="get_contacts">&nbsp;</a>
#### contacts

Return data for one, some or all contacts.

```ruby
contact = Flapjack::Diner.contacts(CONTACT_ID)
some_contacts = Flapjack::Diner.contacts(CONTACT_ID, CONTACT_ID, ...)
first_page_of_contacts = Flapjack::Diner.contacts
```

[^](#contents_contacts)

<a name="update_contacts">&nbsp;</a>
#### update_contacts

Update data for one or more contacts.

```ruby
# update values for one contact
Flapjack::Diner.update_contacts(CONTACT_ID, KEY => VALUE, ...)

# update values for multiple contacts
Flapjack::Diner.update_contacts({CONTACT_ID, KEY => VALUE, ...}, {CONTACT_ID, KEY => VALUE, ...})
```

Acceptable update field keys are

`:name`, `:timezone` and `:tags`

Returns true if updating succeeded, false if updating failed.

[^](#contents_update_contacts)

<a name="delete_contacts">&nbsp;</a>
#### delete_contacts

Delete one or more contacts.

```ruby
# delete one contact
Flapjack::Diner.delete_contacts(CONTACT_ID)

# delete multiple contacts
Flapjack::Diner.delete_contacts(CONTACT_ID, CONTACT_ID, ...)
```

Returns true if deletion succeeded or false if deletion failed.

[^](#contents_delete_contacts)

---

<a name="section_media">&nbsp;</a>
### Media [^](#contents_section_media)

<a name="create_media">&nbsp;</a>
#### create_media

Create one or more notification media.

```ruby
Flapjack::Diner.create_media(MEDIUM, MEDIUM, ...)
```

```ruby
# MEDIUM
{
  :id => UUID,
  :transport => STRING,               # required
  :address => STRING,                 # required (context depends on transport)
  :interval => INTEGER,               # required (if transport != 'pagerduty')
  :rollup_threshold => INTEGER,       # required (if transport != 'pagerduty')
  :pagerduty_subdomain => STRING,     # required (if transport == 'pagerduty')
  :pagerduty_token => STRING,         # required (if transport == 'pagerduty')
  :pagerduty_ack_duration => INTEGER, # required (if transport == 'pagerduty')
  :contact => CONTACT_ID,             # required
  :acceptors => [ACCEPTOR_ID, ACCEPTOR_ID, ...],
  :rejectors => [REJECTOR_ID, REJECTOR_ID, ...]
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_media)

<a name="get_media">&nbsp;</a>
#### media

Return data for one, some or all notification media.

```ruby
medium = Flapjack::Diner.media(MEDIUM_ID)
some_media = Flapjack::Diner.media(MEDIUM_ID, MEDIUM_ID, ...)
first_page_of_media = Flapjack::Diner.media
```

[^](#contents_media)

<a name="update_media">&nbsp;</a>
#### update_media

Update data for one or more notification media.

```ruby
# update values for one medium
Flapjack::Diner.update_media(MEDIUM_ID, KEY => VALUE, ...)

# update values for multiple media
Flapjack::Diner.update_media({MEDIUM_ID, KEY => VALUE, ...}, {MEDIUM_ID, KEY => VALUE, ...})
```

Acceptable update field keys are

`:address`, `:interval`, `:rollup_threshold`, `:pagerduty_subdomain`, `:pagerduty_token`, `:pagerduty_ack_duration`, `:acceptors` and `:rejectors`

Returns true if updating succeeded or false if updating failed.

[^](#contents_update_media)

<a name="delete_media">&nbsp;</a>
#### delete_media

Delete one or more notification media.

```ruby
# delete one medium
Flapjack::Diner.delete_media(MEDIUM_ID)

# delete multiple media
Flapjack::Diner.delete_media(MEDIUM_ID, MEDIUM_ID, ...)
```

Returns true if deletion succeeded or false if deletion failed.

[^](#contents_delete_media)

---

<a name="section_acceptors">&nbsp;</a>
### Acceptors [^](#contents_section_acceptors)

<a name="create_acceptors">&nbsp;</a>
#### create_acceptors

Create one or more notification acceptors.

```ruby
Flapjack::Diner.create_acceptors(ACCEPTOR, ...)
```

**FIXME** time_restrictions data structure isn't handled yet

```ruby
# ACCEPTOR
{
  :id              => UUID_STRING,
  :name            => STRING,
  :all             => BOOLEAN,          # apply to all checks, ignore tag linkages
  :conditions_list => STRING,           # which conditions the acceptor will match;
                                        # all if empty, or comma-separated subset
                                        # of 'critical,warning,unknown'
  :contact         => CONTACT_ID,       # required
  :media           => [MEDIUM_ID, ...]
  :tags            => [TAG_NAME, ...]
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_acceptors)

<a name="get_acceptors">&nbsp;</a>
#### acceptors

Return data for one, some or all notification acceptors.

```ruby
acceptor = Flapjack::Diner.acceptors(ACCEPTOR_ID)
some_acceptors = Flapjack::Diner.acceptors(ACCEPTOR_ID, ACCEPTOR_ID, ...)
first_page_of_acceptors = Flapjack::Diner.acceptors
```

[^](#contents_acceptors)

<a name="update_acceptors">&nbsp;</a>
#### update_acceptors

Update data for one or more notification acceptors.

```ruby
# update values for one acceptor
Flapjack::Diner.update_acceptors(:id => ACCEPTOR_ID, KEY => VALUE, ...)

# update values for multiple acceptors
Flapjack::Diner.update_acceptors({:id => ACCEPTOR_ID, KEY => VALUE, ...}, {:id => ACCEPTOR_ID, KEY => VALUE, ...})
```

Acceptable update field keys are

  `:conditions_list`, `:is_blackhole`, `:media` and `:tags`

Returns true if updating succeeded or false if updating failed.

[^](#contents_update_acceptors)

<a name="delete_acceptors">&nbsp;</a>
#### delete_acceptors

Delete one or more notification acceptors.

```ruby
# delete one acceptor
Flapjack::Diner.delete_acceptors(ACCEPTOR_ID)

# delete multiple acceptors
Flapjack::Diner.delete_acceptors(ACCEPTOR_ID, ACCEPTOR_ID, ...)
```

Returns true if deletion succeeded or false if deletion failed.

[^](#contents_delete_acceptors)

---

<a name="section_rejectors">&nbsp;</a>
### Rules [^](#contents_section_rejectors)

<a name="create_rejectors">&nbsp;</a>
#### create_rejectors

Create one or more notification rejectors.

```ruby
Flapjack::Diner.create_rejectors(REJECTOR, ...)
```

**FIXME** time_restrictions data structure isn't handled yet

```ruby
# REJECTOR
{
  :id              => UUID_STRING,
  :name            => STRING,
  :all             => BOOLEAN,          # apply to all checks, ignore tag linkages
  :conditions_list => STRING,           # which conditions the rejector will match;
                                        # all if empty, or comma-separated subset
                                        # of 'critical,warning,unknown'
  :contact         => CONTACT_ID,       # required
  :media           => [MEDIUM_ID, ...]
  :tags            => [TAG_NAME, ...]
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_rejectors)

<a name="get_rejectors">&nbsp;</a>
#### rejectors

Return data for one, some or all notification rejectors.

```ruby
rejector = Flapjack::Diner.rejectors(REJECTOR_ID)
some_rejectors = Flapjack::Diner.rejectors(REJECTOR_ID, REJECTOR_ID, ...)
first_page_of_rejectors = Flapjack::Diner.rejectors
```

[^](#contents_rejectors)

<a name="update_rejectors">&nbsp;</a>
#### update_rejectors

Update data for one or more notification rejectors.

```ruby
# update values for one rejector
Flapjack::Diner.update_rejectors(:id => REJECTOR_ID, KEY => VALUE, ...)

# update values for multiple rejectors
Flapjack::Diner.update_rejectors({:id => REJECTOR_ID, KEY => VALUE, ...}, {:id => REJECTOR_ID, KEY => VALUE, ...})
```

Acceptable update field keys are

  `:conditions_list`, `:is_blackhole`, `:media` and `:tags`

Returns true if updating succeeded or false if updating failed.

[^](#contents_update_rejectors)

<a name="delete_rejectors">&nbsp;</a>
#### delete_rejectors

Delete one or more notification rejectors.

```ruby
# delete one rejector
Flapjack::Diner.delete_rejectors(REJECTOR_ID)

# delete multiple rejectors
Flapjack::Diner.delete_rejectors(REJECTOR_ID, REJECTOR_ID, ...)
```

Returns true if deletion succeeded or false if deletion failed.

[^](#contents_delete_rejectors)

---

<a name="section_tags">&nbsp;</a>
### Tags [^](#contents_section_tags)

<a name="create_tags">&nbsp;</a>
#### create_tags

Create one or more tags.

```ruby
Flapjack::Diner.create_tags(TAG, ...)
```

```ruby
# TAG
{
  :name      => STRING,         # required
  :checks    => [CHECK_ID, ...],
  :acceptors => [ACCEPTOR_ID, ...],
  :rejectors => [REJECTOR_ID, ...]
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_tags)

<a name="get_tags">&nbsp;</a>
#### tags

Return data for one, some or all tags.

```ruby
tag = Flapjack::Diner.tags(TAG_NAME)
some_tags = Flapjack::Diner.tags(TAG_NAME, TAG_NAME, ...)
first_page_of_tags = Flapjack::Diner.tags
```

[^](#contents_tags)

<a name="update_tags">&nbsp;</a>
#### update_tags

Update data for one or more tags.

```ruby
# update values for one tag
Flapjack::Diner.update_tags(:id => TAG_NAME, KEY => VALUE, ...)

# update values for multiple tags
Flapjack::Diner.update_tags({:id => TAG_NAME, KEY => VALUE, ...}, {:id => TAG_NAME, KEY => VALUE, ...})
```

Acceptable update field keys are

  `:checks`, `:acceptors` and `:rejectors`

Returns true if updating succeeded or false if updating failed.

[^](#contents_update_tags)

<a name="delete_tags">&nbsp;</a>
#### delete_tags

Delete one or more tags.

```ruby
# delete one tag
Flapjack::Diner.delete_tags(TAG_NAME)

# delete multiple tags
Flapjack::Diner.delete_tags(TAG_NAME, TAG_NAME, ...)
```

Returns true if deletion succeeded or false if deletion failed.

[^](#contents_delete_tags)

---

<a name="section_maintenance_periods">&nbsp;</a>
### Maintenance periods [^](#contents_section_maintenance_periods)

<a name="create_scheduled_maintenances">&nbsp;</a>
### create_scheduled_maintenances

Create one or more scheduled maintenance periods (`duration` seconds in length) on one or more checks.

```ruby
Flapjack::Diner.create_scheduled_maintenances(SCHEDULED_MAINTENANCE, ...)
```

```ruby
SCHEDULED_MAINTENANCE
{
  :id => UUID,
  :start_time => DATETIME, # required
  :end_time => DATETIME,   # required
  :summary => STRING,
  :check => CHECK_ID,      # one (and only one) of :check or :tag must be provided
  :tag => TAG_NAME         # :tag will create scheduled maintenance periods for all checks that this tag is associated with
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_scheduled_maintenances)

<a name="get_scheduled_maintenances">&nbsp;</a>
### scheduled_maintenances

Return data for one, some or all scheduled maintenance periods.

```ruby
scheduled_maintenance = Flapjack::Diner.scheduled_maintenances(SCHEDULED_MAINTENANCE_ID)
some_scheduled_maintenances = Flapjack::Diner.scheduled_maintenances(SCHEDULED_MAINTENANCE_ID, SCHEDULED_MAINTENANCE_ID, ...)
first_page_of_scheduled_maintenances = Flapjack::Diner.scheduled_maintenances
```

[^](#contents_scheduled_maintenances)

<a name="update_scheduled_maintenances">&nbsp;</a>
### update_scheduled_maintenances

Update data for one or more scheduled maintenance periods.

```ruby
# update values for one scheduled maintenance period
Flapjack::Diner.update_scheduled_maintenances(:id => SCHEDULED_MAINTENANCE_ID, KEY => VALUE, ...)

# update values for multiple scheduled maintenance periods
Flapjack::Diner.update_scheduled_maintenances({:id => SCHEDULED_MAINTENANCE_ID, KEY => VALUE, ...}, {:id => SCHEDULED_MAINTENANCE_ID, KEY => VALUE, ...})
```

Acceptable update field keys are

  `:start_time`, `:end_time` and `:summary`

Returns true if updating succeeded or false if updating failed.

**FIXME** we may make it a configuration setting as to whether times in the past may be edited

[^](#contents_update_scheduled_maintenances)

<a name="delete_scheduled_maintenances">&nbsp;</a>
### delete_scheduled_maintenances

Delete one or more scheduled maintenance periods.

```ruby
Flapjack::Diner.delete_scheduled_maintenances(SCHEDULED_MAINTENANCE_ID)
Flapjack::Diner.delete_scheduled_maintenances(SCHEDULED_MAINTENANCE_ID, SCHEDULED_MAINTENANCE_ID, ...)
```

Returns true if deletion succeeded or false if deletion failed.

**FIXME** we may make it a configuration setting as to whether scheduled maintenance periods that have already started (or finished) may be deleted

[^](#contents_delete_scheduled_maintenances)

<a name="get_unscheduled_maintenances">&nbsp;</a>
### unscheduled_maintenances

Return data for one, some or all unscheduled maintenance periods.

```ruby
unscheduled_maintenance = Flapjack::Diner.unscheduled_maintenances(UNSCHEDULED_MAINTENANCE_ID)
some_unscheduled_maintenances = Flapjack::Diner.unscheduled_maintenances(UNSCHEDULED_MAINTENANCE_ID, UNSCHEDULED_MAINTENANCE_ID, ...)
first_page_of_unscheduled_maintenances = Flapjack::Diner.unscheduled_maintenances
```

[^](#contents_unscheduled_maintenances)

<a name="update_unscheduled_maintenances">&nbsp;</a>
### update_unscheduled_maintenances

Update data for one or more unscheduled maintenance periods.

```ruby
Flapjack::Diner.update_unscheduled_maintenances(:id => UNSCHEDULED_MAINTENANCE_ID, KEY => VALUE)

Flapjack::Diner.update_unscheduled_maintenances({:id => UNSCHEDULED_MAINTENANCE_ID, KEY => VALUE},
  {:id => UNSCHEDULED_MAINTENANCE_ID, KEY => VALUE}, ...)
```

Acceptable update field keys are

  `:start_time`, `:end_time` and `:summary`

Returns true if updating succeeded or false if updating failed.

**FIXME** we may make it a configuration setting as to whether times in the past may be edited

[^](#contents_update_unscheduled_maintenances)

<a name="delete_unscheduled_maintenances">&nbsp;</a>
### delete_unscheduled_maintenances

Delete one or more unscheduled maintenance periods.

```ruby
Flapjack::Diner.delete_unscheduled_maintenances(UNSCHEDULED_MAINTENANCE_ID)
Flapjack::Diner.delete_unscheduled_maintenances(UNSCHEDULED_MAINTENANCE_ID, UNSCHEDULED_MAINTENANCE_ID, ...)
```

Returns true if deletion succeeded or false if deletion failed.

**FIXME** we may make it a configuration setting as to whether unscheduled maintenance periods may be deleted

[^](#contents_delete_unscheduled_maintenances)

---

<a name="section_events">&nbsp;</a>
### Events [^](#contents_section_events)

<a name="create_acknowledgements">&nbsp;</a>
### create_acknowledgements

Acknowledges any failing checks from those passed and sets up unscheduled maintenance (`duration` seconds long) on them.

```ruby
Flapjack::Diner.create_acknowledgements(ACKNOWLEDGEMENT, ...)
```

```ruby
# ACKNOWLEDGEMENT
{
  :summary => STRING,
  :duration => INTEGER,
  :check => CHECK_ID,   # one (and only one) of :check or :tag must be provided
  :tag => TAG_NAME      # :tag will acknowledge all failing checks that this tag is associated with
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_acknowledgements)

<a name="create_test_notifications">&nbsp;</a>
### create_test_notifications

Instructs Flapjack to issue test notifications on the passed checks. These notifications will be sent to contacts configured to receive notifications for those checks.

```ruby
Flapjack::Diner.create_test_notifications(TEST_NOTIFICATION, ...)
```

```ruby
# TEST_NOTIFICATION
{
  :summary => STRING,
  :check => CHECK_ID, # one (and only one) of :check or :tag must be provided
  :tag => TAG_NAME    # :tag will send test notifications for all checks that this tag is associated with
}
```

Returns false if creation failed, or the created object(s) if it succeeded.

[^](#contents_create_test_notifications)

---

<a name="section_miscellaneous">&nbsp;</a>
### Miscellaneous [^](#contents_section_miscellaneous)

<a name="get_states">&nbsp;</a>
### states

Return data for one, some or all check states.

```ruby
states = Flapjack::Diner.states(STATE_ID)
some_states = Flapjack::Diner.states(STATE_ID, STATE_ID, ...)
first_page_of_states = Flapjack::Diner.states
```

[^](#contents_states)

<a name="get_metrics">&nbsp;</a>
### metrics

Return global metric data for the flapjack instance (i.e. all components backed by the shared data store).

```ruby
metrics = Flapjack::Diner.metrics
```

[^](#contents_metrics)

<a name="get_statistics">&nbsp;</a>
### statistics

Return data for one, some or all flapjack processor instances.

```ruby
statistics = Flapjack::Diner.statistics(STATISTICS_ID)
some_statistics = Flapjack::Diner.statistics(STATISTICS_ID, STATISTICS_ID, ...)
first_page_of_statistics = Flapjack::Diner.statistics
```

[^](#contents_statistics)

---

<a name="common_options_get">&nbsp;</a>
### Common options for all GET requests

| Option       |  Type                       | Description |
|--------------|-----------------------------|-------------|
| `:fields`    |  String or Array of Strings | Limit the fields of `:include`d records |
| `:filter`    |  Hash                       | Resources must match query terms |
| `:include`   |  String or Array of Strings | Full resources to return with the response |
| `:sort`      |  String or Array of Strings | How the resources should be sorted |
| `:page`      |  Integer, > 0               | Page number |
| `:per_page`  |  Integer, > 0               | Number of resources per page |


<a name="common_options_get_include">&nbsp;</a>
### Associated data allowed for the include parameter

| Method                      |  Association                      | Assoc. Type                    |
|-----------------------------|-----------------------------------|--------------------------------|
| `.checks`                   | 'alerting_media'                  | ['medium', ...]                |
| `.checks`                   | 'contacts'                        | ['contact', ...]               |
| `.checks`                   | 'current_scheduled_maintenances'  | ['scheduled_maintenance', ...] |
| `.checks`                   | 'current_state'                   | 'state'                        |
| `.checks`                   | 'current_unscheduled_maintenance' | 'unscheduled_maintenance'      |
| `.checks`                   | 'latest_notifications'            | ['state', ...]                 |
| `.checks`                   | 'tags'                            | ['tag', ...]                   |
| `.contacts`                 | 'acceptors'                       | ['acceptor', ...]              |
| `.contacts`                 | 'checks'                          | ['check', ...]                 |
| `.contacts`                 | 'media'                           | ['medium', ...]                |
| `.contacts`                 | 'rejectors'                       | ['rejector', ...]              |
| `.media`                    | 'acceptors'                       | ['acceptor', ...]              |
| `.media`                    | 'alerting_checks'                 | ['check', ...]                 |
| `.media`                    | 'contact'                         | 'contact'                      |
| `.media`                    | 'rejectors'                       | ['rejector', ...]              |
| `.acceptors`                | 'contact'                         | 'contact'                      |
| `.acceptors`                | 'media'                           | ['medium', ...]                |
| `.acceptors`                | 'tags'                            | ['tag', ...]                   |
| `.rejectors`                | 'contact'                         | 'contact'                      |
| `.rejectors`                | 'media'                           | ['medium', ...]                |
| `.rejectors`                | 'tags'                            | ['tag', ...]                   |
| `.scheduled_maintenances`   | 'check'                           | 'check'                        |
| `.states`                   | 'check'                           | 'check'                        |
| `.tags`                     | 'acceptors'                       | ['acceptor', ...]              |
| `.tags`                     | 'checks'                          | ['check', ...]                 |
| `.tags`                     | 'rejectors'                       | ['acceptor', ...]              |
| `.unscheduled_maintenances` | 'check'                           | 'check'                        |

NB: these may be chained, as long as they follow the allowed paths above; e.g.

```ruby
Flapjack::Diner.contacts(CONTACT_ID, :include => 'media.alerting_checks')
```

The above will include both the contact's media *and* any alerting checks in extra data accessible via the `Flapjack::Diner.context` method; specifically, from the value held for`:included` key in the resulting Hash.

---

<a name="object_relationships_read">&nbsp;</a>
### Retrieving object relationships

The following operations are supported: they will all return data in the format

```ruby
{:type => LINKED_TYPE, :id => UUID}
```

(for singular resources), or

```ruby
[{:type => LINKED_TYPE, :id => UUID}, {:type => LINKED_TYPE, :id => UUID}, ...]
```

for multiple resources.

```
check_link_alerting_media(check_id, opts = {})
check_link_contacts(check_id, opts = {})
check_link_current_scheduled_maintenances(check_id, opts = {})
check_link_current_state(check_id, opts = {})
check_link_current_unscheduled_maintenance(check_id, opts = {})
check_link_latest_notifications(check_id, opts = {})
check_link_scheduled_maintenances(check_id, opts = {})
check_link_states(check_id, opts = {})
check_link_tags(check_id, opts = {})
check_link_unscheduled_maintenances(check_id, opts = {})

contact_link_acceptors(contact_id, opts = {})
contact_link_checks(contact_id, opts = {})
contact_link_media(contact_id, opts = {})
contact_link_rejectors(contact_id, opts = {})

medium_link_acceptors(medium_id, opts = {})
medium_link_alerting_checks(medium_id, opts = {})
medium_link_contact(medium_id, opts = {})
medium_link_rejectors(medium_id, opts = {})

acceptor_link_contact(acceptor_id, opts = {})
acceptor_link_media(acceptor_id, opts = {})
acceptor_link_tags(acceptor_id, opts = {})

rejector_link_contact(rejector_id, opts = {})
rejector_link_media(rejector_id, opts = {})
rejector_link_tags(rejector_id, opts = {})

state_link_check(state_id, opts = {})

tag_link_acceptors(tag_name, opts = {})
tag_link_checks(tag_name, opts = {})
tag_link_rejectors(tag_name, opts = {})
tag_link_scheduled_maintenances(tag_name, opts = {})
tag_link_states(tag_name, opts = {})
tag_link_unscheduled_maintenances(tag_name, opts = {})
```

All returned results are paginated, and the [common options for GET requests](#common_options_get) apply here too.

<a name="object_relationships_write">&nbsp;</a>
### Manipulating object relationships

The following operations are supported; please note that some associations (e.g. associating an acceptor with a contact) must be made on object creation, via the secondary resource's create method, and cannot be altered later.

```
create_check_link_tags(check_id, *tags_names)
update_check_link_tags(check_id, *tags_names)
delete_check_link_tags(check_id, *tags_names)

create_medium_link_acceptors(medium_id, *acceptors_ids)
update_medium_link_acceptors(medium_id, *acceptors_ids)
delete_medium_link_acceptors(medium_id, *acceptors_ids)

create_medium_link_rejectors(medium_id, *rejectors_ids)
update_medium_link_rejectors(medium_id, *rejectors_ids)
delete_medium_link_rejectors(medium_id, *rejectors_ids)

create_acceptor_link_media(acceptor_id, *media_ids)
update_acceptor_link_media(acceptor_id, *media_ids)
delete_acceptor_link_media(acceptor_id, *media_ids)

create_acceptor_link_tags(acceptor_id, *tags_names)
update_acceptor_link_tags(acceptor_id, *tags_names)
delete_acceptor_link_tags(acceptor_id, *tags_names)

create_rejector_link_media(rejector_id, *media_ids)
update_rejector_link_media(rejector_id, *media_ids)
delete_rejector_link_media(rejector_id, *media_ids)

create_rejector_link_tags(rejector_id, *tags_names)
update_rejector_link_tags(rejector_id, *tags_names)
delete_rejector_link_tags(rejector_id, *tags_names)

create_tag_link_checks(tag_name, *checks_ids)
update_tag_link_checks(tag_name, *checks_ids)
delete_tag_link_checks(tag_name, *checks_ids)

create_tag_link_acceptors(tag_name, *acceptors_ids)
update_tag_link_acceptors(tag_name, *acceptors_ids)
delete_tag_link_acceptors(tag_name, *acceptors_ids)

create_tag_link_rejectors(tag_name, *rejectors_ids)
update_tag_link_rejectors(tag_name, *rejectors_ids)
delete_tag_link_rejectors(tag_name, *rejectors_ids)
```

<a name="object_relationships_write_create">&nbsp;</a>
#### `create_{resource}_link_{related}`

Creates new links between the `resource` represented by the first argument and the `related` resources represented by the rest of the arguments. At least one `related` resource identifier must be provided. If the `related` resource is already linked, it is skipped.

<a name="object_relationships_write_update">&nbsp;</a>
#### `update_{resource}_link_{related}`

Replace all current links between the `resource` represented by the first argument with the `related` resources represented by the rest of the arguments. If there are no further arguments, removes all current links of that type for the `resource`, otherwise removes any not present in the passed `related` resources and adds any that are passed but not already present.

<a name="object_relationships_write_delete">&nbsp;</a>
#### `delete_{resource}_link_{related}`

Remove the link between the `resource` represented by the first argument, and the `related` resources represented by the rest of the arguments. If there is no link for a related resource, deletion is skipped for that linkage.

---

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
