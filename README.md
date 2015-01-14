Facade
============

Facade is a content management and merchandising system spike, using PORO's and non-relational datastores.

It's currently implemented as a Spree extension, but could be generalized to a standard Rails Engine.

**Established ideas / concepts:**

**Elements** - are the basic building blocks of the system, they are individual items like: strings (Element::Text), images (Element::Image), hashes (Element::Data).

Elements can render themselves, using their associated templates (currently just ERB, see TODO's).

There are only some basic Elements defined right now, but we can add more complex Elements over time (or implementations can add their own specific ones).

**Groups** - are arrays of elements grouped together to represent a more complex element on a page, like Element::ImageGroup could represent an image carousel, Element::DataGroup could represent the response to an ElasticSearch or ActiveRecord style query.

Groups can also render themselves (and their child elements).

**Layout** - is the definition of a content managed page, it is made up of many elements. Only used for Admin purposes to ensure / enforce standard page contents.

**Resource** - is a instance of a Layout, (Layouts have many Resources). A resource copies all elements from a Layout and populates them with the relevant content.

The resource delegates rendering to each of it's child elements and combines the output into a single string for inclusion on the HTTP response.

**Areas to be considered**

**Localization** - right now each element has a locale, so maybe localizing is done within a single page, and relevant locale is rendered as required, or maybe we use a different resource for each locale.

**Rendering** - currently we just use Erubis directly, we should look at other options?

**Admin UI** - there is an attempt at creating an Admin UI, but it will need to be JS heavy so I've skipped it for now.

**Validation** - there's already some placeholder validation code present, but Resources will need strict validation enforced.



**Interesting bits to look at**

**app/models/facade/element/** contains the initial element classes.

**sample.rake** Shows how to pragmatically define a Layout and a Page. This is just in place of a working admin UI for now.


Installation
------------

Make sure you have a Spree 3.0.x instance (currently spree/spree master).

You will need Redis installed locally (with no auth).

Add spree_facade to your Gemfile:

```ruby
gem 'spree_facade', github: 'bdq/spree_facade'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_facade:install
```

Setup a sample Layout & Page

```shell
bundle exec rake facade:sample
```

Start server and checkout the sample page:

```shell
bundle exec rails server
open http://localhost:3000/new_products/
```



Copyright (c) 2014 Brian D. Quinn, released under the New BSD License
